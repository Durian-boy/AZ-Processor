/********** 通用头文件 **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** 其他头文件 **********/
`include "isa.h"
`include "cpu.h"

module mem_stage (
    /********** 时钟和复位 **********/
    input  wire				   clk,			   // 时钟
    input  wire				   reset,		   // 异步复位
    /********** 流水线控制信号 **********/
    input  wire				   stall,		   // 流水线延迟
    input  wire				   flush,		   // 流水线刷新
    output wire				   busy,		   // 忙信号
    /********** 直通 **********/
    output wire [`WordDataBus] fwd_data,	   // 数据直通
    /********** SPM接口 **********/
    input  wire [`WordDataBus] spm_rd_data,	   // 读取数据
    output wire [`WordAddrBus] spm_addr,	   // 地址
    output wire				   spm_as_,		   // 地址选通
    output wire				   spm_rw,		   // 读/写
    output wire [`WordDataBus] spm_wr_data,	   // 写入数据
    /********** 总线接口 **********/
    input  wire [`WordDataBus] bus_rd_data,	   // 读取数据
    input  wire				   bus_rdy_,	   // 就绪
    input  wire				   bus_grnt_,	   // 总线授权
    output wire				   bus_req_,	   // 总线请求
    output wire [`WordAddrBus] bus_addr,	   // 地址
    output wire				   bus_as_,		   // 地址选通
    output wire				   bus_rw,		   // 读/写
    output wire [`WordDataBus] bus_wr_data,	   // 写入数据
    /********** EX/MEM流水线寄存器 **********/
    input  wire [`WordAddrBus] ex_pc,		   // 程序计数器
    input  wire				   ex_en,		   // 流水线数据有效
    input  wire				   ex_br_flag,	   // 分支标志
    input  wire [`MemOpBus]	   ex_mem_op,	   // 内存操作
    input  wire [`WordDataBus] ex_mem_wr_data, // 内存写入数据
    input  wire [`CtrlOpBus]   ex_ctrl_op,	   // 控制寄存器操作
    input  wire [`RegAddrBus]  ex_dst_addr,	   // 通用寄存器写入地址
    input  wire				   ex_gpr_we_,	   // 通用寄存器写入有效
    input  wire [`IsaExpBus]   ex_exp_code,	   // 异常代码
    input  wire [`WordDataBus] ex_out,		   // 处理结果
    /********** MEM/WB流水线寄存器 **********/
    output wire [`WordAddrBus] mem_pc,		   // 程序计数器
    output wire				   mem_en,		   // 流水线数据有效
    output wire				   mem_br_flag,	   // 分支标志
    output wire [`CtrlOpBus]   mem_ctrl_op,	   // 控制寄存器操作
    output wire [`RegAddrBus]  mem_dst_addr,   // 通用寄存器写入地址
    output wire				   mem_gpr_we_,	   // 通用寄存器写入有效
    output wire [`IsaExpBus]   mem_exp_code,   // 异常代码
    output wire [`WordDataBus] mem_out		   // 处理结果
);

    /********** 内部信号 **********/
    wire [`WordDataBus]		   rd_data;		   // 读取数据
    wire [`WordAddrBus]		   addr;		   // 地址
    wire					   as_;			   // 地址选通
    wire					   rw;			   // 读/写
    wire [`WordDataBus]		   wr_data;		   // 写入数据
    wire [`WordDataBus]		   out;			   // 内存访问结果
    wire					   miss_align;	   // 地址未对齐

    /********** 结果直通 **********/
    assign fwd_data	 = out;

    /********** 内存访问控制单元 **********/
    mem_ctrl mem_ctrl (
        /********** EX/MEM流水线寄存器 **********/
        .ex_en			(ex_en),			   // 流水线数据有效
        .ex_mem_op		(ex_mem_op),		   // 内存操作
        .ex_mem_wr_data (ex_mem_wr_data),	   // 内存写入数据
        .ex_out			(ex_out),			   // 处理结果
        /********** 内存访问接口 **********/
        .rd_data		(rd_data),			   // 读取数据
        .addr			(addr),				   // 地址
        .as_			(as_),				   // 地址选通
        .rw				(rw),				   // 读/写
        .wr_data		(wr_data),			   // 写入数据
        /********** 内存访问结果 **********/
        .out			(out),				   // 内存访问结果
        .miss_align		(miss_align)		   // 地址未对齐
    );

    /********** 总线接口 **********/
    bus_if bus_if (
        /********** 时钟和复位 **********/
        .clk		 (clk),					   // 时钟
        .reset		 (reset),				   // 异步复位
        /********** 流水线控制信号 **********/
        .stall		 (stall),				   // 流水线延迟
        .flush		 (flush),				   // 流水线刷新
        .busy		 (busy),				   // 忙信号
        /********** CPU接口 **********/
        .addr		 (addr),				   // 地址
        .as_		 (as_),					   // 地址选通
        .rw			 (rw),					   // 读/写
        .wr_data	 (wr_data),				   // 写入数据
        .rd_data	 (rd_data),				   // 读取数据
        /********** SPM接口 **********/
        .spm_rd_data (spm_rd_data),			   // 读取数据
        .spm_addr	 (spm_addr),			   // 地址
        .spm_as_	 (spm_as_),				   // 地址选通
        .spm_rw		 (spm_rw),				   // 读/写
        .spm_wr_data (spm_wr_data),			   // 写入数据
        /********** 总线接口 **********/
        .bus_rd_data (bus_rd_data),			   // 读取数据
        .bus_rdy_	 (bus_rdy_),			   // 就绪
        .bus_grnt_	 (bus_grnt_),			   // 总线授权
        .bus_req_	 (bus_req_),			   // 总线请求
        .bus_addr	 (bus_addr),			   // 地址
        .bus_as_	 (bus_as_),				   // 地址选通
        .bus_rw		 (bus_rw),				   // 读/写
        .bus_wr_data (bus_wr_data)			   // 写入数据
    );

    /********** MEM阶段流水线寄存器 **********/
    mem_reg mem_reg (
        /********** 时钟和复位 **********/
        .clk		  (clk),				   // 时钟
        .reset		  (reset),				   // 异步复位
        /********** 内存访问结果 **********/
        .out		  (out),				   // 结果
        .miss_align	  (miss_align),			   // 地址未对齐
        /********** 流水线控制信号 **********/
        .stall		  (stall),				   // 流水线延迟
        .flush		  (flush),				   // 流水线刷新
        /********** EX/MEM流水线寄存器 **********/
        .ex_pc		  (ex_pc),				   // 程序计数器
        .ex_en		  (ex_en),				   // 流水线数据有效
        .ex_br_flag	  (ex_br_flag),			   // 分支标志
        .ex_ctrl_op	  (ex_ctrl_op),			   // 控制寄存器操作
        .ex_dst_addr  (ex_dst_addr),		   // 通用寄存器写入地址
        .ex_gpr_we_	  (ex_gpr_we_),			   // 通用寄存器写入有效
        .ex_exp_code  (ex_exp_code),		   // 异常代码
        /********** MEM/WB流水线寄存器 **********/
        .mem_pc		  (mem_pc),				   // 程序计数器
        .mem_en		  (mem_en),				   // 流水线数据有效
        .mem_br_flag  (mem_br_flag),		   // 分支标志
        .mem_ctrl_op  (mem_ctrl_op),		   // 控制寄存器操作
        .mem_dst_addr (mem_dst_addr),		   // 通用寄存器写入地址
        .mem_gpr_we_  (mem_gpr_we_),		   // 通用寄存器写入有效
        .mem_exp_code (mem_exp_code),		   // 异常代码
        .mem_out	  (mem_out)				   // 处理结果
    );

endmodule