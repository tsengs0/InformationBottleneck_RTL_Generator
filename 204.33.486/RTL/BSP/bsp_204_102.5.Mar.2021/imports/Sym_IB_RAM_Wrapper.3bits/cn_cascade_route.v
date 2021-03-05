`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 06:10:51 PM
// Design Name: 
// Module Name: ib_cnu_6
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
module ib_cnu6_f0_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f00_y0,
    output wire [QUAN_SIZE-1:0] f00_y1,
    output wire [QUAN_SIZE-1:0] f01_y0,
    output wire [QUAN_SIZE-1:0] f01_y1,
        
    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    /*No need as input source of 2-LUT.F0*///input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M3,
    input wire [QUAN_SIZE-1:0] M4
    /*No need as input source of 2-LUT.F0*///input wire [QUAN_SIZE-1:0] M5
);

	// For the first decomposed LUT
	//assign f00_y0[QUAN_SIZE-1:0] = (we == 1'b1) ? QUAN_SIZE'd0 : M0[QUAN_SIZE-1:0];
	//assign f00_y1[QUAN_SIZE-1:0] = (we == 1'b1) ? QUAN_SIZE'd0 : M1[QUAN_SIZE-1:0];
	assign f00_y0[QUAN_SIZE-1:0] = M0[QUAN_SIZE-1:0];
	assign f00_y1[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0];
	// For the second decomposed LUT
	//assign f00_y0[QUAN_SIZE-1:0] = (we == 1'b1) ? QUAN_SIZE'd0 : M0[QUAN_SIZE-1:0];
	//assign f00_y1[QUAN_SIZE-1:0] = (we == 1'b1) ? QUAN_SIZE'd0 : M1[QUAN_SIZE-1:0];
	assign f01_y0[QUAN_SIZE-1:0] = M3[QUAN_SIZE-1:0];
	assign f01_y1[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];    
endmodule

module ib_f0_v2c_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] M0_reg,
	output wire [QUAN_SIZE-1:0] M1_reg,
	output wire [QUAN_SIZE-1:0] M2_reg,
	output wire [QUAN_SIZE-1:0] M3_reg,
	output wire [QUAN_SIZE-1:0] M4_reg,
	output wire [QUAN_SIZE-1:0] M5_reg,
	
	input wire [QUAN_SIZE-1:0] v2c0_in,
	input wire [QUAN_SIZE-1:0] v2c1_in,
	input wire [QUAN_SIZE-1:0] v2c2_in,
	input wire [QUAN_SIZE-1:0] v2c3_in,
	input wire [QUAN_SIZE-1:0] v2c4_in,
	input wire [QUAN_SIZE-1:0] v2c5_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] v2c_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_2 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_3 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_4 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_5 [0:PIPELINE_DEPTH-2];
	
	always@(posedge read_clk) v2c_0[0] <= v2c0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_1[0] <= v2c1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_2[0] <= v2c2_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_3[0] <= v2c3_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_4[0] <= v2c4_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_5[0] <= v2c5_in[QUAN_SIZE-1:0];
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) v2c_0[i] <= v2c_0[i-1];
			always@(posedge read_clk) v2c_1[i] <= v2c_1[i-1];
			always@(posedge read_clk) v2c_2[i] <= v2c_2[i-1];
			always@(posedge read_clk) v2c_3[i] <= v2c_3[i-1];
			always@(posedge read_clk) v2c_4[i] <= v2c_4[i-1];
			always@(posedge read_clk) v2c_5[i] <= v2c_5[i-1];
		end
	endgenerate
	assign M0_reg[QUAN_SIZE-1:0] = v2c_0[PIPELINE_DEPTH-2];
	assign M1_reg[QUAN_SIZE-1:0] = v2c_1[PIPELINE_DEPTH-2];
	assign M2_reg[QUAN_SIZE-1:0] = v2c_2[PIPELINE_DEPTH-2];
	assign M3_reg[QUAN_SIZE-1:0] = v2c_3[PIPELINE_DEPTH-2];
	assign M4_reg[QUAN_SIZE-1:0] = v2c_4[PIPELINE_DEPTH-2];
	assign M5_reg[QUAN_SIZE-1:0] = v2c_5[PIPELINE_DEPTH-2];
endmodule

module ib_cnu6_f1_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f10_y0,
    output wire [QUAN_SIZE-1:0] f10_y1,
    output wire [QUAN_SIZE-1:0] f11_y0,
    output wire [QUAN_SIZE-1:0] f11_y1,

    input wire [QUAN_SIZE-1:0] t_00,
    input wire [QUAN_SIZE-1:0] t_01,
    /*No need as input source of 2-LUT.F1*///input wire [QUAN_SIZE-1:0] M0,
    /*No need as input source of 2-LUT.F1*///input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    /*No need as input source of 2-LUT.F1*///input wire [QUAN_SIZE-1:0] M3,
    /*No need as input source of 2-LUT.F1*///input wire [QUAN_SIZE-1:0] M4,
    input wire [QUAN_SIZE-1:0] M5          
);

	// For the first decomposed LUT
	assign f10_y0[QUAN_SIZE-1:0] = t_00[QUAN_SIZE-1:0];
	assign f10_y1[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];    
	// For the second decomposed LUT
	assign f11_y0[QUAN_SIZE-1:0] = t_01[QUAN_SIZE-1:0];
	assign f11_y1[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];        
endmodule

module ib_f1_v2c_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] M0_reg,
	output wire [QUAN_SIZE-1:0] M1_reg,
	output wire [QUAN_SIZE-1:0] M2_reg,
	output wire [QUAN_SIZE-1:0] M3_reg,
	output wire [QUAN_SIZE-1:0] M4_reg,
	output wire [QUAN_SIZE-1:0] M5_reg,
	
	input wire [QUAN_SIZE-1:0] v2c0_in,
	input wire [QUAN_SIZE-1:0] v2c1_in,
	input wire [QUAN_SIZE-1:0] v2c2_in,
	input wire [QUAN_SIZE-1:0] v2c3_in,
	input wire [QUAN_SIZE-1:0] v2c4_in,
	input wire [QUAN_SIZE-1:0] v2c5_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] v2c_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_2 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_3 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_4 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_5 [0:PIPELINE_DEPTH-2];
	
	always@(posedge read_clk) v2c_0[0] <= v2c0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_1[0] <= v2c1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_2[0] <= v2c2_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_3[0] <= v2c3_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_4[0] <= v2c4_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_5[0] <= v2c5_in[QUAN_SIZE-1:0];
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) v2c_0[i] <= v2c_0[i-1];
			always@(posedge read_clk) v2c_1[i] <= v2c_1[i-1];
			always@(posedge read_clk) v2c_2[i] <= v2c_2[i-1];
			always@(posedge read_clk) v2c_3[i] <= v2c_3[i-1];
			always@(posedge read_clk) v2c_4[i] <= v2c_4[i-1];
			always@(posedge read_clk) v2c_5[i] <= v2c_5[i-1];
		end
	endgenerate
	assign M0_reg[QUAN_SIZE-1:0] = v2c_0[PIPELINE_DEPTH-2];
	assign M1_reg[QUAN_SIZE-1:0] = v2c_1[PIPELINE_DEPTH-2];
	assign M2_reg[QUAN_SIZE-1:0] = v2c_2[PIPELINE_DEPTH-2];
	assign M3_reg[QUAN_SIZE-1:0] = v2c_3[PIPELINE_DEPTH-2];
	assign M4_reg[QUAN_SIZE-1:0] = v2c_4[PIPELINE_DEPTH-2];
	assign M5_reg[QUAN_SIZE-1:0] = v2c_5[PIPELINE_DEPTH-2];
endmodule

module ib_cnu6_f2_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f20_y0,
    output wire [QUAN_SIZE-1:0] f20_y1,
    output wire [QUAN_SIZE-1:0] f21_y0,
    output wire [QUAN_SIZE-1:0] f21_y1,
    output wire [QUAN_SIZE-1:0] f22_y0,
    output wire [QUAN_SIZE-1:0] f22_y1,
    output wire [QUAN_SIZE-1:0] f23_y0,
    output wire [QUAN_SIZE-1:0] f23_y1,

    input wire [QUAN_SIZE-1:0] t_10,
    input wire [QUAN_SIZE-1:0] t_11,
    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    /*No need as input source of 2-LUT.F2*///input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M3,
    input wire [QUAN_SIZE-1:0] M4
    /*No need as input source of 2-LUT.F2*///input wire [QUAN_SIZE-1:0] M5
);

	// For the first decomposed LUT
	assign f20_y0[QUAN_SIZE-1:0] = t_10[QUAN_SIZE-1:0];
	assign f20_y1[QUAN_SIZE-1:0] = M3[QUAN_SIZE-1:0];    
	// For the second decomposed LUT
	assign f21_y0[QUAN_SIZE-1:0] = t_10[QUAN_SIZE-1:0];
	assign f21_y1[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];    
	// For the third decomposed LUT
	assign f22_y0[QUAN_SIZE-1:0] = t_11[QUAN_SIZE-1:0];
	assign f22_y1[QUAN_SIZE-1:0] = M0[QUAN_SIZE-1:0]  ;    
	// For the fourth decomposed LUT
	assign f23_y0[QUAN_SIZE-1:0] = t_11[QUAN_SIZE-1:0];
	assign f23_y1[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0]  ;        
endmodule

module ib_f2_v2c_pipeline #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] M1_reg,
	output wire [QUAN_SIZE-1:0] M2_reg,
	output wire [QUAN_SIZE-1:0] M4_reg,
	output wire [QUAN_SIZE-1:0] M5_reg,
	
	input wire [QUAN_SIZE-1:0] v2c1_in,
	input wire [QUAN_SIZE-1:0] v2c2_in,
	input wire [QUAN_SIZE-1:0] v2c4_in,
	input wire [QUAN_SIZE-1:0] v2c5_in,
`ifdef V2C_C2V_PROBE
	output wire [QUAN_SIZE-1:0] M0_reg,
	output wire [QUAN_SIZE-1:0] M3_reg,
	input wire [QUAN_SIZE-1:0] v2c0_in,
	input wire [QUAN_SIZE-1:0] v2c3_in,
