`ifndef __SPM_HEADER__
	`define __SPM_HEADER__
/*
  * 关于SPM的大小
  * 要调整SPM的大小，
  * 更改spm_size， spm_depth, spm_addr_w， SpmAddrBus和SpmAddrLoc。
  * spm_size定义了SPM的大小。
  * spm_depth定义了SPM的深度。
  * SPM宽度基本上是固定的32bit （4byte）
  * spm_depth是spm_size除以4的值。
  * spm_addr_w定义了SPM的地址宽度。
  * spm_depth是log2的值。
  * SpmAddrBus和SpmAddrLoc是spm_addr_w的总线。
  * 请使用spm_addr_w -1:0。
  *
  *【SPM大小示例】
  * 如果SPM的大小是16384Byte (16kb)，
  * spm_depth是16384÷4 = 4096
  * spm_addr_w在log2（4096）中为12。
*/

	`define SPM_SIZE   16384 // SPM容量
	`define SPM_DEPTH  4096	 // SPM深度
	`define SPM_ADDR_W 12	 // 地址宽度
	`define SpmAddrBus 11:0	 // 地址总线
	`define SpmAddrLoc 11:0	 // 地址的位置

`endif
