/********** 通用头文件 **********/
`include "nettype.h"

/********** 模块 **********/
module x_s3e_dcm (
    input  wire CLKIN_IN,		 // 输入时钟
    input  wire RST_IN,			 // 复位
    output wire CLK0_OUT,		 // 时钟（φ0）
    output wire CLK180_OUT,		 // 时钟（φ180）
    output wire LOCKED_OUT		 // 锁定
);

    /********** 时钟输出 **********/
    assign CLK0_OUT	  = CLKIN_IN;
    assign CLK180_OUT = ~CLKIN_IN;  // 180度相位差
    assign LOCKED_OUT = ~RST_IN;
   
endmodule
