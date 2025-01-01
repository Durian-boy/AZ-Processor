`ifndef __STDDEF_HAEDER__
    `define __STDDEF_HAEDER__

    `define HIGH                 1'b1       // 高电平信号
    `define LOW                  1'b0       // 低电平信号
    `define DISABLE              1'b0       // 无效（正逻辑）
    `define ENABLE               1'b1       // 有效（正逻辑）
    `define DISABLE_             1'b1       // 无效（负逻辑）
    `define ENABLE_              1'b0       // 有效（负逻辑）
    `define READ                 1'b1       // 读取信号
    `define WRITE                1'b0       // 写入信号
    `define LSB                  0          // 最低位
    `define BYTE_DATA_W          8          // 数据宽度（字节）
    `define BYTE_MSB             7          // 最高位（字节）
    `define ByteDataBus          [7:0]      // 数据总线（字节）
    `define WORD_DATA_W          32         // 数据宽度（字）
    `define WORD_MSB             31         // 最高位（字）
    `define WordDataBus          [31:0]     // 数据总线（字）
    `define WORD_ADDR_W          30         // 地址宽度
    `define WORD_ADDR_MSB        29         // 最高位
    `define WordAddrBus          [29:0]     // 地址总线
    `define BYTE_OFFSET_W        2          // 位移宽度
    `define ByteOffsetBus        [1:0]      // 位移总线
    `define WordAddrLoc          [31:2]     // 字地址位置
    `define ByteOffsetLoc        [1:0]      // 字节位移位置
    `define BYTE_OFFSET_WORD     2'b00      // 字边界

`endif