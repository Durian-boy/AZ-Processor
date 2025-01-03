/********** 通用头文件 **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 其他头文件 **********/
`include "bus.h"

/********** 总线从属多路复用器 **********/
module bus_slave_mux (

	/********** 总线从属多路复用器输入信号 **********/
	// 0号总线从属
    input  wire				   s0_cs_,	   // 片选
	input  wire [`WordDataBus] s0_rd_data, // 总线从属中读出的数据
	input  wire				   s0_rdy_,	   // 就绪
	// 1号总线从属
    input  wire				   s1_cs_,	   // 片选
	input  wire [`WordDataBus] s1_rd_data, // 总线从属中读出的数据
	input  wire				   s1_rdy_,	   // 就绪
	// 2号总线从属
    input  wire				   s2_cs_,	   // 片选
	input  wire [`WordDataBus] s2_rd_data, // 总线从属中读出的数据
	input  wire				   s2_rdy_,	   // 就绪
	// 3号总线从属
    input  wire				   s3_cs_,	   // 片选
	input  wire [`WordDataBus] s3_rd_data, // 总线从属中读出的数据
	input  wire				   s3_rdy_,	   // 就绪
	// 4号总线从属
    input  wire				   s4_cs_,	   // 片选
	input  wire [`WordDataBus] s4_rd_data, // 总线从属中读出的数据
	input  wire				   s4_rdy_,	   // 就绪
	// 5号总线从属
    input  wire				   s5_cs_,	   // 片选
	input  wire [`WordDataBus] s5_rd_data, // 总线从属中读出的数据
	input  wire				   s5_rdy_,	   // 就绪
	// 6号总线从属
    input  wire				   s6_cs_,	   // 片选
	input  wire [`WordDataBus] s6_rd_data, // 总线从属中读出的数据
	input  wire				   s6_rdy_,	   // 就绪
	// 7号总线从属
    input  wire				   s7_cs_,	   // 片选
	input  wire [`WordDataBus] s7_rd_data, // 总线从属中读出的数据
	input  wire				   s7_rdy_,	   // 就绪

	/**********总线从属多路复用器输出信号**********/
	output reg	[`WordDataBus] m_rd_data,  // 总线从属中读出的数据
	output reg				   m_rdy_	   // 就绪
);

	/********** 总线从属多路复用器 **********/
	always @(*) begin
		// 通过片选信号，选择输出对应的来源
		if (s0_cs_ == `ENABLE_) begin		   // 0号总线从属的返回信号
			m_rd_data = s0_rd_data;
			m_rdy_	  = s0_rdy_;
		end else if (s1_cs_ == `ENABLE_) begin // 1号总线从属的返回信号
			m_rd_data = s1_rd_data;
			m_rdy_	  = s1_rdy_;
		end else if (s2_cs_ == `ENABLE_) begin // 2号总线从属的返回信号
			m_rd_data = s2_rd_data;
			m_rdy_	  = s2_rdy_;
		end else if (s3_cs_ == `ENABLE_) begin // 3号总线从属的返回信号
			m_rd_data = s3_rd_data;
			m_rdy_	  = s3_rdy_;
		end else if (s4_cs_ == `ENABLE_) begin // 4号总线从属的返回信号
			m_rd_data = s4_rd_data;
			m_rdy_	  = s4_rdy_;
		end else if (s5_cs_ == `ENABLE_) begin // 5号总线从属的返回信号
			m_rd_data = s5_rd_data;
			m_rdy_	  = s5_rdy_;
		end else if (s6_cs_ == `ENABLE_) begin // 6号总线从属的返回信号
			m_rd_data = s6_rd_data;
			m_rdy_	  = s6_rdy_;
		end else if (s7_cs_ == `ENABLE_) begin // 7号总线从属的返回信号
			m_rd_data = s7_rd_data;
			m_rdy_	  = s7_rdy_;
		end else begin						   // 默认值
			m_rd_data = `WORD_DATA_W'h0;
			m_rdy_	  = `DISABLE_;
		end
	end

endmodule