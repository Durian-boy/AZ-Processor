`ifndef __TIMER_HEADER__
    `define __TIMER_HEADER__		 // 头文件包含保护

    /********** 总线 **********/
    `define TIMER_ADDR_W		2	 // 地址宽度
    `define TimerAddrBus		1:0	 // 地址总线
    `define TimerAddrLoc		1:0	 // 地址的位置
    /********** 地址映射 **********/
    `define TIMER_ADDR_CTRL		2'h0 // 控制寄存器 0 : 控制
    `define TIMER_ADDR_INTR		2'h1 // 控制寄存器 1 : 中断
    `define TIMER_ADDR_EXPR		2'h2 // 控制寄存器 2 : 最大值
    `define TIMER_ADDR_COUNTER	2'h3 // 控制寄存器 3 : 计数器
    /********** 位图 **********/
    // 控制寄存器 0 : 控制
    `define TimerStartLoc		0	 // 起始位的位置
    `define TimerModeLoc		1	 // 模式位的位置
    `define TIMER_MODE_ONE_SHOT 1'b0 // 模式 : 单次定时器
    `define TIMER_MODE_PERIODIC 1'b1 // 模式 : 循环定时器
    // 控制寄存器 1 : 中断请求
    `define TimerIrqLoc			0	 // 中断请求位位置

`endif
