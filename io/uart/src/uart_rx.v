/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "uart.h"

/********** 模块 **********/
module uart_rx (
    /********** 时钟 & 复位 **********/
    input  wire				   clk,		// 时钟
    input  wire				   reset,	// 异步复位
    /********** 控制信号 **********/
    output wire				   rx_busy, // 接收中标志
    output reg				   rx_end,	// 接收完成信号
    output reg	[`ByteDataBus] rx_data, // 接收数据
    /********** UART接收信号 **********/
    input  wire				   rx		// UART接收信号
);

    /********** 内部寄存器 **********/
    reg [`UartStateBus]		   state;	 // 状态
    reg [`UartDivCntBus]	   div_cnt;	 // 分频计数器
    reg [`UartBitCntBus]	   bit_cnt;	 // 位计数器

    /********** 生成接收中标志 **********/
    assign rx_busy = (state != `UART_STATE_IDLE) ? `ENABLE : `DISABLE;

    /********** 接收逻辑 **********/
    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* 异步复位 */
            rx_end	<= #1 `DISABLE;
            rx_data <= #1 `BYTE_DATA_W'h0;
            state	<= #1 `UART_STATE_IDLE;
            div_cnt <= #1 `UART_DIV_RATE / 2;
            bit_cnt <= #1 `UART_BIT_CNT_W'h0;
        end else begin
            /* 接收状态 */
            case (state)
                `UART_STATE_IDLE : begin // 空闲状态
                    if (rx == `UART_START_BIT) begin // 接收开始
                        state	<= #1 `UART_STATE_RX;
                    end
                    rx_end	<= #1 `DISABLE;
                end
                `UART_STATE_RX	 : begin // 接收中
                    /* 通过时钟分频调整波特率 */
                    if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // 分频计数器到达零
                        /* 接收下一个数据 */
                        case (bit_cnt)
                            `UART_BIT_CNT_STOP	: begin // 接收停止位
                                state	<= #1 `UART_STATE_IDLE;
                                bit_cnt <= #1 `UART_BIT_CNT_START;
                                div_cnt <= #1 `UART_DIV_RATE / 2;
                                /* 检查帧错误 */
                                if (rx == `UART_STOP_BIT) begin
                                    rx_end	<= #1 `ENABLE;
                                end
                            end
                            default				: begin // 接收数据位
                                rx_data <= #1 {rx, rx_data[`BYTE_MSB:`LSB+1]};  // 相当于每接收一位就把它插入MSB，其他未向右移一位
                                bit_cnt <= #1 bit_cnt + 1'b1;
                                div_cnt <= #1 `UART_DIV_RATE;
                            end
                        endcase
                    end else begin // 计数器递减
                        div_cnt <= #1 div_cnt - 1'b1;
                    end
                end
            endcase
        end
    end

endmodule