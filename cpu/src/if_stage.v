/********** 通用头文件 **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** 其他头文件 **********/
`include "cpu.h"

module if_stage (
	/********** 时钟和复位 **********/
	input  wire				   clk,			// 时钟
	input  wire				   reset,		// 异步复位
	/********** SPM接口 **********/
	input  wire [`WordDataBus] spm_rd_data, // SPM：读取的数据
	output wire [`WordAddrBus] spm_addr,	// SPM：地址
	output wire				   spm_as_,		// SPM：地址选通
	output wire				   spm_rw,		// SPM：读/写
	output wire [`WordDataBus] spm_wr_data, // XPM：写入的数据
	/********** 总线接口 **********/
	input  wire [`WordDataBus] bus_rd_data, // 总线：读取的数据
	input  wire				   bus_rdy_,	// 总线：就绪
	input  wire				   bus_grnt_,	// 总线：许可
	output wire				   bus_req_,	// 总线：请求
	output wire [`WordAddrBus] bus_addr,	// 总线：地址
	output wire				   bus_as_,		// 总线：地址选通
	output wire				   bus_rw,		// 总线：读/写
	output wire [`WordDataBus] bus_wr_data, // 总线：写入的数据
	/********** 流水线控制信号 **********/
	input  wire				   stall,		// 延迟信号
	input  wire				   flush,		// 刷新信号
	input  wire [`WordAddrBus] new_pc,		// 新程序计数器值
	input  wire				   br_taken,	// 分支成立
	input  wire [`WordAddrBus] br_addr,		// 分支目标地址
	output wire				   busy,		// 总线忙信号
	/********** IF/ID流水线寄存器 **********/
	output wire [`WordAddrBus] if_pc,		// 程序计数器
	output wire [`WordDataBus] if_insn,		// 指令
	output wire				   if_en		// 流水线数据有效标志位
);

	/********** 内部信号 **********/
	wire [`WordDataBus]		   insn;		// 获取的指令

	/********** 总线接口 **********/
	bus_if bus_if (
		/********** 时钟和复位 **********/
		.clk		 (clk),					// 时钟
		.reset		 (reset),				// 异步复位
		/********** 流水线控制信号 **********/
		.stall		 (stall),				// 延迟信号
		.flush		 (flush),				// 刷新信号
		.busy		 (busy),				// 总线忙信号
		/********** CPU接口 **********/
		.addr		 (if_pc),				// CPU：地址
		.as_		 (`ENABLE_),			// CPU：地址有效
		.rw			 (`READ),				// CPU：读/写
		.wr_data	 (`WORD_DATA_W'h0),		// CPU：写入的数据
		.rd_data	 (insn),				// CPU：读取的数据
		/********** SPM接口 **********/
		.spm_rd_data (spm_rd_data),			// SPM：读取的数据
		.spm_addr	 (spm_addr),			// SPM：地址
		.spm_as_	 (spm_as_),				// SPM：地址选通
		.spm_rw		 (spm_rw),				// SPM：读/写
		.spm_wr_data (spm_wr_data),			// SPM：写入的数据
		/********** 总线接口 **********/
		.bus_rd_data (bus_rd_data),			// 总线：读取的数据
		.bus_rdy_	 (bus_rdy_),			// 总线：就绪
		.bus_grnt_	 (bus_grnt_),			// 总线：许可
		.bus_req_	 (bus_req_),			// 总线：请求
		.bus_addr	 (bus_addr),			// 总线：地址
		.bus_as_	 (bus_as_),				// 总线：地址选通
		.bus_rw		 (bus_rw),				// 总线：读/写
		.bus_wr_data (bus_wr_data)			// 总线：写入的数据
	);
   
	/********** IF阶段流水线寄存器 **********/
	if_reg if_reg (
		/********** 时钟和复位 **********/
		.clk		 (clk),					// 时钟
		.reset		 (reset),				// 异步复位
		/********** 读取数据 **********/
		.insn		 (insn),				// 读取的指令
		/********** 流水线控制信号 **********/
		.stall		 (stall),				// 延迟
		.flush		 (flush),				// 刷新
		.new_pc		 (new_pc),				// 新程序计数器值
		.br_taken	 (br_taken),			// 分支成立
		.br_addr	 (br_addr),				// 分支目标地址
		/********** IF/ID流水线寄存器 **********/
		.if_pc		 (if_pc),				// 程序计数器
		.if_insn	 (if_insn),				// 指令
		.if_en		 (if_en)				// 流水线数据有效标志位
	);

endmodule