`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 06:10:51 PM
// Design Name: 
// Module Name: ib_vnu_3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"
module ib_vnu3_f0_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f00_y0,
    output wire [QUAN_SIZE-1:0] f00_y1,
    output wire [QUAN_SIZE-1:0] f01_y0,
    output wire [QUAN_SIZE-1:0] f01_y1,
        
    input wire [QUAN_SIZE-1:0] E0,
    /*No need as input source of any 2-LUT.F0*/ //input wire [QUAN_SIZE-1:0] E1,
    input wire [QUAN_SIZE-1:0] E2,
    input wire [QUAN_SIZE-1:0] ch_llr // priori LLR from the underlying channel
); 

	// For the first decomposed LUT
	assign f00_y0 = ch_llr[QUAN_SIZE-1:0];
	assign f00_y1 = E0[QUAN_SIZE-1:0];
	// For the second decomposed LUT
	assign f01_y0 = ch_llr[QUAN_SIZE-1:0];
	assign f01_y1 = E2[QUAN_SIZE-1:0];
endmodule

module ib_f0_c2v_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] E1_reg,
	output wire [QUAN_SIZE-1:0] E2_reg,
`ifdef V2C_C2V_PROBE
	output wire [QUAN_SIZE-1:0] E0_reg,
	output wire [QUAN_SIZE-1:0] ch_llr_reg,

	input wire [QUAN_SIZE-1:0] c2v0_in,
	input wire [QUAN_SIZE-1:0] ch_llr_in,
`endif	
	input wire [QUAN_SIZE-1:0] c2v1_in,
	input wire [QUAN_SIZE-1:0] c2v2_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] c2v_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] c2v_2 [0:PIPELINE_DEPTH-2];
`ifdef V2C_C2V_PROBE
	reg [QUAN_SIZE-1:0] c2v_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] ch_llr [0:PIPELINE_DEPTH-2];

	always@(posedge read_clk) c2v_0[0] <= c2v0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) ch_llr[0] <= ch_llr_in[QUAN_SIZE-1:0];
`endif
	always@(posedge read_clk) c2v_1[0] <= c2v1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) c2v_2[0] <= c2v2_in[QUAN_SIZE-1:0];
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) c2v_1[i] <= c2v_1[i-1];
			always@(posedge read_clk) c2v_2[i] <= c2v_2[i-1];
			`ifdef V2C_C2V_PROBE
			always@(posedge read_clk) c2v_0[i] <= c2v_0[i-1];
			always@(posedge read_clk) ch_llr[i] <= ch_llr[i-1];
			`endif
		end
	endgenerate
	assign E1_reg[QUAN_SIZE-1:0] = c2v_1[PIPELINE_DEPTH-2];
	assign E2_reg[QUAN_SIZE-1:0] = c2v_2[PIPELINE_DEPTH-2];
`ifdef V2C_C2V_PROBE
	assign E0_reg[QUAN_SIZE-1:0] = c2v_0[PIPELINE_DEPTH-2];
	assign ch_llr_reg[QUAN_SIZE-1:0] = ch_llr[PIPELINE_DEPTH-2];
`endif
endmodule

module ib_vnu3_f1_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f10_y0,
    output wire [QUAN_SIZE-1:0] f10_y1,
    output wire [QUAN_SIZE-1:0] f11_y0,
    output wire [QUAN_SIZE-1:0] f11_y1,
    output wire [QUAN_SIZE-1:0] f12_y0,
    output wire [QUAN_SIZE-1:0] f12_y1,

    input wire [QUAN_SIZE-1:0] t_00,
    input wire [QUAN_SIZE-1:0] t_01,
    input wire [QUAN_SIZE-1:0] E1,
    input wire [QUAN_SIZE-1:0] E2            
);

	// For the first decomposed LUT
	assign f10_y0 = t_00[QUAN_SIZE-1:0];
	assign f10_y1 = E1[QUAN_SIZE-1:0];
	// For the second decomposed LUT
	assign f11_y0 = t_00[QUAN_SIZE-1:0];
	assign f11_y1 = E2[QUAN_SIZE-1:0];
	// For the third decomposed LUT
	assign f12_y0 = t_01[QUAN_SIZE-1:0];
	assign f12_y1 = E1[QUAN_SIZE-1:0];
endmodule

module ib_f1_c2v_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] E2_reg,
`ifdef V2C_C2V_PROBE
	output wire [QUAN_SIZE-1:0] E0_reg,
	output wire [QUAN_SIZE-1:0] E1_reg,
	output wire [QUAN_SIZE-1:0] ch_llr_reg,
	
	input wire [QUAN_SIZE-1:0] c2v0_in,
	input wire [QUAN_SIZE-1:0] c2v1_in,
	input wire [QUAN_SIZE-1:0] ch_llr_in,
