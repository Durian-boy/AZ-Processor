`ifndef __ROM_HEADER__
    `define __ROM_HEADER__			  // 包含保护

/*
 * 【关于ROM的大小】
 * ・要更改ROM的大小，
 *	 请更改ROM_SIZE、ROM_DEPTH、ROM_ADDR_W、RomAddrBus、RomAddrLoc。
 * ・ROM_SIZE定义了ROM的大小。
 * ・ROM_DEPTH定义了ROM的深度。
 *	 ROM的宽度基本固定为32bit（4Byte），
 *	 因此ROM_DEPTH是ROM_SIZE除以4的值。
 * ・ROM_ADDR_W定义了ROM的地址宽度，
 *	 是ROM_DEPTH的log2值。
 * ・RomAddrBus和RomAddrLoc是ROM_ADDR_W的总线。
 *	 请设置为ROM_ADDR_W-1:0。
 *
 * 【ROM大小示例】
 * ・如果ROM的大小为8192Byte（8KB），
 *	 ROM_DEPTH为8192÷4即2048
 *	 ROM_ADDR_W为log2(2048)即11。
 */

    `define ROM_SIZE   8192	// ROM的大小
    `define ROM_DEPTH  2048	// ROM的深度
    `define ROM_ADDR_W 11	// 地址宽度
    `define RomAddrBus 10:0 // 地址总线
    `define RomAddrLoc 10:0 // 地址位置

`endif