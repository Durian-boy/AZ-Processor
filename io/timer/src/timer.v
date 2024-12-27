/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "timer.h"

/********** 模块 **********/
module timer (
    /********** 时钟 & 复位 **********/
    input  wire					clk,	   // 时钟
    input  wire					reset,	   // 异步复位
    /********** 总线接口 **********/
    input  wire					cs_,	   // 片选
    input  wire					as_,	   // 地址选通
    input  wire					rw,		   // 读/写
    input  wire [`TimerAddrBus] addr,	   // 地址
    input  wire [`WordDataBus]	wr_data,   // 写入数据
    output reg	[`WordDataBus]	rd_data,   // 读取数据
    output reg					rdy_,	   // 就绪

    /********** 中断 **********/
    output reg					irq		   // 中断请求（控制寄存器 1）
);

    /********** 控制寄存器 **********/
    // 控制寄存器 0 : 控制
    reg							mode;	   // 模式位
    reg							start;	   // 启动位
    // 控制寄存器 2 : 最大值
    reg [`WordDataBus]			expr_val;  // 最大值
    // 控制寄存器 3 : 计数器
    reg [`WordDataBus]			counter;   // 计数器

    /********** 满值标志 **********/
    wire expr_flag = ((start == `ENABLE) && (counter == expr_val)) ?
                     `ENABLE : `DISABLE;

    /********** 定时器控制 **********/
    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* 异步复位 */
            rd_data	 <= #1 `WORD_DATA_W'h0;
            rdy_	 <= #1 `DISABLE_;
            start	 <= #1 `DISABLE;
            mode	 <= #1 `TIMER_MODE_ONE_SHOT;
            irq		 <= #1 `DISABLE;
            expr_val <= #1 `WORD_DATA_W'h0;
            counter	 <= #1 `WORD_DATA_W'h0;
        end else begin
            /* 生成就绪信号 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
                rdy_	 <= #1 `ENABLE_;
            end else begin
                rdy_	 <= #1 `DISABLE_;
            end
            /* 读取访问 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
                case (addr)
                    `TIMER_ADDR_CTRL	: begin // 控制寄存器 0
                        rd_data	 <= #1 {{`WORD_DATA_W-2{1'b0}}, mode, start};
                    end
                    `TIMER_ADDR_INTR	: begin // 控制寄存器 1
                        rd_data	 <= #1 {{`WORD_DATA_W-1{1'b0}}, irq};
                    end
                    `TIMER_ADDR_EXPR	: begin // 控制寄存器 2
                        rd_data	 <= #1 expr_val;
                    end
                    `TIMER_ADDR_COUNTER : begin // 控制寄存器 3
                        rd_data	 <= #1 counter;
                    end
                endcase
            end else begin
                rd_data	 <= #1 `WORD_DATA_W'h0;
            end
            /* 写入访问 */
            // 控制寄存器 0
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_CTRL)) begin
                start	 <= #1 wr_data[`TimerStartLoc];
                mode	 <= #1 wr_data[`TimerModeLoc];
            end else if ((expr_flag == `ENABLE)	 &&
                         (mode == `TIMER_MODE_ONE_SHOT)) begin
                start	 <= #1 `DISABLE;
            end
            // 控制寄存器 1
            if (expr_flag == `ENABLE) begin  // 中断请求比写控制寄存器的优先级更高
                irq		 <= #1 `ENABLE;
            end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
                         (rw == `WRITE) && (addr ==	 `TIMER_ADDR_INTR)) begin
                irq		 <= #1 wr_data[`TimerIrqLoc];
            end
            // 控制寄存器 2
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_EXPR)) begin
                expr_val <= #1 wr_data;
            end
            // 控制寄存器 3
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
                (rw == `WRITE) && (addr == `TIMER_ADDR_COUNTER)) begin
                counter	 <= #1 wr_data;
            end else if (expr_flag == `ENABLE) begin
                counter	 <= #1 `WORD_DATA_W'h0;  // 复位计数器
            end else if (start == `ENABLE) begin
                counter	 <= #1 counter + 1'd1;  // 将复位计数器那个周期没有加上的1补加回来
            end
        end
    end

endmodule