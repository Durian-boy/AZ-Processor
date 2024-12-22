/**********通用头文件**********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/**********其他头文件**********/
`include "bus.h"

/**********地址解码器**********/
module bus_addr_dec (

	/**********输入地址解码器的信号**********/
	input  wire [`WordAddrBus] s_addr, // 地址
    
	/**********地址解码器输出的片选信号**********/
	output reg				   s0_cs_, // 0号总线从属选通
	output reg				   s1_cs_, // 1号总线从属选通
	output reg				   s2_cs_, // 2号总线从属选通
	output reg				   s3_cs_, // 3号总线从属选通
	output reg				   s4_cs_, // 4号总线从属选通
	output reg				   s5_cs_, // 5号总线从属选通
	output reg				   s6_cs_, // 6号总线从属选通
	output reg				   s7_cs_  // 7号总线从属选通
);

	/**********总线从属索引**********/
	wire [`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc];

	/**********总线从属多路复用器**********/
	always @(*) begin
		// 初始化片选信号
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;
		// 选择地址对应的从属
		case (s_index)
			`BUS_SLAVE_0 : begin // 访问0号总线从属
				s0_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_1 : begin // 访问1号总线从属
				s1_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_2 : begin // 访问2号总线从属
				s2_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_3 : begin // 访问3号总线从属
				s3_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_4 : begin // 访问4号总线从属
				s4_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_5 : begin // 访问5号总线从属
				s5_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_6 : begin // 访问6号总线从属
				s6_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_7 : begin // 访问7号总线从属
				s7_cs_	= `ENABLE_;
			end
		endcase
	end

endmodule