`endif
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] v2c_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_2 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_4 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_5 [0:PIPELINE_DEPTH-2];
	
	always@(posedge read_clk) v2c_1[0] <= v2c1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_2[0] <= v2c2_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_4[0] <= v2c4_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_5[0] <= v2c5_in[QUAN_SIZE-1:0];
`ifdef V2C_C2V_PROBE
	reg [QUAN_SIZE-1:0] v2c_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_3 [0:PIPELINE_DEPTH-2];
	always@(posedge read_clk) v2c_0[0] <= v2c0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_3[0] <= v2c3_in[QUAN_SIZE-1:0];	
`endif
	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) v2c_1[i] <= v2c_1[i-1];
			always@(posedge read_clk) v2c_2[i] <= v2c_2[i-1];
			always@(posedge read_clk) v2c_4[i] <= v2c_4[i-1];
			always@(posedge read_clk) v2c_5[i] <= v2c_5[i-1];
`ifdef V2C_C2V_PROBE
			always@(posedge read_clk) v2c_0[i] <= v2c_0[i-1];
			always@(posedge read_clk) v2c_3[i] <= v2c_3[i-1];
`endif
		end
	endgenerate
	assign M1_reg[QUAN_SIZE-1:0] = v2c_1[PIPELINE_DEPTH-2];
	assign M2_reg[QUAN_SIZE-1:0] = v2c_2[PIPELINE_DEPTH-2];
	assign M4_reg[QUAN_SIZE-1:0] = v2c_4[PIPELINE_DEPTH-2];
	assign M5_reg[QUAN_SIZE-1:0] = v2c_5[PIPELINE_DEPTH-2];
`ifdef V2C_C2V_PROBE
	assign M0_reg[QUAN_SIZE-1:0] = v2c_0[PIPELINE_DEPTH-2];
	assign M3_reg[QUAN_SIZE-1:0] = v2c_3[PIPELINE_DEPTH-2];
