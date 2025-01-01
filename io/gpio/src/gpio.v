/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "gpio.h"

/********** 模块 **********/
module gpio (
    /********** 时钟 & 复位 **********/
    input  wire						clk,	 // 时钟
    input  wire						reset,	 // 复位
    /********** 总线接口 **********/
    input  wire						cs_,	 // 片选
    input  wire						as_,	 // 地址选通
    input  wire						rw,		 // 读 / 写
    input  wire [`GpioAddrBus]		addr,	 // 地址
    input  wire [`WordDataBus]		wr_data, // 写数据
    output reg	[`WordDataBus]		rd_data, // 读数据
    output reg						rdy_	 // 就绪
    /********** 通用输入输出端口 **********/
`ifdef GPIO_IN_CH	 // 输入端口的实现
    , input wire [`GPIO_IN_CH-1:0]	gpio_in	 // 输入端口（控制寄存器0）
`endif  // 这里的逗号要放在前面是因为最后一个定义的输入输出不需要逗号
`ifdef GPIO_OUT_CH	 // 输出端口的实现
    , output reg [`GPIO_OUT_CH-1:0] gpio_out // 输出端口（控制寄存器1）
`endif
`ifdef GPIO_IO_CH	 // 输入输出端口的实现
    , inout wire [`GPIO_IO_CH-1:0]	gpio_io	 // 输入输出端口（控制寄存器2）
`endif
);

`ifdef GPIO_IO_CH	 // 输入输出端口的控制
    /********** 输入输出信号 **********/
    wire [`GPIO_IO_CH-1:0]			io_in;	 // GPIO输入输出端口的输入数据
    reg	 [`GPIO_IO_CH-1:0]			io_out;	 // GPIO输入输出端口的输出数据
    reg	 [`GPIO_IO_CH-1:0]			io_dir;	 // GPIO输入输出端口的方向（控制寄存器3）
    reg	 [`GPIO_IO_CH-1:0]			io;		 // 输入输出
    integer							i;		 // 迭代器
   
    /********** 输入输出信号的连续赋值 **********/
    assign io_in	   = gpio_io;			 // 输入数据
    assign gpio_io	   = io;				 // 输入输出

    /********** 输入输出方向的控制 **********/
    always @(*) begin
        for (i = 0; i < `GPIO_IO_CH; i = i + 1) begin : IO_DIR
            io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];  // 1'bz为高阻态
        end
    end

`endif
   
    /********** GPIO的控制 **********/
    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* 异步复位 */
            rd_data	 <= #1 `WORD_DATA_W'h0;
            rdy_	 <= #1 `DISABLE_;
`ifdef GPIO_OUT_CH	 // 输出端口的复位
            gpio_out <= #1 {`GPIO_OUT_CH{`LOW}};
`endif
`ifdef GPIO_IO_CH	 // 输入输出端口的复位
            io_out	 <= #1 {`GPIO_IO_CH{`LOW}};
            io_dir	 <= #1 {`GPIO_IO_CH{`GPIO_DIR_IN}};
`endif
        end else begin
            /* 生成就绪信号 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
                rdy_	 <= #1 `ENABLE_;
            end else begin
                rdy_	 <= #1 `DISABLE_;
            end 
            /* 读访问 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
                case (addr)
`ifdef GPIO_IN_CH	// 读取输入端口
                    `GPIO_ADDR_IN_DATA	: begin // 控制寄存器 0
                        rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}}, 
                                        gpio_in};
                    end
`endif
`ifdef GPIO_OUT_CH	// 读取输出端口
                    `GPIO_ADDR_OUT_DATA : begin // 控制寄存器 1
                        rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}}, 
                                        gpio_out};
                    end
`endif
`ifdef GPIO_IO_CH	// 读取输入输出端口
                    `GPIO_ADDR_IO_DATA	: begin // 控制寄存器 2
                        rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_in};
                     end
                    `GPIO_ADDR_IO_DIR	: begin // 控制寄存器 3
                        rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_dir};
                    end
`endif
                endcase
            end else begin
                rd_data	 <= #1 `WORD_DATA_W'h0;  // 无访问时输出0
            end
            /* 写访问 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)) begin
                case (addr)
`ifdef GPIO_OUT_CH	// 写入输出端口
                    `GPIO_ADDR_OUT_DATA : begin // 控制寄存器 1
                        gpio_out <= #1 wr_data[`GPIO_OUT_CH-1:0];  // 写入控制寄存器0
                    end
`endif
`ifdef GPIO_IO_CH	// 写入输入输出端口
                    `GPIO_ADDR_IO_DATA	: begin // 控制寄存器 2
                        io_out	 <= #1 wr_data[`GPIO_IO_CH-1:0];
                     end
                    `GPIO_ADDR_IO_DIR	: begin // 控制寄存器 3
                        io_dir	 <= #1 wr_data[`GPIO_IO_CH-1:0];
                    end
`endif
                endcase
            end
        end
    end

endmodule