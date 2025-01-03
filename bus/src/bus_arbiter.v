/********************* 通用头文件 *********************/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********************* 其他头文件 *********************/
`include "bus.h"

module bus_arbiter (
    
    /***************** 时钟复位信号 *******************/
    input  wire         clk,     // 时钟
    input  wire         reset    // 异步复位
    /***************** 0号总线主控 *******************/
    input  wire         m0_req_  // 请求总线
    output reg          m0_grnt_ // 赋予总线
    /***************** 1号总线主控 *******************/
    input  wire         m1_req_  // 请求总线
    output reg          m1_grnt_ // 赋予总线
    /***************** 2号总线主控 *******************/
    input  wire         m2_req_  // 请求总线
    output reg          m2_grnt_ // 赋予总线
    /***************** 3号总线主控 *******************/
    input  wire         m3_req_  // 请求总线
    output reg          m3_grnt_ // 赋予总线
);

    /***************** 内部信号 *******************/
    reg [`BusOwnerBus]  owner;   // 总线使用权所有者

    /*************** 赋予总线使用权 *****************/
    always @(*) begin
        // 初始化
        m0_grant_ = `DISABLE_;
        m1_grant_ = `DISABLE_;
        m2_grant_ = `DISABLE_;
        m3_grant_ = `DISABLE_;
        // 赋予总线使用权
        case (owner)
            `BUS_OWNER_MASTER_0 : begin  // 0号总线主控
                m0_grnt_ = `ENABLE_;
            end
            `BUS_OWNER_MASTER_1 : begin  // 1号总线主控
                m1_grnt_ = `ENABLE_;
            end
            `BUS_OWNER_MASTER_2 : begin  // 2号总线主控
                m2_grnt_ = `ENABLE_;
            end
            `BUS_OWNER_MASTER_3 : begin  // 3号总线主控
                m3_grnt_ = `ENABLE_;
            end
        endcase
    end

    /********** 总线使用权的仲裁 **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			// 异步复位
			owner <= #1 `BUS_OWNER_MASTER_0;
		end else begin
			// 仲裁
			case (owner)
				`BUS_OWNER_MASTER_0 : begin // 总线使用权所有者：0号总线主控
					// 下一个获得总线使用权的主控
					if (m0_req_ == `ENABLE_) begin			// 0号总线主控
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1号总线主控
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2号总线主控
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3号总线主控
						owner <= #1 `BUS_OWNER_MASTER_3;
					end
				end
				`BUS_OWNER_MASTER_1 : begin // 总线使用权所有者：1号总线主控
					// 下一个获得总线使用权的主控
					if (m1_req_ == `ENABLE_) begin			// 1号总线主控
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2号总线主控
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3号总线主控
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0号总线主控
						owner <= #1 `BUS_OWNER_MASTER_0;
					end
				end
				`BUS_OWNER_MASTER_2 : begin // 总线使用权所有者：2号总线主控
					// 下一个获得总线使用权的主控
					if (m2_req_ == `ENABLE_) begin			// 2号总线主控
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // 3号总线主控
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0号总线主控
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1号总线主控
						owner <= #1 `BUS_OWNER_MASTER_1;
					end
				end
				`BUS_OWNER_MASTER_3 : begin // バ线使用权所有者：3号总线主控
					// 下一个获得总线使用权的主控
					if (m3_req_ == `ENABLE_) begin			// 3号总线主控
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // 0号总线主控
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // 1号总线主控
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // 2号总线主控
						owner <= #1 `BUS_OWNER_MASTER_2;
					end
				end
			endcase
		end
	end

endmodule