`endif
endmodule

module ib_cnu6_f3_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f30_y0,
    output wire [QUAN_SIZE-1:0] f30_y1,
    output wire [QUAN_SIZE-1:0] f31_y0,
    output wire [QUAN_SIZE-1:0] f31_y1,
    output wire [QUAN_SIZE-1:0] f32_y0,
    output wire [QUAN_SIZE-1:0] f32_y1,
    output wire [QUAN_SIZE-1:0] f33_y0,
    output wire [QUAN_SIZE-1:0] f33_y1,
    output wire [QUAN_SIZE-1:0] f34_y0,
    output wire [QUAN_SIZE-1:0] f34_y1,
    output wire [QUAN_SIZE-1:0] f35_y0,
    output wire [QUAN_SIZE-1:0] f35_y1,

    input wire [QUAN_SIZE-1:0] t_20,
    input wire [QUAN_SIZE-1:0] t_21,
    input wire [QUAN_SIZE-1:0] t_22,
    input wire [QUAN_SIZE-1:0] t_23,
    input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M4,
    input wire [QUAN_SIZE-1:0] M5          
);

	// For the first decomposed LUT
	assign f30_y0[QUAN_SIZE-1:0] = t_20[QUAN_SIZE-1:0];
	assign f30_y1[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];    
	// For the second decomposed LUT
	assign f31_y0[QUAN_SIZE-1:0] = t_20[QUAN_SIZE-1:0];
	assign f31_y1[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
	// For the third decomposed LUT
	assign f32_y0[QUAN_SIZE-1:0] = t_21[QUAN_SIZE-1:0];
	assign f32_y1[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
	// For the fourth decomposed LUT
	assign f33_y0[QUAN_SIZE-1:0] = t_22[QUAN_SIZE-1:0];
	assign f33_y1[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0];    
	// For the fifth decomposed LUT
	assign f34_y0[QUAN_SIZE-1:0] = t_22[QUAN_SIZE-1:0];
	assign f34_y1[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];    
	// For the sixth decomposed LUT
	assign f35_y0[QUAN_SIZE-1:0] = t_23[QUAN_SIZE-1:0];
	assign f35_y1[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];    
endmodule

// Only used for runtime debugging
module ib_f3_v2c_pipeline_probe #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire [QUAN_SIZE-1:0] M0_reg,
	output wire [QUAN_SIZE-1:0] M1_reg,
	output wire [QUAN_SIZE-1:0] M2_reg,
	output wire [QUAN_SIZE-1:0] M3_reg,
	output wire [QUAN_SIZE-1:0] M4_reg,
	output wire [QUAN_SIZE-1:0] M5_reg,

	input wire [QUAN_SIZE-1:0] v2c0_in,
	input wire [QUAN_SIZE-1:0] v2c1_in,
	input wire [QUAN_SIZE-1:0] v2c2_in,
	input wire [QUAN_SIZE-1:0] v2c3_in,
	input wire [QUAN_SIZE-1:0] v2c4_in,
	input wire [QUAN_SIZE-1:0] v2c5_in,
	input wire read_clk
);
	// PIPELINE_DEPTH pipeline stages require two pipeline registers
	reg [QUAN_SIZE-1:0] v2c_0 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_1 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_2 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_3 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_4 [0:PIPELINE_DEPTH-2];
	reg [QUAN_SIZE-1:0] v2c_5 [0:PIPELINE_DEPTH-2];
	
	always@(posedge read_clk) v2c_0[0] <= v2c0_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_1[0] <= v2c1_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_2[0] <= v2c2_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_3[0] <= v2c3_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_4[0] <= v2c4_in[QUAN_SIZE-1:0];
	always@(posedge read_clk) v2c_5[0] <= v2c5_in[QUAN_SIZE-1:0];	

	genvar i;
	generate
		for(i = 1; i < PIPELINE_DEPTH - 1; i=i+1) begin : c2v_msg_pipe_inst
			always@(posedge read_clk) v2c_0[i] <= v2c_0[i-1];
			always@(posedge read_clk) v2c_1[i] <= v2c_1[i-1];
			always@(posedge read_clk) v2c_2[i] <= v2c_2[i-1];
			always@(posedge read_clk) v2c_3[i] <= v2c_3[i-1];
			always@(posedge read_clk) v2c_4[i] <= v2c_4[i-1];
			always@(posedge read_clk) v2c_5[i] <= v2c_5[i-1];
		end
	endgenerate
	assign M0_reg[QUAN_SIZE-1:0] = v2c_0[PIPELINE_DEPTH-2];
	assign M1_reg[QUAN_SIZE-1:0] = v2c_1[PIPELINE_DEPTH-2];
	assign M2_reg[QUAN_SIZE-1:0] = v2c_2[PIPELINE_DEPTH-2];
	assign M3_reg[QUAN_SIZE-1:0] = v2c_3[PIPELINE_DEPTH-2];
	assign M4_reg[QUAN_SIZE-1:0] = v2c_4[PIPELINE_DEPTH-2];
	assign M5_reg[QUAN_SIZE-1:0] = v2c_5[PIPELINE_DEPTH-2];
endmodule
