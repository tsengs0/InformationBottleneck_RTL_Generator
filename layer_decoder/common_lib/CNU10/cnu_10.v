//`default_nettype none
`include "revision_def.vh"
/*
	Technology: GSCL-45nm (FreePDK 45nm)
	Number of wires: 787
	Number of wire bits: 1001
	Number of cells: 949
		MUX2x1  : 105
		DFFPOSX1: 100
*/

`define BASE_MIN
module cnu_10 #(
	parameter CN_DEGREE = 10,
	parameter QUAN_SIZE = 4,
	parameter MAG_SIZE = 3,
	parameter alpha_2  = 2, // 0.25 -> x >> 2
	parameter gamma    = 1  // 0.50 -> x >> 1 
) (
	output reg [QUAN_SIZE-1:0] ch_to_var_0,
	output reg [QUAN_SIZE-1:0] ch_to_var_1,
	output reg [QUAN_SIZE-1:0] ch_to_var_2,
	output reg [QUAN_SIZE-1:0] ch_to_var_3,
	output reg [QUAN_SIZE-1:0] ch_to_var_4,
	output reg [QUAN_SIZE-1:0] ch_to_var_5,
	output reg [QUAN_SIZE-1:0] ch_to_var_6,
	output reg [QUAN_SIZE-1:0] ch_to_var_7,
	output reg [QUAN_SIZE-1:0] ch_to_var_8,
	output reg [QUAN_SIZE-1:0] ch_to_var_9,

	input wire [QUAN_SIZE-1:0] var_to_ch_0,
	input wire [QUAN_SIZE-1:0] var_to_ch_1,
	input wire [QUAN_SIZE-1:0] var_to_ch_2,
	input wire [QUAN_SIZE-1:0] var_to_ch_3,
	input wire [QUAN_SIZE-1:0] var_to_ch_4,
	input wire [QUAN_SIZE-1:0] var_to_ch_5,
	input wire [QUAN_SIZE-1:0] var_to_ch_6,
	input wire [QUAN_SIZE-1:0] var_to_ch_7,
	input wire [QUAN_SIZE-1:0] var_to_ch_8,
	input wire [QUAN_SIZE-1:0] var_to_ch_9,

	input sys_clk,
	input rstn
);

localparam MIN_INDEX_BITWIDTH = $clog2(CN_DEGREE);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [CN_DEGREE-1:0] Q_signs;
wire [MAG_SIZE-1:0] Q_mag [0:CN_DEGREE-1];

// Product-Sign
wire common_reduction_parity;
assign common_reduction_parity = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1]^var_to_ch_6[QUAN_SIZE-1]^var_to_ch_7[QUAN_SIZE-1]^var_to_ch_8[QUAN_SIZE-1]^var_to_ch_9[QUAN_SIZE-1];
assign Q_signs[0] = common_reduction_parity^var_to_ch_0[QUAN_SIZE-1];
assign Q_signs[1] = common_reduction_parity^var_to_ch_1[QUAN_SIZE-1];
assign Q_signs[2] = common_reduction_parity^var_to_ch_2[QUAN_SIZE-1];
assign Q_signs[3] = common_reduction_parity^var_to_ch_3[QUAN_SIZE-1];
assign Q_signs[4] = common_reduction_parity^var_to_ch_4[QUAN_SIZE-1];
assign Q_signs[5] = common_reduction_parity^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[6] = common_reduction_parity^var_to_ch_6[QUAN_SIZE-1];
assign Q_signs[7] = common_reduction_parity^var_to_ch_7[QUAN_SIZE-1];
assign Q_signs[8] = common_reduction_parity^var_to_ch_8[QUAN_SIZE-1];
assign Q_signs[9] = common_reduction_parity^var_to_ch_9[QUAN_SIZE-1];

