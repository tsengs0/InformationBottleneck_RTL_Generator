`include "define.vh"

module row_process_element #(
	parameter QUAN_SIZE = 4,
	parameter CN_DEGREE = 10,
	parameter VN_DEGREE = 3,
	parameter CNU_FUNC_CYCLE = 4, // the latency of one CNU (min approximation)

	// Parameters of Partial-VNU IB-RAMs
	parameter VN_ROM_RD_BW = 8,
	parameter VN_ROM_ADDR_BW = 11,
	parameter VN_PAGE_ADDR_BW = 6,
	parameter DN_ROM_RD_BW = 2,
	parameter DN_ROM_ADDR_BW = 11,
	parameter DN_PAGE_ADDR_BW = 6,
	parameter VNU3_INSTANTIATE_NUM  = 5,
	parameter VNU3_INSTANTIATE_UNIT =  2, // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	parameter BANK_NUM = 2,
	parameter IB_VNU_DECOMP_funNum = 2,
	parameter VN_PIPELINE_DEPTH = 3,
	parameter DN_PIPELINE_DEPTH = 3,
	parameter MULTI_FRAME_NUM   = 2
) (
	// Output prot of hard decision messages
	output wire [CN_DEGREE-1:0] hard_decision,
	// Output port of extrinsic variable-to-check messages
	output wire [QUAN_SIZE-1:0] vnu0_v2c,
	output wire [QUAN_SIZE-1:0] vnu1_v2c,
	output wire [QUAN_SIZE-1:0] vnu2_v2c,
	output wire [QUAN_SIZE-1:0] vnu3_v2c,
	output wire [QUAN_SIZE-1:0] vnu4_v2c,
	output wire [QUAN_SIZE-1:0] vnu5_v2c,
	output wire [QUAN_SIZE-1:0] vnu6_v2c,
	output wire [QUAN_SIZE-1:0] vnu7_v2c,
	output wire [QUAN_SIZE-1:0] vnu8_v2c,
	output wire [QUAN_SIZE-1:0] vnu9_v2c,
	// Output port of extrinsic check-to-variable messages
	output wire [QUAN_SIZE-1:0] cnu0_c2v,
	output wire [QUAN_SIZE-1:0] cnu1_c2v,
	output wire [QUAN_SIZE-1:0] cnu2_c2v,
	output wire [QUAN_SIZE-1:0] cnu3_c2v,
	output wire [QUAN_SIZE-1:0] cnu4_c2v,
	output wire [QUAN_SIZE-1:0] cnu5_c2v,
	output wire [QUAN_SIZE-1:0] cnu6_c2v,
	output wire [QUAN_SIZE-1:0] cnu7_c2v,
	output wire [QUAN_SIZE-1:0] cnu8_c2v,
	output wire [QUAN_SIZE-1:0] cnu9_c2v,

	// Input port of channel messages
	input wire [QUAN_SIZE-1:0] vnu0_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu1_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu2_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu3_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu4_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu5_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu6_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu7_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu8_ch_msgIn,
	input wire [QUAN_SIZE-1:0] vnu9_ch_msgIn,
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_0, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_1, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_2, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_3, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_4, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_5, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_6, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_7, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_8, // only feasible at first iteration across layers
	input wire [QUAN_SIZE-1:0] cnu_ch_msgIn_9, // only feasible at first iteration across layers
	// Input port of intrinsic check-to-variable messages updated by previous layers other than any of {old data of current layer, recently updated data of next layer}
	input wire [QUAN_SIZE-1:0] vnu0_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu1_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu2_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu3_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu4_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu5_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu6_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu7_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu8_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [QUAN_SIZE-1:0] vnu9_post_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion

	//input wire [QUAN_SIZE-1:0] vnu0_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu1_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu2_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu3_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu4_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu5_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu6_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu7_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu8_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU
	//input wire [QUAN_SIZE-1:0] vnu9_post_c2v1, // extrinsic message updated at current layer, therefore no need for input port. Instead, bypassing msg from output of CNU

	//input wire [QUAN_SIZE-1:0] vnu0_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu1_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu2_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu3_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu4_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu5_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu6_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu7_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu8_post_c2v2, // no longer needed
	//input wire [QUAN_SIZE-1:0] vnu9_post_c2v2, // no longer needed
	// Input port of intrinsic variable-to-check messages
	input wire [QUAN_SIZE-1:0] cnuIn_v2c0,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c1,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c2,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c3,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c4,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c5,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c6,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c7,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c8,
	input wire [QUAN_SIZE-1:0] cnuIn_v2c9,

	input wire read_clk,
	input wire vnu_read_addr_offset,
	input wire v2c_src,
	input wire v2c_latch_en,
	input wire c2v_latch_en,
	input wire [1:0] load, //({v2c_load[0], c2v_load[0]}),
	input wire [1:0] parallel_en,//({v2c_msg_en[0], c2v_msg_en[0]}),
	input wire rstn,

	// Iteration-Refresh Page Address
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_0, // the MSB decides refreshed target, i.e., upper page group or lower page group
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_1, // the MSB decides refreshed target, i.e., upper page group or lower page group
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_2, // the MSB decides refreshed target, i.e., upper page group or lower page group // the last one is for decision node
	//Iteration-Refresh Page Data

	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_0, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_0, // from portB of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_1, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_1, // from portB of IB-ROM
	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataA_2, // from portA of IB-ROM (for decision node)
	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataB_2, // from portB of IB-ROM (for decision node)

	input wire [VN_DEGREE-1:0] vnu_ib_ram_we,
	input wire vn_write_clk,
	input wire dn_write_clk
);

wire [QUAN_SIZE-1:0] cnu_Din [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] c2v_reg [0:CN_DEGREE-1];
cnu_10 #(
	.CN_DEGREE (CN_DEGREE), // 10
	.QUAN_SIZE (QUAN_SIZE) , // 4
	.MAG_SIZE  (QUAN_SIZE-1) , // 3
	/*Not used now*/ .alpha_2   (2) , // 0.25 -> x >> 2
	/*Not used now*/ .gamma     (1)  // 0.50 -> x >> 1 
) row_cnu_u0 (
	.ch_to_var_0 (c2v_reg[0]),
	.ch_to_var_1 (c2v_reg[1]),
	.ch_to_var_2 (c2v_reg[2]),
	.ch_to_var_3 (c2v_reg[3]),
	.ch_to_var_4 (c2v_reg[4]),
	.ch_to_var_5 (c2v_reg[5]),
	.ch_to_var_6 (c2v_reg[6]),
	.ch_to_var_7 (c2v_reg[7]),
	.ch_to_var_8 (c2v_reg[8]),
	.ch_to_var_9 (c2v_reg[9]),

	.var_to_ch_0 (cnu_Din[0]),
	.var_to_ch_1 (cnu_Din[1]),
	.var_to_ch_2 (cnu_Din[2]),
	.var_to_ch_3 (cnu_Din[3]),
	.var_to_ch_4 (cnu_Din[4]),
	.var_to_ch_5 (cnu_Din[5]),
	.var_to_ch_6 (cnu_Din[6]),
	.var_to_ch_7 (cnu_Din[7]),
	.var_to_ch_8 (cnu_Din[8]),
	.var_to_ch_9 (cnu_Din[9]),

	.sys_clk (read_clk),
	.rstn    (rstn)
);

row_vnu_wrapper #(
	.QUAN_SIZE (QUAN_SIZE), // 4,
	.CN_DEGREE (CN_DEGREE), // 10,
	.VN_DEGREE (VN_DEGREE), // 3,

	// Parameters of Partial-VNU IB-RAMs
	.VNU3_INSTANTIATE_NUM  (VNU3_INSTANTIATE_NUM ), // 5,
	.VNU3_INSTANTIATE_UNIT (VNU3_INSTANTIATE_UNIT), // 2, // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	.VN_ROM_RD_BW          (VN_ROM_RD_BW         ), // 8,
	.VN_ROM_ADDR_BW        (VN_ROM_ADDR_BW       ), // 11,
	.VN_PAGE_ADDR_BW       (VN_PAGE_ADDR_BW      ), // 6,
	.DN_ROM_RD_BW          (DN_ROM_RD_BW         ), // 2,
	.DN_ROM_ADDR_BW        (DN_ROM_ADDR_BW       ), // 11,
	.DN_PAGE_ADDR_BW       (DN_PAGE_ADDR_BW      ), // 6,
	.BANK_NUM  	           (BANK_NUM             ), // 2,
	.IB_VNU_DECOMP_funNum  (IB_VNU_DECOMP_funNum ), // 2,
	.VN_PIPELINE_DEPTH     (VN_PIPELINE_DEPTH    ), // 3,
	.DN_PIPELINE_DEPTH     (DN_PIPELINE_DEPTH    ), // 3
	.MULTI_FRAME_NUM       (MULTI_FRAME_NUM      )  // 2
) row_vnu_wrapper_u0(
	//output wire read_addr_offset_out,
	// Output ports of extrinsic messages and hard decision messages from d_c partial-VNUs
	.hard_decision_0 (hard_decision[0]),
	.hard_decision_1 (hard_decision[1]),
	.hard_decision_2 (hard_decision[2]),
	.hard_decision_3 (hard_decision[3]),
	.hard_decision_4 (hard_decision[4]),
	.hard_decision_5 (hard_decision[5]),
	.hard_decision_6 (hard_decision[6]),
	.hard_decision_7 (hard_decision[7]),
	.hard_decision_8 (hard_decision[8]),
	.hard_decision_9 (hard_decision[9]),
	.v2c_0_out0 (vnu0_v2c[QUAN_SIZE-1:0]),
	.v2c_1_out0 (vnu1_v2c[QUAN_SIZE-1:0]),
	.v2c_2_out0 (vnu2_v2c[QUAN_SIZE-1:0]),
	.v2c_3_out0 (vnu3_v2c[QUAN_SIZE-1:0]),
	.v2c_4_out0 (vnu4_v2c[QUAN_SIZE-1:0]),
	.v2c_5_out0 (vnu5_v2c[QUAN_SIZE-1:0]),
	.v2c_6_out0 (vnu6_v2c[QUAN_SIZE-1:0]),
	.v2c_7_out0 (vnu7_v2c[QUAN_SIZE-1:0]),
	.v2c_8_out0 (vnu8_v2c[QUAN_SIZE-1:0]),
	.v2c_9_out0 (vnu9_v2c[QUAN_SIZE-1:0]),

	// Intrinsic check-to-variable messages and channel messages
	.ch_msg_0 (vnu0_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_1 (vnu1_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_2 (vnu2_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_3 (vnu3_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_4 (vnu4_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_5 (vnu5_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_6 (vnu6_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_7 (vnu7_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_8 (vnu8_ch_msgIn[QUAN_SIZE-1:0]),
	.ch_msg_9 (vnu9_ch_msgIn[QUAN_SIZE-1:0]),
	.c2v_0_in0 (vnu0_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_1_in0 (vnu1_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_2_in0 (vnu2_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_3_in0 (vnu3_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_4_in0 (vnu4_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_5_in0 (vnu5_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_6_in0 (vnu6_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_7_in0 (vnu7_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_8_in0 (vnu8_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_9_in0 (vnu9_post_c2v0[QUAN_SIZE-1:0]),
	.c2v_0_in1 (c2v_reg[0]),//(vnu0_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_1_in1 (c2v_reg[1]),//(vnu1_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_2_in1 (c2v_reg[2]),//(vnu2_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_3_in1 (c2v_reg[3]),//(vnu3_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_4_in1 (c2v_reg[4]),//(vnu4_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_5_in1 (c2v_reg[5]),//(vnu5_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_6_in1 (c2v_reg[6]),//(vnu6_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_7_in1 (c2v_reg[7]),//(vnu7_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_8_in1 (c2v_reg[8]),//(vnu8_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_9_in1 (c2v_reg[9]),//(vnu9_post_c2v1[QUAN_SIZE-1:0]),
	.c2v_0_in2 (vnu0_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu0_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_1_in2 (vnu1_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu1_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_2_in2 (vnu2_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu2_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_3_in2 (vnu3_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu3_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_4_in2 (vnu4_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu4_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_5_in2 (vnu5_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu5_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_6_in2 (vnu6_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu6_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_7_in2 (vnu7_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu7_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_8_in2 (vnu8_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu8_post_c2v2[QUAN_SIZE-1:0]),
	.c2v_9_in2 (vnu9_immediate_v2c_pipe[CNU_FUNC_CYCLE-1]),//(vnu9_post_c2v2[QUAN_SIZE-1:0]),

	.read_clk (read_clk),
	.read_addr_offset (vnu_read_addr_offset),
	.v2c_src (v2c_src),
	.c2v_latch_en (c2v_latch_en),
	.c2v_parallel_load (load[0]),

	// Iteration-Refresh Page Address
	.page_addr_ram_0 (vnu_page_addr_ram_0[VN_PAGE_ADDR_BW+1-1:0]),
	.page_addr_ram_1 (vnu_page_addr_ram_1[VN_PAGE_ADDR_BW+1-1:0]),
	.page_addr_ram_2 (vnu_page_addr_ram_2[DN_PAGE_ADDR_BW+1-1:0]), // the last one is for decision node
	//Iteration-Refresh Page Data
	.ram_write_dataA_0 (vnu_ram_write_dataA_0[VN_ROM_RD_BW-1:0]), // from portA of IB-ROM
	.ram_write_dataB_0 (vnu_ram_write_dataB_0[VN_ROM_RD_BW-1:0]), // from portB of IB-ROM
	.ram_write_dataA_1 (vnu_ram_write_dataA_1[VN_ROM_RD_BW-1:0]), // from portA of IB-ROM
	.ram_write_dataB_1 (vnu_ram_write_dataB_1[VN_ROM_RD_BW-1:0]), // from portB of IB-ROM
	.ram_write_dataA_2 (vnu_ram_write_dataA_2[DN_ROM_RD_BW-1:0]), // from portA of IB-ROM (for decision node)
	.ram_write_dataB_2 (vnu_ram_write_dataB_2[DN_ROM_RD_BW-1:0]), // from portB of IB-ROM (for decision node)
	.ib_ram_we (vnu_ib_ram_we[IB_VNU_DECOMP_funNum:0]),
	.vn_write_clk (vn_write_clk),
	.dn_write_clk (dn_write_clk),
	.rstn (rstn)
);

`ifdef SCHED_4_6
assign cnu_Din[0] = (v2c_src == 1'b1) ? cnu_ch_msgIn_0 : cnuIn_v2c0[QUAN_SIZE-1:0];
assign cnu_Din[1] = (v2c_src == 1'b1) ? cnu_ch_msgIn_1 : cnuIn_v2c1[QUAN_SIZE-1:0];
assign cnu_Din[2] = (v2c_src == 1'b1) ? cnu_ch_msgIn_2 : cnuIn_v2c2[QUAN_SIZE-1:0];
assign cnu_Din[3] = (v2c_src == 1'b1) ? cnu_ch_msgIn_3 : cnuIn_v2c3[QUAN_SIZE-1:0];
assign cnu_Din[4] = (v2c_src == 1'b1) ? cnu_ch_msgIn_4 : cnuIn_v2c4[QUAN_SIZE-1:0];
assign cnu_Din[5] = (v2c_src == 1'b1) ? cnu_ch_msgIn_5 : cnuIn_v2c5[QUAN_SIZE-1:0];
assign cnu_Din[6] = (v2c_src == 1'b1) ? cnu_ch_msgIn_6 : cnuIn_v2c6[QUAN_SIZE-1:0];
assign cnu_Din[7] = (v2c_src == 1'b1) ? cnu_ch_msgIn_7 : cnuIn_v2c7[QUAN_SIZE-1:0];
assign cnu_Din[8] = (v2c_src == 1'b1) ? cnu_ch_msgIn_8 : cnuIn_v2c8[QUAN_SIZE-1:0];
assign cnu_Din[9] = (v2c_src == 1'b1) ? cnu_ch_msgIn_9 : cnuIn_v2c9[QUAN_SIZE-1:0];

reg [QUAN_SIZE-1:0] vnu0_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu0_immediate_v2c_pipe[0] <= 0; else vnu0_immediate_v2c_pipe[0] <= cnu_Din[0]; end
reg [QUAN_SIZE-1:0] vnu1_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu1_immediate_v2c_pipe[0] <= 0; else vnu1_immediate_v2c_pipe[0] <= cnu_Din[1]; end
reg [QUAN_SIZE-1:0] vnu2_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu2_immediate_v2c_pipe[0] <= 0; else vnu2_immediate_v2c_pipe[0] <= cnu_Din[2]; end
reg [QUAN_SIZE-1:0] vnu3_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu3_immediate_v2c_pipe[0] <= 0; else vnu3_immediate_v2c_pipe[0] <= cnu_Din[3]; end
reg [QUAN_SIZE-1:0] vnu4_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu4_immediate_v2c_pipe[0] <= 0; else vnu4_immediate_v2c_pipe[0] <= cnu_Din[4]; end
reg [QUAN_SIZE-1:0] vnu5_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu5_immediate_v2c_pipe[0] <= 0; else vnu5_immediate_v2c_pipe[0] <= cnu_Din[5]; end
reg [QUAN_SIZE-1:0] vnu6_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu6_immediate_v2c_pipe[0] <= 0; else vnu6_immediate_v2c_pipe[0] <= cnu_Din[6]; end
reg [QUAN_SIZE-1:0] vnu7_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu7_immediate_v2c_pipe[0] <= 0; else vnu7_immediate_v2c_pipe[0] <= cnu_Din[7]; end
reg [QUAN_SIZE-1:0] vnu8_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu8_immediate_v2c_pipe[0] <= 0; else vnu8_immediate_v2c_pipe[0] <= cnu_Din[8]; end
reg [QUAN_SIZE-1:0] vnu9_immediate_v2c_pipe [0:CNU_FUNC_CYCLE-1]; always @(posedge read_clk) begin if(!rstn) vnu9_immediate_v2c_pipe[0] <= 0; else vnu9_immediate_v2c_pipe[0] <= cnu_Din[9]; end
genvar i;
generate
	for(i=1;i<CNU_FUNC_CYCLE;i=i+1) begin : imm_v2c_pipeline_inst
		always @(posedge read_clk) begin if(!rstn) vnu0_immediate_v2c_pipe[i] <= 0; else vnu0_immediate_v2c_pipe[i] <= vnu0_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu1_immediate_v2c_pipe[i] <= 0; else vnu1_immediate_v2c_pipe[i] <= vnu1_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu2_immediate_v2c_pipe[i] <= 0; else vnu2_immediate_v2c_pipe[i] <= vnu2_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu3_immediate_v2c_pipe[i] <= 0; else vnu3_immediate_v2c_pipe[i] <= vnu3_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu4_immediate_v2c_pipe[i] <= 0; else vnu4_immediate_v2c_pipe[i] <= vnu4_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu5_immediate_v2c_pipe[i] <= 0; else vnu5_immediate_v2c_pipe[i] <= vnu5_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu6_immediate_v2c_pipe[i] <= 0; else vnu6_immediate_v2c_pipe[i] <= vnu6_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu7_immediate_v2c_pipe[i] <= 0; else vnu7_immediate_v2c_pipe[i] <= vnu7_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu8_immediate_v2c_pipe[i] <= 0; else vnu8_immediate_v2c_pipe[i] <= vnu8_immediate_v2c_pipe[i-1]; end
		always @(posedge read_clk) begin if(!rstn) vnu9_immediate_v2c_pipe[i] <= 0; else vnu9_immediate_v2c_pipe[i] <= vnu9_immediate_v2c_pipe[i-1]; end
	end
endgenerate

assign cnu0_c2v[QUAN_SIZE-1:0] = c2v_reg[0];
assign cnu1_c2v[QUAN_SIZE-1:0] = c2v_reg[1];
assign cnu2_c2v[QUAN_SIZE-1:0] = c2v_reg[2];
assign cnu3_c2v[QUAN_SIZE-1:0] = c2v_reg[3];
assign cnu4_c2v[QUAN_SIZE-1:0] = c2v_reg[4];
assign cnu5_c2v[QUAN_SIZE-1:0] = c2v_reg[5];
assign cnu6_c2v[QUAN_SIZE-1:0] = c2v_reg[6];
assign cnu7_c2v[QUAN_SIZE-1:0] = c2v_reg[7];
assign cnu8_c2v[QUAN_SIZE-1:0] = c2v_reg[8];
assign cnu9_c2v[QUAN_SIZE-1:0] = c2v_reg[9];
`else
assign cnu_Din[0] = (v2c_src == 1'b1) ? vnu0_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c0[QUAN_SIZE-1:0];
assign cnu_Din[1] = (v2c_src == 1'b1) ? vnu1_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c1[QUAN_SIZE-1:0];
assign cnu_Din[2] = (v2c_src == 1'b1) ? vnu2_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c2[QUAN_SIZE-1:0];
assign cnu_Din[3] = (v2c_src == 1'b1) ? vnu3_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c3[QUAN_SIZE-1:0];
assign cnu_Din[4] = (v2c_src == 1'b1) ? vnu4_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c4[QUAN_SIZE-1:0];
assign cnu_Din[5] = (v2c_src == 1'b1) ? vnu5_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c5[QUAN_SIZE-1:0];
assign cnu_Din[6] = (v2c_src == 1'b1) ? vnu6_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c6[QUAN_SIZE-1:0];
assign cnu_Din[7] = (v2c_src == 1'b1) ? vnu7_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c7[QUAN_SIZE-1:0];
assign cnu_Din[8] = (v2c_src == 1'b1) ? vnu8_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c8[QUAN_SIZE-1:0];
assign cnu_Din[9] = (v2c_src == 1'b1) ? vnu9_ch_msgIn[QUAN_SIZE-1:0] : cnuIn_v2c9[QUAN_SIZE-1:0];
`endif
endmodule
/*
module ch_msg_buffer #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85
) (
	output wire [QUAN_SIZE-1:0] ch_msg_out,

	input wire [QUAN_SIZE-1:0] ch_msg_in,
	input wire v2c_src,
	input wire sys_clk,
	input wire rstn
);

localparam CH_MSG_NUM = ROW_CHUNK_NUM*LAYER_NUM;
reg [QUAN_SIZE-1:0] shift_reg [0:CH_MSG_NUM-1];
always @(posedge sys_clk) begin
	if(rstn == 1'b0) shift_reg[0] <= 0;
	else if(v2c_src == 1'b1) shift_reg[0] <= ch_msg_in;
	else shift_reg[0] <= shift_reg[CH_MSG_NUM-1];
end
assign ch_msg_out = shift_reg[0];

genvar i;
generate
	for(i=1;i<CH_MSG_NUM;i=i+1) begin : shift_reg_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) shift_reg[i] <= 0;
			else shift_reg[i] <= shift_reg[i-1];
		end		
	end
endgenerate
endmodule
*/