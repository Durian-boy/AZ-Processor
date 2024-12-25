/********** 通用头文件 **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** 其他头文件 **********/
`include "isa.h"
`include "cpu.h"

module ex_stage (
    /********** 时钟和复位 **********/
    input  wire				   clk,			   // 时钟
    input  wire				   reset,		   // 异步复位
    /********** 流水线控制信号 **********/
    input  wire				   stall,		   // 流水线延迟
    input  wire				   flush,		   // 流水线刷新
    input  wire				   int_detect,	   // 中断检测
    /********** 直通 **********/
    output wire [`WordDataBus] fwd_data,	   // 数据直通
    /********** ID/EX流水线寄存器 **********/
    input  wire [`WordAddrBus] id_pc,		   // 程序计数器
    input  wire				   id_en,		   // 流水线数据有效
    input  wire [`AluOpBus]	   id_alu_op,	   // ALU操作
    input  wire [`WordDataBus] id_alu_in_0,	   // ALU输入 0
    input  wire [`WordDataBus] id_alu_in_1,	   // ALU输入 1
    input  wire				   id_br_flag,	   // 分支标志
    input  wire [`MemOpBus]	   id_mem_op,	   // 内存操作
    input  wire [`WordDataBus] id_mem_wr_data, // 内存写入数据
    input  wire [`CtrlOpBus]   id_ctrl_op,	   // 控制寄存器操作
    input  wire [`RegAddrBus]  id_dst_addr,	   // 通用寄存器写入地址
    input  wire				   id_gpr_we_,	   // 通用寄存器写入有效
    input  wire [`IsaExpBus]   id_exp_code,	   // 异常代码
    /********** EX/MEM流水线寄存器 **********/
    output wire [`WordAddrBus] ex_pc,		   // 程序计数器
    output wire				   ex_en,		   // 流水线数据有效
    output wire				   ex_br_flag,	   // 分支标志
    output wire [`MemOpBus]	   ex_mem_op,	   // 内存操作
    output wire [`WordDataBus] ex_mem_wr_data, // 内存写入数据
    output wire [`CtrlOpBus]   ex_ctrl_op,	   // 控制寄存器操作
    output wire [`RegAddrBus]  ex_dst_addr,	   // 通用寄存器写入地址
    output wire				   ex_gpr_we_,	   // 通用寄存器写入有效
    output wire [`IsaExpBus]   ex_exp_code,	   // 异常代码
    output wire [`WordDataBus] ex_out		   // 处理结果
);

    /********** ALU的输出 **********/
    wire [`WordDataBus]		   alu_out;		   // 运算结果
    wire					   alu_of;		   // 溢出

    /********** 运算结果的转发 **********/
    assign fwd_data = alu_out;

    /********** ALU **********/
    alu alu (
        .in_0			(id_alu_in_0),	  // 输入 0
        .in_1			(id_alu_in_1),	  // 输入 1
        .op				(id_alu_op),	  // 操作
        .out			(alu_out),		  // 输出
        .of				(alu_of)		  // 溢出
    );

    /********** 流水线寄存器 **********/
    ex_reg ex_reg (
        /********** 时钟和复位 **********/
        .clk			(clk),			  // 时钟
        .reset			(reset),		  // 异步复位
        /********** ALU的输出 **********/
        .alu_out		(alu_out),		  // 运算结果
        .alu_of			(alu_of),		  // 溢出
        /********** 流水线控制信号 **********/
        .stall			(stall),		  // 流水线延迟
        .flush			(flush),		  // 流水线刷新
        .int_detect		(int_detect),	  // 中断检测
        /********** ID/EX流水线寄存器 **********/
        .id_pc			(id_pc),		  // 程序计数器
        .id_en			(id_en),		  // 流水线数据有效
        .id_br_flag		(id_br_flag),	  // 分支标志
        .id_mem_op		(id_mem_op),	  // 内存操作
        .id_mem_wr_data (id_mem_wr_data), // 内存写入数据
        .id_ctrl_op		(id_ctrl_op),	  // 控制寄存器操作
        .id_dst_addr	(id_dst_addr),	  // 通用寄存器写入地址
        .id_gpr_we_		(id_gpr_we_),	  // 通用寄存器写入有效
        .id_exp_code	(id_exp_code),	  // 异常代码
        /********** EX/MEM流水线寄存器 **********/
        .ex_pc			(ex_pc),		  // 程序计数器
        .ex_en			(ex_en),		  // 流水线数据有效
        .ex_br_flag		(ex_br_flag),	  // 分支标志
        .ex_mem_op		(ex_mem_op),	  // 内存操作
        .ex_mem_wr_data (ex_mem_wr_data), // 内存写入数据
        .ex_ctrl_op		(ex_ctrl_op),	  // 控制寄存器操作
        .ex_dst_addr	(ex_dst_addr),	  // 通用寄存器写入地址
        .ex_gpr_we_		(ex_gpr_we_),	  // 通用寄存器写入有效
        .ex_exp_code	(ex_exp_code),	  // 异常代码
        .ex_out			(ex_out)		  // 处理结果
    );

endmodule