`ifdef SYM_NO_IO_CONV
assign Q_mag[0] = var_to_ch_0[MAG_SIZE-1:0];
assign Q_mag[1] = var_to_ch_1[MAG_SIZE-1:0];
assign Q_mag[2] = var_to_ch_2[MAG_SIZE-1:0];
assign Q_mag[3] = var_to_ch_3[MAG_SIZE-1:0];
assign Q_mag[4] = var_to_ch_4[MAG_SIZE-1:0];
assign Q_mag[5] = var_to_ch_5[MAG_SIZE-1:0];
assign Q_mag[6] = var_to_ch_6[MAG_SIZE-1:0];
assign Q_mag[7] = var_to_ch_7[MAG_SIZE-1:0];
assign Q_mag[8] = var_to_ch_8[MAG_SIZE-1:0];
assign Q_mag[9] = var_to_ch_9[MAG_SIZE-1:0];
`else
// Sign-Magnitude conversion of all var-to-ch messages
assign Q_mag[0] = (var_to_ch_0[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_0[MAG_SIZE-1:0] : var_to_ch_0[MAG_SIZE-1:0];
assign Q_mag[1] = (var_to_ch_1[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_1[MAG_SIZE-1:0] : var_to_ch_1[MAG_SIZE-1:0];
assign Q_mag[2] = (var_to_ch_2[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_2[MAG_SIZE-1:0] : var_to_ch_2[MAG_SIZE-1:0];
assign Q_mag[3] = (var_to_ch_3[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_3[MAG_SIZE-1:0] : var_to_ch_3[MAG_SIZE-1:0];
assign Q_mag[4] = (var_to_ch_4[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_4[MAG_SIZE-1:0] : var_to_ch_4[MAG_SIZE-1:0];
assign Q_mag[5] = (var_to_ch_5[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_5[MAG_SIZE-1:0] : var_to_ch_5[MAG_SIZE-1:0];
assign Q_mag[6] = (var_to_ch_6[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_6[MAG_SIZE-1:0] : var_to_ch_6[MAG_SIZE-1:0];
assign Q_mag[7] = (var_to_ch_7[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_7[MAG_SIZE-1:0] : var_to_ch_7[MAG_SIZE-1:0];
assign Q_mag[8] = (var_to_ch_8[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_8[MAG_SIZE-1:0] : var_to_ch_8[MAG_SIZE-1:0];
assign Q_mag[9] = (var_to_ch_9[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_9[MAG_SIZE-1:0] : var_to_ch_9[MAG_SIZE-1:0];
`endif
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 0
reg [CN_DEGREE-1:0] Q_signs_reg0;
wire [MIN_INDEX_BITWIDTH-1:0] min_index [0:1];
reg [MAG_SIZE-1:0] de_msg_pipe0 [0:CN_DEGREE-1];
// Instatiation of messsage magnitude pipeline registers
// those registers will be input of following minimum-approximation module
genvar de_i;
generate
	for(de_i=0;de_i<CN_DEGREE;de_i=de_i+1) begin : de_msg_pipe0_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) de_msg_pipe0[de_i] <= {MAG_SIZE{1'bx}};
			else de_msg_pipe0[de_i] <= Q_mag[de_i];
		end

		always @(posedge sys_clk) begin if(!rstn) Q_signs_reg0[de_i] <= 0; else Q_signs_reg0[de_i] <= Q_signs[de_i]; end
	end
endgenerate

`ifdef BASE_MIN
base_cnu_min_10 #(
`else
opt_cnu_min_6 #(
`endif
	.CN_DEGREE (CN_DEGREE),
	.QUAN_SIZE (MAG_SIZE),
	.MIN_INDEX_BITWIDTH (MIN_INDEX_BITWIDTH)
) u0( 
	//.m1 (m1_base[MAG_SIZE-1:0]),
	//.m2 (m2_base[MAG_SIZE-1:0]),
	.min_1_index (min_index[0]),
	.min_2_index (min_index[1]),

	.de_msg_0 (de_msg_pipe0[0]),
	.de_msg_1 (de_msg_pipe0[1]),
	.de_msg_2 (de_msg_pipe0[2]),
	.de_msg_3 (de_msg_pipe0[3]),
	.de_msg_4 (de_msg_pipe0[4]),
	.de_msg_5 (de_msg_pipe0[5]),
	.de_msg_6 (de_msg_pipe0[6]),
	.de_msg_7 (de_msg_pipe0[7]),
	.de_msg_8 (de_msg_pipe0[8]),
	.de_msg_9 (de_msg_pipe0[9])
);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 1
reg [CN_DEGREE-1:0] Q_signs_reg1;
reg [MAG_SIZE-1:0] de_msg_pipe1 [0:CN_DEGREE-1];
generate
	for(de_i=0;de_i<CN_DEGREE;de_i=de_i+1) begin : de_msg_pipe1_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) de_msg_pipe1[de_i] <= {MAG_SIZE{1'bx}};
			else de_msg_pipe1[de_i] <= de_msg_pipe0[de_i];
		end

		always @(posedge sys_clk) begin if(!rstn) Q_signs_reg1[de_i] <= 0; else Q_signs_reg1[de_i] <= Q_signs_reg0[de_i]; end
	end
endgenerate

// Minimum magnitude
reg [MIN_INDEX_BITWIDTH-1:0] min1_index_pipe1; initial min1_index_pipe1 <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) min1_index_pipe1 <= 0;
	else min1_index_pipe1[MIN_INDEX_BITWIDTH-1:0] <= min_index[0];
end

reg [MAG_SIZE-1:0] m1_base; initial m1_base <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) m1_base <= 0;
	else m1_base[MAG_SIZE-1:0] <= de_msg_pipe0[ min_index[0] ];
end
// Second minimum magnitude
reg [MAG_SIZE-1:0] m2_base; initial m2_base <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) m2_base <= 0;
	else m2_base[MAG_SIZE-1:0] <= de_msg_pipe0[ min_index[1] ];
end

wire [MAG_SIZE-1:0] m1;
wire [MAG_SIZE-1:0] m2;
`ifdef BASE_MIN
assign m1 = m1_base[MAG_SIZE-1:0];
assign m2 = m2_base[MAG_SIZE-1:0];
`else
// min1 = min_1 * alpha_2
// min2 = min_1 * alpha_2 + min_2_prime * gamma
wire [MAG_SIZE-1:0] m1_wire;
wire [MAG_SIZE:0] m2_wire;
assign m1_wire = {{alpha_2{1'b0}}, m1_base[MAG_SIZE-1:alpha_2]};
assign m1 = m1_wire;
assign m2_wire = m1_wire + {{gamma{1'b0}}, m2_base[MAG_SIZE-1:gamma]}; 
assign m2 = (m2_wire[MAG_SIZE] == 1'b1) ? {MAG_SIZE{1'b1}} : m2_wire[MAG_SIZE-1:0];
`endif
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 2
always @(posedge sys_clk) begin
	if(rstn == 1'b0) begin
		ch_to_var_0[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_1[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_2[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_3[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_4[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_5[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
		ch_to_var_6[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
		ch_to_var_7[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
		ch_to_var_8[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
		ch_to_var_9[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
	end
	else begin
		case(min1_index_pipe1[MIN_INDEX_BITWIDTH-1:0])
			4'b0000: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0001: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0010: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0011: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0100: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0101: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0110: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b0111: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b1000: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			4'b1001: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs_reg1[0], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[0])}; `endif
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs_reg1[1], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[1])}; `endif
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs_reg1[2], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[2])}; `endif
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs_reg1[3], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[3])}; `endif
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs_reg1[4], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[4])}; `endif
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs_reg1[5], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[5])}; `endif
				ch_to_var_6[QUAN_SIZE-1:0] <= {Q_signs_reg1[6], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[6])}; `endif
				ch_to_var_7[QUAN_SIZE-1:0] <= {Q_signs_reg1[7], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[7])}; `endif
				ch_to_var_8[QUAN_SIZE-1:0] <= {Q_signs_reg1[8], `ifdef SYM_NO_IO_CONV m1[MAG_SIZE-1:0]}; `else (m1[MAG_SIZE-1:0])^(~Q_signs_reg1[8])}; `endif
				ch_to_var_9[QUAN_SIZE-1:0] <= {Q_signs_reg1[9], `ifdef SYM_NO_IO_CONV m2[MAG_SIZE-1:0]}; `else (m2[MAG_SIZE-1:0])^(~Q_signs_reg1[9])}; `endif
			end
			default: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_1[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_2[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_3[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_4[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_5[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
				ch_to_var_6[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
				ch_to_var_7[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
				ch_to_var_8[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};
				ch_to_var_9[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
			end
		endcase
	end
end
endmodule
