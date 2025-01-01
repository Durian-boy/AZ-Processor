/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 模块 **********/
module clk_gen (
    /********** 时钟 & 复位 **********/
    input wire	clk_ref,   // 基准时钟
    input wire	reset_sw,  // 复位开关
    /********** 生成时钟 **********/
    output wire clk,	   // 时钟
    output wire clk_,	   // 反转时钟
    /********** 芯片复位 **********/
    output wire chip_reset // 芯片复位
);

    /********** 内部信号 **********/
    wire		locked;	   // 锁定
    wire		dcm_reset; // 复位

    /********** 生成复位信号 **********/
    // DCM复位
    assign dcm_reset  = (reset_sw == `RESET_ENABLE) ? `ENABLE : `DISABLE;
    // 芯片复位
    assign chip_reset = ((reset_sw == `RESET_ENABLE) || (locked == `DISABLE)) ?
                            `RESET_ENABLE : `RESET_DISABLE;

    /********** Xilinx DCM (数字时钟管理器) **********/
    x_s3e_dcm x_s3e_dcm (
        .CLKIN_IN		 (clk_ref),	  // 基准时钟
        .RST_IN			 (dcm_reset), // DCM复位
        .CLK0_OUT		 (clk),		  // 时钟
        .CLK180_OUT		 (clk_),	  // 反转时钟
        .LOCKED_OUT		 (locked)	  // 锁定
   );

endmodule
