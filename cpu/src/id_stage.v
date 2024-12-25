/********** 通用头文件 **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** 其他头文件 **********/
`include "isa.h"
`include "cpu.h"

/********** 模块 **********/
module id_stage (
    /********** 时钟与复位 **********/
    input  wire					 clk,			 // 时钟
    input  wire					 reset,			 // 异步复位
    /********** GPR接口 **********/
    input  wire [`WordDataBus]	 gpr_rd_data_0,	 // 读取数据0
    input  wire [`WordDataBus]	 gpr_rd_data_1,	 // 读取数据1
    output wire [`RegAddrBus]	 gpr_rd_addr_0,	 // 读取地址0
    output wire [`RegAddrBus]	 gpr_rd_addr_1,	 // 读取地址1
    /********** 数据直通 **********/
    // 来自EX阶段的数据直通
    input  wire					 ex_en,			// 流水线数据有效
    input  wire [`WordDataBus]	 ex_fwd_data,	 // 数据直通
    input  wire [`RegAddrBus]	 ex_dst_addr,	 // 写入地址
    input  wire					 ex_gpr_we_,	 // 写入有效
    // 来自MEM阶段的数据直通
    input  wire [`WordDataBus]	 mem_fwd_data,	 // 数据直通
    /********** 控制寄存器接口 **********/
    input  wire [`CpuExeModeBus] exe_mode,		 // 执行模式
    input  wire [`WordDataBus]	 creg_rd_data,	 // 读取的数据
    output wire [`RegAddrBus]	 creg_rd_addr,	 // 读取的地址
    /********** 流水线控制信号 **********/
    input  wire					 stall,			 // 延迟信号
    input  wire					 flush,			 // 刷新信号
    output wire [`WordAddrBus]	 br_addr,		 // 分支地址
    output wire					 br_taken,		 // 分支成立
    output wire					 ld_hazard,		 // Load冒险
    /********** IF/ID流水线寄存器 **********/
    input  wire [`WordAddrBus]	 if_pc,			 // 程序计数器
    input  wire [`WordDataBus]	 if_insn,		 // 指令
    input  wire					 if_en,			 // 流水线数据有效
    /********** ID/EX流水线寄存器 **********/
    output wire [`WordAddrBus]	 id_pc,			 // 程序计数器
    output wire					 id_en,			 // 流水线数据有效
    output wire [`AluOpBus]		 id_alu_op,		 // ALU操作
    output wire [`WordDataBus]	 id_alu_in_0,	 // ALU输入0
    output wire [`WordDataBus]	 id_alu_in_1,	 // ALU输入1
    output wire					 id_br_flag,	 // 分支标志位
    output wire [`MemOpBus]		 id_mem_op,		 // 内存操作
    output wire [`WordDataBus]	 id_mem_wr_data, // 内存写入数据
    output wire [`CtrlOpBus]	 id_ctrl_op,	 // 控制操作
    output wire [`RegAddrBus]	 id_dst_addr,	 // 通用寄存器写入地址
    output wire					 id_gpr_we_,	 // 通用寄存器写入有效
    output wire [`IsaExpBus]	 id_exp_code	 // 异常代码
);

    /********** 解码信号 **********/
    wire  [`AluOpBus]			 alu_op;		 // ALU操作
    wire  [`WordDataBus]		 alu_in_0;		 // ALU输入0
    wire  [`WordDataBus]		 alu_in_1;		 // ALU输入1
    wire						 br_flag;		 // 分支标志位
    wire  [`MemOpBus]			 mem_op;		 // 内存操作
    wire  [`WordDataBus]		 mem_wr_data;	 // 内存写入数据
    wire  [`CtrlOpBus]			 ctrl_op;		 // 控制操作
    wire  [`RegAddrBus]			 dst_addr;		 // 通用寄存器写入地址
    wire						 gpr_we_;		 // 通用寄存器写入有效
    wire  [`IsaExpBus]			 exp_code;		 // 异常代码

    /********** 解码器 **********/
    decoder decoder (
        /********** IF/ID流水线寄存器 **********/
        .if_pc			(if_pc),		  // 程序计数器
        .if_insn		(if_insn),		  // 指令
        .if_en			(if_en),		  // 流水线数据有效
        /********** GPR接口 **********/
        .gpr_rd_data_0	(gpr_rd_data_0),  // 读取数据0
        .gpr_rd_data_1	(gpr_rd_data_1),  // 读取数据1
        .gpr_rd_addr_0	(gpr_rd_addr_0),  // 读取地址0
        .gpr_rd_addr_1	(gpr_rd_addr_1),  // 读取地址1
        /********** 数据直通 **********/
        // 来自ID阶段的数据直通
        .id_en			(id_en),		  // 流水线数据有效
        .id_dst_addr	(id_dst_addr),	  // 写入地址
        .id_gpr_we_		(id_gpr_we_),	  // 写入有效
        .id_mem_op		(id_mem_op),	  // 内存操作
        // 来自EX阶段的数据直通
        .ex_en			(ex_en),		  // 流水线数据有效
        .ex_fwd_data	(ex_fwd_data),	  // 数据直通
        .ex_dst_addr	(ex_dst_addr),	  // 写入地址
        .ex_gpr_we_		(ex_gpr_we_),	  // 写入有效
        // 来自MEM阶段的数据直通
        .mem_fwd_data	(mem_fwd_data),	  // 数据直通
        /********** 控制寄存器接口 **********/
        .exe_mode		(exe_mode),		  // 执行模式
        .creg_rd_data	(creg_rd_data),	  // 读取的数据
        .creg_rd_addr	(creg_rd_addr),	  // 读取的地址
        /********** 解码信号 **********/
        .alu_op			(alu_op),		  // ALU操作
        .alu_in_0		(alu_in_0),		  // ALU输入0
        .alu_in_1		(alu_in_1),		  // ALU输入1
        .br_addr		(br_addr),		  // 分支地址
        .br_taken		(br_taken),		  // 分支成立
        .br_flag		(br_flag),		  // 分支标志位
        .mem_op			(mem_op),		  // 内存操作
        .mem_wr_data	(mem_wr_data),	  // 内存写入数据
        .ctrl_op		(ctrl_op),		  // 控制操作
        .dst_addr		(dst_addr),		  // 通用寄存器写入地址
        .gpr_we_		(gpr_we_),		  // 通用寄存器写入有效
        .exp_code		(exp_code),		  // 异常代码
        .ld_hazard		(ld_hazard)		  // Load冒险
    );

    /********** 流水线寄存器 **********/
    id_reg id_reg (
        /********** 时钟与复位 **********/
        .clk			(clk),			  // 时钟
        .reset			(reset),		  // 异步复位
        /********** 解码结果 **********/
        .alu_op			(alu_op),		  // ALU操作
        .alu_in_0		(alu_in_0),		  // ALU输入0
        .alu_in_1		(alu_in_1),		  // ALU输入1
        .br_flag		(br_flag),		  // 分支标志位
        .mem_op			(mem_op),		  // 内存操作
        .mem_wr_data	(mem_wr_data),	  // 内存写入数据
        .ctrl_op		(ctrl_op),		  // 控制操作
        .dst_addr		(dst_addr),		  // 通用寄存器写入地址
        .gpr_we_		(gpr_we_),		  // 通用寄存器写入有效
        .exp_code		(exp_code),		  // 异常代码
        /********** 流水线控制信号 **********/
        .stall			(stall),		  // 延迟信号
        .flush			(flush),		  // 刷新信号
        /********** IF/ID流水线寄存器 **********/
        .if_pc			(if_pc),		  // 程序计数器
        .if_en			(if_en),		  // 流水线数据有效
        /********** ID/EX流水线寄存器 **********/
        .id_pc			(id_pc),		  // 程序计数器
        .id_en			(id_en),		  // 流水线数据有效
        .id_alu_op		(id_alu_op),	  // ALU操作
        .id_alu_in_0	(id_alu_in_0),	  // ALU输入0
        .id_alu_in_1	(id_alu_in_1),	  // ALU输入1
        .id_br_flag		(id_br_flag),	  // 分支标志位
        .id_mem_op		(id_mem_op),	  // 内存操作
        .id_mem_wr_data (id_mem_wr_data), // 内存写入数据
        .id_ctrl_op		(id_ctrl_op),	  // 控制操作
        .id_dst_addr	(id_dst_addr),	  // 通用寄存器写入地址
        .id_gpr_we_		(id_gpr_we_),	  // 通用寄存器写入有效
        .id_exp_code	(id_exp_code)	  // 异常代码
    );

endmodule