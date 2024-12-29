/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "uart.h"

module uart_tx (
    /********** 时钟 & 复位 **********/
    input  wire				   clk,		 // 时钟
    input  wire				   reset,	 // 异步复位
    /********** 控制信号 **********/
    input  wire				   tx_start, // 发送开始信号
    input  wire [`ByteDataBus] tx_data,	 // 发送数据
    output wire				   tx_busy,	 // 发送中标志
    output reg				   tx_end,	 // 发送完成信号
    /********** UART发送信号 **********/
    output reg				   tx		 // UART发送信号
);

    /********** 内部信号 **********/
    reg [`UartStateBus]		   state;	 // 状态
    reg [`UartDivCntBus]	   div_cnt;	 // 分频计数器
    reg [`UartBitCntBus]	   bit_cnt;	 // 位计数器
    reg [`ByteDataBus]		   sh_reg;	 // 发送用移位寄存器

    /********** 生成发送中标志 **********/
    assign tx_busy = (state == `UART_STATE_TX) ? `ENABLE : `DISABLE;

    /********** 发送逻辑 **********/
    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* 异步复位 */
            state	<= #1 `UART_STATE_IDLE;
            div_cnt <= #1 `UART_DIV_RATE;
            bit_cnt <= #1 `UART_BIT_CNT_START;
            sh_reg	<= #1 `BYTE_DATA_W'h0;
            tx_end	<= #1 `DISABLE;
            tx		<= #1 `UART_STOP_BIT;
        end else begin
            /* 发送状态 */
            case (state)
                `UART_STATE_IDLE : begin // 空闲状态
                    if (tx_start == `ENABLE) begin // 发送开始
                        state	<= #1 `UART_STATE_TX;
                        sh_reg	<= #1 tx_data;  // 将要发送的数据存入sh_reg
                        tx		<= #1 `UART_START_BIT;
                    end
                    tx_end	<= #1 `DISABLE;
                end
                `UART_STATE_TX	 : begin // 发送中
                    /* 通过时钟分频调整波特率 */
                    if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // 分频计数器到达零
                        /* 发送下一个数据 */
                        case (bit_cnt)
                            `UART_BIT_CNT_MSB  : begin // 发送停止位
                                bit_cnt <= #1 `UART_BIT_CNT_STOP;
                                tx		<= #1 `UART_STOP_BIT;
                            end
                            `UART_BIT_CNT_STOP : begin // 发送完成
                                state	<= #1 `UART_STATE_IDLE;
                                bit_cnt <= #1 `UART_BIT_CNT_START;
                                tx_end	<= #1 `ENABLE;
                            end
                            default			   : begin // 发送数据位
                                bit_cnt <= #1 bit_cnt + 1'b1;
                                sh_reg	<= #1 sh_reg >> 1'b1;  // sh_reg向右移位
                                tx		<= #1 sh_reg[`LSB];  // 发送she_reg最低位
                            end
                        endcase
                        div_cnt <= #1 `UART_DIV_RATE;
                    end else begin // 计数器递减
                        div_cnt <= #1 div_cnt - 1'b1 ;
                    end
                end
            endcase
        end
    end

endmodule