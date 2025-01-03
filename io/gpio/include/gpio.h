`ifndef __GPIO_HEADER__
    `define __GPIO_HEADER__			// 头文件包含保护

    /********** 端口数量定义 **********/
    `define GPIO_IN_CH		   4	// 输入端口数量
    `define GPIO_OUT_CH		   18	// 输出端口数量
    `define GPIO_IO_CH		   16	// 输入输出端口数量
  
    /********** 总线 **********/
    `define GpioAddrBus		   1:0	// 地址总线
    `define GPIO_ADDR_W		   2	// 地址宽度
    `define GpioAddrLoc		   1:0	// 地址位置
    /********** 地址映射 **********/
    `define GPIO_ADDR_IN_DATA  2'h0 // 控制寄存器 0 : 输入端口
    `define GPIO_ADDR_OUT_DATA 2'h1 // 控制寄存器 1 : 输出端口
    `define GPIO_ADDR_IO_DATA  2'h2 // 控制寄存器 2 : 输入输出端口
    `define GPIO_ADDR_IO_DIR   2'h3 // 控制寄存器 3 : 输入输出方向
    /********** 输入输出方向 **********/
    `define GPIO_DIR_IN		   1'b0 // 输入
    `define GPIO_DIR_OUT	   1'b1 // 输出

`endif