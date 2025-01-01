/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "rom.h"

/********** 模块 **********/
module x_s3e_sprom (
    input wire				  clka,	 // 时钟
    input wire [`RomAddrBus]  addra, // 地址
    output reg [`WordDataBus] douta	 // 读数据
);

    /********** 内存 **********/
    reg [`WordDataBus] mem [0:`ROM_DEPTH-1];

    /********** 读访问 **********/
    always @(posedge clka) begin
        douta <= #1 mem[addra];
    end

endmodule
