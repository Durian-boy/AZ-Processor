/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "uart.h"

/********** 模块 **********/
module uart (
    /********** 时钟 & 复位 **********/
    input  wire				   clk,		 // 时钟
    input  wire				   reset,	 // 异步复位
    /********** 总线接口 **********/
    input  wire				   cs_,		 // 片选
    input  wire				   as_,		 // 地址选通
    input  wire				   rw,		 // 读 / 写
    input  wire [`UartAddrBus] addr,	 // 地址
    input  wire [`WordDataBus] wr_data,	 // 写数据
    output wire [`WordDataBus] rd_data,	 // 读数据
    output wire				   rdy_,	 // 就绪
    /********** 中断 **********/
    output wire				   irq_rx,	 // 接收完成中断
    output wire				   irq_tx,	 // 发送完成中断
    /********** UART发送接收信号 **********/
    input  wire				   rx,		 // UART接收信号
    output wire				   tx		 // UART发送信号
);

    /********** 控制信号 **********/
    // 接收控制
    wire					   rx_busy;	 // 接收中标志
    wire					   rx_end;	 // 接收完成信号
    wire [`ByteDataBus]		   rx_data;	 // 接收数据
    // 发送控制
    wire					   tx_busy;	 // 发送中标志
    wire					   tx_end;	 // 发送完成信号
    wire					   tx_start; // 发送开始信号
    wire [`ByteDataBus]		   tx_data;	 // 发送数据

    /********** UART控制模块 **********/
    uart_ctrl uart_ctrl (
        /********** 时钟 & 复位 **********/
        .clk	  (clk),	   // 时钟
        .reset	  (reset),	   // 异步复位
        /********** 总线接口 **********/
        .cs_	  (cs_),	   // 片选
        .as_	  (as_),	   // 地址选通
        .rw		  (rw),		   // 读 / 写
        .addr	  (addr),	   // 地址
        .wr_data  (wr_data),   // 写数据
        .rd_data  (rd_data),   // 读数据
        .rdy_	  (rdy_),	   // 就绪
        /********** 中断 **********/
        .irq_rx	  (irq_rx),	   // 接收完成中断
        .irq_tx	  (irq_tx),	   // 发送完成中断
        /********** 控制信号 **********/
        // 接收控制
        .rx_busy  (rx_busy),   // 接收中标志
        .rx_end	  (rx_end),	   // 接收完成信号
        .rx_data  (rx_data),   // 接收数据
        // 发送控制
        .tx_busy  (tx_busy),   // 发送中标志
        .tx_end	  (tx_end),	   // 发送完成信号
        .tx_start (tx_start),  // 发送开始信号
        .tx_data  (tx_data)	   // 发送数据
    );

    /********** UART发送模块 **********/
    uart_tx uart_tx (
        /********** 时钟 & 复位 **********/
        .clk	  (clk),	   // 时钟
        .reset	  (reset),	   // 异步复位
        /********** 控制信号 **********/
        .tx_start (tx_start),  // 发送开始信号
        .tx_data  (tx_data),   // 发送数据
        .tx_busy  (tx_busy),   // 发送中标志
        .tx_end	  (tx_end),	   // 发送完成信号
        /********** 发送信号 **********/
        .tx		  (tx)		   // UART发送信号
    );

    /********** UART接收模块 **********/
    uart_rx uart_rx (
        /********** 时钟 & 复位 **********/
        .clk	  (clk),	   // 时钟
        .reset	  (reset),	   // 异步复位
        /********** 控制信号 **********/
        .rx_busy  (rx_busy),   // 接收中标志
        .rx_end	  (rx_end),	   // 接收完成信号
        .rx_data  (rx_data),   // 接收数据
        /********** 接收信号 **********/
        .rx		  (rx)		   // UART接收信号
    );

endmodule