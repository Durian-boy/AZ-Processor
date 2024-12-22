/**********通用头文件**********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/**********其他头文件**********/
`include "cpu.h"
`include "bus.h"

module bus_if (
	/**********时钟和复位**********/
	input  wire				   clk,			   // 时钟
	input  wire				   reset,		   // 异步复位
	/**********流水线控制信号**********/
	input  wire				   stall,		   // 延迟信号
	input  wire				   flush,		   // 刷新信号
	output reg				   busy,		   // 总线忙信号
	/**********CPU接口**********/
	input  wire [`WordAddrBus] addr,		   // CPU：地址
	input  wire				   as_,			   // CPU：地址有效
	input  wire				   rw,			   // CPU：读/写
	input  wire [`WordDataBus] wr_data,		   // CPU：写入的数据
	output reg	[`WordDataBus] rd_data,		   // CPU：读取的数据
	/**********SPM接口**********/
	input  wire [`WordDataBus] spm_rd_data,	   // SPM：读取的数据
	output wire [`WordAddrBus] spm_addr,	   // SPM：地址
	output reg				   spm_as_,		   // SPM：地址选通
	output wire				   spm_rw,		   // SPM：读/写
	output wire [`WordDataBus] spm_wr_data,	   // SPM：写入的数据
	/**********总线接口**********/
	input  wire [`WordDataBus] bus_rd_data,	   // 总线：读取的数据
	input  wire				   bus_rdy_,	   // 总线：就绪
	input  wire				   bus_grnt_,	   // 总线：许可
	output reg				   bus_req_,	   // 总线：请求
	output reg	[`WordAddrBus] bus_addr,	   // 总线：地址
	output reg				   bus_as_,		   // 总线：地址选通
	output reg				   bus_rw,		   // 总线：读/写
	output reg	[`WordDataBus] bus_wr_data	   // 总线：写入的数据
);

	/**********内部信号**********/
	reg	 [`BusIfStateBus]	   state;		   // 总线接口状态
	reg	 [`WordDataBus]		   rd_buf;		   // 读取缓存
	wire [`BusSlaveIndexBus]   s_index;		   // 总线从属索引

	/**********1.内存访问控制（组合电路）**********/
	assign s_index	   = addr[`BusSlaveIndexLoc];   // 使用PC寄存器的高三位生成总线从属索引

	/**********输出的赋值**********/
	assign spm_addr	   = addr;
	assign spm_rw	   = rw;
	assign spm_wr_data = wr_data;
						 
	/**********内存访问的控制**********/
	always @(*) begin
		// 默认值
		rd_data	 = `WORD_DATA_W'h0;
		spm_as_	 = `DISABLE_;
		busy	 = `DISABLE;
		// 判断总线接口的状态
		case (state)
			`BUS_IF_STATE_IDLE	 : begin // 总线接口为空闲状态
				// 内存访问
				if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin
					// 选择访问的目标
					if (s_index == `BUS_SLAVE_1) begin // 做好访问SPM的准备工作
						if (stall == `DISABLE) begin // 检测流水线延迟的发生
							spm_as_	 = `ENABLE_;
							if (rw == `READ) begin // 读取访问
								rd_data	 = spm_rd_data;
							end
						end
					end else begin // 访问总线
						busy	 = `ENABLE;
					end
				end
			end
			`BUS_IF_STATE_REQ	 : begin // 总线接口为请求总线状态
				busy	 = `ENABLE;
			end
			`BUS_IF_STATE_ACCESS : begin // 总线接口为访问总线状态
				// 等待总线就绪信号
				if (bus_rdy_ == `ENABLE_) begin // 就绪信号到达
					if (rw == `READ) begin // 读取访问
						rd_data	 = bus_rd_data;
					end
				end else begin					// 就绪信号未到达
					busy	 = `ENABLE;
				end
			end
			`BUS_IF_STATE_STALL	 : begin // 总线接口为延迟状态
				if (rw == `READ) begin // 读取访问
					rd_data	 = rd_buf;
				end
			end
		endcase
	end

   /**********2.总线接口控制（时序电路）**********/ 
   always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			// 异步复位
			state		<= #1 `BUS_IF_STATE_IDLE;
			bus_req_	<= #1 `DISABLE_;
			bus_addr	<= #1 `WORD_ADDR_W'h0;
			bus_as_		<= #1 `DISABLE_;
			bus_rw		<= #1 `READ;
			bus_wr_data <= #1 `WORD_DATA_W'h0;
			rd_buf		<= #1 `WORD_DATA_W'h0;
		end else begin
			// 判断总线接口的状态（并行检查）
			case (state)
				`BUS_IF_STATE_IDLE	 : begin // 总线接口为空闲状态
					// 内存访问
					if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin 
						// 判断访问目标
						if (s_index != `BUS_SLAVE_1) begin // 访问总线
							state		<= #1 `BUS_IF_STATE_REQ;
							bus_req_	<= #1 `ENABLE_;
							bus_addr	<= #1 addr;
							bus_rw		<= #1 rw;
							bus_wr_data <= #1 wr_data;
						end
					end
				end
				`BUS_IF_STATE_REQ	 : begin // 总线接口为请求总线状态
					// 等待总线许可
					if (bus_grnt_ == `ENABLE_) begin // 获得总线使用权
						state		<= #1 `BUS_IF_STATE_ACCESS;
						bus_as_		<= #1 `ENABLE_;
					end
				end
				`BUS_IF_STATE_ACCESS : begin // 总线接口为访问总线状态
					// 使地址选通无效
					bus_as_		<= #1 `DISABLE_;
					// 等待就绪信号
					if (bus_rdy_ == `ENABLE_) begin // 就绪信号到达
						bus_req_	<= #1 `DISABLE_;
						bus_addr	<= #1 `WORD_ADDR_W'h0;
						bus_rw		<= #1 `READ;
						bus_wr_data <= #1 `WORD_DATA_W'h0;
						// 保存读取到的数据
						if (bus_rw == `READ) begin // 读取访问
							rd_buf		<= #1 bus_rd_data;
						end
						// 检测是否发生延迟
						if (stall == `ENABLE) begin // 发生延迟
							state		<= #1 `BUS_IF_STATE_STALL;
						end else begin				// 未发生延迟
							state		<= #1 `BUS_IF_STATE_IDLE;
						end
					end
				end
				`BUS_IF_STATE_STALL	 : begin // 总线接口为延迟状态
					// 检测是否发生延迟
					if (stall == `DISABLE) begin // 解除延迟状态
						state		<= #1 `BUS_IF_STATE_IDLE;
					end
				end
			endcase
		end
	end

endmodule