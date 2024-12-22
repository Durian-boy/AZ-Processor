`ifndef __CPU_HEADER__
    `define __CPU_HEADER__

	`define REG_NUM				 32	   // 寄存器数
	`define REG_ADDR_W			 5	   // 寄存器地址宽度
	`define RegAddrBus			 4:0   // 寄存器地址总线
	`define CPU_IRQ_CH			 8	   // IRQ宽度
	`define ALU_OP_W			 4	   // ALU操作码宽度
	`define AluOpBus			 3:0   // ALU操作码总线
	`define ALU_OP_NOP			 4'h0  // No Operation
	`define ALU_OP_AND			 4'h1  // AND
	`define ALU_OP_OR			 4'h2  // OR
	`define ALU_OP_XOR			 4'h3  // XOR
	`define ALU_OP_ADDS			 4'h4  // 有符号加法
	`define ALU_OP_ADDU			 4'h5  // 无符号加法
	`define ALU_OP_SUBS			 4'h6  // 有符号减法
	`define ALU_OP_SUBU			 4'h7  // 无符号减法
	`define ALU_OP_SHRL			 4'h8  // 逻辑右移
	`define ALU_OP_SHLL			 4'h9  // 逻辑左移
	`define MEM_OP_W			 2	   // 内存操作码宽度
	`define MemOpBus			 1:0   // 内存操作码总线
	`define MEM_OP_NOP			 2'h0  // No Operation
	`define MEM_OP_LDW			 2'h1  // 字读取
	`define MEM_OP_STW			 2'h2  // 字写入
	`define CTRL_OP_W			 2	   // 控制操作码宽度
	`define CtrlOpBus			 1:0   // 控制操作码总线
	`define CTRL_OP_NOP			 2'h0  // No Operation
	`define CTRL_OP_WRCR		 2'h1  // 写入控制寄存器
	`define CTRL_OP_EXRT		 2'h2  // 从异常恢复
	`define CPU_EXE_MODE_W		 1	   // 执行模式宽度
	`define CpuExeModeBus		 0:0   // 执行模式总线
	`define CPU_KERNEL_MODE		 1'b0  // 内核模式
	`define CPU_USER_MODE		 1'b1  // 用户模式
	`define CREG_ADDR_STATUS	 5'h0  // 状态
	`define CREG_ADDR_PRE_STATUS 5'h1  // 前一个状态
	`define CREG_ADDR_PC		 5'h2  // 程序计数器
	`define CREG_ADDR_EPC		 5'h3  // 异常程序计数器
	`define CREG_ADDR_EXP_VECTOR 5'h4  // 异常向量
	`define CREG_ADDR_CAUSE		 5'h5  // 异常原因寄存器
	`define CREG_ADDR_INT_MASK	 5'h6  // 中断掩码
	`define CREG_ADDR_IRQ		 5'h7  // 中断请求
	`define CREG_ADDR_ROM_SIZE	 5'h1d // ROM容量
	`define CREG_ADDR_SPM_SIZE	 5'h1e // SPM容量
	`define CREG_ADDR_CPU_INFO	 5'h1f // CPU参数
	`define CregExeModeLoc		 0	   // 执行模式的位置
	`define CregIntEnableLoc	 1	   // 中断使能的位置
	`define CregExpCodeLoc		 2:0   // 异常代码的位置
	`define CregDlyFlagLoc		 3	   // 延迟间隙标志位的位置
	`define BusIfStateBus		 1:0   // 状态总线
	`define BUS_IF_STATE_IDLE	 2'h0  // 空闲
	`define BUS_IF_STATE_REQ	 2'h1  // 请求总线
	`define BUS_IF_STATE_ACCESS	 2'h2  // 访问总线
	`define BUS_IF_STATE_STALL	 2'h3  // 停滞
	`define RESET_VECTOR		 30'h0 // 复位向量
	`define ShAmountBus			 4:0   // 移位量总线
	`define ShAmountLoc			 4:0   // 移位量的位置
	`define RELEASE_YEAR		 8'd41 // 制作年 (YYYY - 1970)
	`define RELEASE_MONTH		 8'd7  // 制作月份
	`define RELEASE_VERSION		 8'd1  // 版本号
	`define RELEASE_REVISION	 8'd0  // 修订号

`endif