`endif
	input wire [QUAN_SIZE-1:0] c2v2_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] c2v_2 [0:PIPELINE_DEPTH-2];
`ifdef V2C_C2V_PROBE
	reg [QUAN_SIZE-1:0] c2v_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] c2v_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] ch_llr [0:PIPELINE_DEPTH-2];
	
	always@(posedge read_clk) c2v_0[0] <= c2v0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) c2v_1[0] <= c2v1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) ch_llr[0] <= ch_llr_in[QUAN_SIZE-1:0];
`endif
	always@(posedge read_clk) c2v_2[0] <= c2v2_in[QUAN_SIZE-1:0];
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) c2v_2[i] <= c2v_2[i-1];
			`ifdef V2C_C2V_PROBE
			always@(posedge read_clk) c2v_0[i] <= c2v_0[i-1];
			always@(posedge read_clk) c2v_1[i] <= c2v_1[i-1];
			always@(posedge read_clk) ch_llr[i] <= ch_llr[i-1];
			`endif
		end
	endgenerate
	assign E2_reg[QUAN_SIZE-1:0] = c2v_2[PIPELINE_DEPTH-2];
`ifdef V2C_C2V_PROBE
	assign E0_reg[QUAN_SIZE-1:0] = c2v_0[PIPELINE_DEPTH-2];
	assign E1_reg[QUAN_SIZE-1:0] = c2v_1[PIPELINE_DEPTH-2];
	assign ch_llr_reg[QUAN_SIZE-1:0] = ch_llr[PIPELINE_DEPTH-2];
`endif
endmodule

// The pipeOut module is to multiplex the source of outgoing variable-to-check messages, where 
//		a) first iteration: channel message of underlying variable node is bypassed to all d_v outgoing mesage source
//		b) from second iteration: outuput of under variable node's outgoing variable-to-check messages
module ib_vnu_3_pipeOut # (
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] M0_src,
    output wire [QUAN_SIZE-1:0] M1_src,
    output wire [QUAN_SIZE-1:0] M2_src,

    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] ch_llr,
    input wire v2c_src              
);

assign M0_src[`QUAN_SIZE-1:0] = (v2c_src == 1'b0) ? M0[`QUAN_SIZE-1:0] : ch_llr[`QUAN_SIZE-1:0];
assign M1_src[`QUAN_SIZE-1:0] = (v2c_src == 1'b0) ? M1[`QUAN_SIZE-1:0] : ch_llr[`QUAN_SIZE-1:0];
assign M2_src[`QUAN_SIZE-1:0] = (v2c_src == 1'b0) ? M2[`QUAN_SIZE-1:0] : ch_llr[`QUAN_SIZE-1:0];
endmodule

module ib_dnu_f0_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f0_y0,
    output wire [QUAN_SIZE-1:0] f0_y1,

    input wire [QUAN_SIZE-1:0] t_00,
    input wire [QUAN_SIZE-1:0] E2            
);

	// For the first decomposed LUT
	assign f0_y0 = t_00[QUAN_SIZE-1:0];
	assign f0_y1 = E2[QUAN_SIZE-1:0];
endmodule

// For the Decision Node
module ib_f2_c2v_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] E0_reg,
	output wire [QUAN_SIZE-1:0] E1_reg,
	output wire [QUAN_SIZE-1:0] E2_reg,
	output wire [QUAN_SIZE-1:0] ch_llr_reg,
	
	input wire [QUAN_SIZE-1:0] c2v0_in,
	input wire [QUAN_SIZE-1:0] c2v1_in,
	input wire [QUAN_SIZE-1:0] c2v2_in,
	input wire [QUAN_SIZE-1:0] ch_llr_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] c2v_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] c2v_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] c2v_2 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] ch_llr [0:PIPELINE_DEPTH-2];
	always@(posedge read_clk) c2v_0[0] <= c2v0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) c2v_1[0] <= c2v1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) ch_llr[0] <= ch_llr_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) c2v_2[0] <= c2v2_in[QUAN_SIZE-1:0];
	
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) c2v_0[i] <= c2v_0[i-1];
			always@(posedge read_clk) c2v_1[i] <= c2v_1[i-1];
			always@(posedge read_clk) c2v_2[i] <= c2v_2[i-1];
			always@(posedge read_clk) ch_llr[i] <= ch_llr[i-1];
		end
	endgenerate
	assign E0_reg[QUAN_SIZE-1:0] = c2v_0[PIPELINE_DEPTH-2];
	assign E1_reg[QUAN_SIZE-1:0] = c2v_1[PIPELINE_DEPTH-2];
	assign E2_reg[QUAN_SIZE-1:0] = c2v_2[PIPELINE_DEPTH-2];
	assign ch_llr_reg[QUAN_SIZE-1:0] = ch_llr[PIPELINE_DEPTH-2];
endmodule