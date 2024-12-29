`ifndef __UART_HEADER__
    `define __UART_HEADER__			// 头文件包含保护

/*
 * 【分频说明】
 * ・UART基于芯片的基础频率生成波特率。
 *   如果需要更改基础频率或波特率，
 *   请修改UART_DIV_RATE、UART_DIV_CNT_W和UartDivCntBus：
 * ・UART_DIV_RATE定义了分频率
 *   UART_DIV_RATE是基础频率除以波特率的值
 * ・UART_DIV_CNT_W定义了分频计数器的宽度
 *   UART_DIV_CNT_W是UART_DIV_RATE的log2值
 * ・UartDivCntBus是UART_DIV_CNT_W的总线
 *   请将其定义为UART_DIV_CNT_W-1:0
 *
 * 【分频示例】
 
 * ・如果UART波特率为38,400baud，芯片的基础频率为10MHz，
 *   则UART_DIV_RATE为10,000,000÷38,400，结果为260。
 *   UART_DIV_CNT_W为log2(260)，结果为9。
 */

    /********** 分频计数器 *********/
    `define UART_DIV_RATE	   9'd260  // 分频率
    `define UART_DIV_CNT_W	   9	   // 分频计数器宽度
    `define UartDivCntBus	   8:0	   // 分频计数器总线
    /********** 地址总线 **********/
    `define UartAddrBus		   0:0	// 地址总线
    `define UART_ADDR_W		   1	// 地址宽度
    `define UartAddrLoc		   0:0	// 地址位置
    /********** 地址映射 **********/
    `define UART_ADDR_STATUS   1'h0 // 控制寄存器 0 : 状态
    `define UART_ADDR_DATA	   1'h1 // 控制寄存器 1 : 发送/接收数据
    /********** 位图 **********/
    `define UartCtrlIrqRx	   0	// 接收完成中断
    `define UartCtrlIrqTx	   1	// 发送完成中断
    `define UartCtrlBusyRx	   2	// 接收中标志
    `define UartCtrlBusyTx	   3	// 发送中标志
    /********** 发送/接收状态 **********/
    `define UartStateBus	   0:0	// 状态总线
    `define UART_STATE_IDLE	   1'b0 // 状态 : 空闲
    `define UART_STATE_TX	   1'b1 // 状态 : 发送中
    `define UART_STATE_RX	   1'b1 // 状态 : 接收中
    /********** 位计数器 **********/
    `define UartBitCntBus	   3:0	// 位计数器总线
    `define UART_BIT_CNT_W	   4	// 位计数器宽度
    `define UART_BIT_CNT_START 4'h0 // 计数值 : 起始位
    `define UART_BIT_CNT_MSB   4'h8 // 计数值 : 数据的MSB
    `define UART_BIT_CNT_STOP  4'h9 // 计数值 : 停止位
    /********** 位级别 **********/
    `define UART_START_BIT	   1'b0 // 起始位
    `define UART_STOP_BIT	   1'b1 // 停止位

`endif
