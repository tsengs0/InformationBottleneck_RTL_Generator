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

module ib_cnu6_f0_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f00_y0,
    output wire [QUAN_SIZE-1:0] f00_y1,
    output wire [QUAN_SIZE-1:0] f01_y0,
    output wire [QUAN_SIZE-1:0] f01_y1,
    output wire [QUAN_SIZE-1:0] M0_reg,
    output wire [QUAN_SIZE-1:0] M1_reg,
    output wire [QUAN_SIZE-1:0] M2_reg,
    output wire [QUAN_SIZE-1:0] M3_reg,
    output wire [QUAN_SIZE-1:0] M4_reg,
    output wire [QUAN_SIZE-1:0] M5_reg,
        
    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M3,
    input wire [QUAN_SIZE-1:0] M4,
    input wire [QUAN_SIZE-1:0] M5
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
	
	assign M0_reg[QUAN_SIZE-1:0] = M0[QUAN_SIZE-1:0];
	assign M1_reg[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0];
	assign M2_reg[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];
	assign M3_reg[QUAN_SIZE-1:0] = M3[QUAN_SIZE-1:0];
	assign M4_reg[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];
	assign M5_reg[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
endmodule

module ib_cnu6_f1_route #(
	parameter QUAN_SIZE = 4
)(
    output wire [QUAN_SIZE-1:0] f10_y0,
    output wire [QUAN_SIZE-1:0] f10_y1,
    output wire [QUAN_SIZE-1:0] f11_y0,
    output wire [QUAN_SIZE-1:0] f11_y1,
    output wire [QUAN_SIZE-1:0] M0_reg,
    output wire [QUAN_SIZE-1:0] M1_reg,
    output wire [QUAN_SIZE-1:0] M2_reg,
    output wire [QUAN_SIZE-1:0] M3_reg,
    output wire [QUAN_SIZE-1:0] M4_reg,
    output wire [QUAN_SIZE-1:0] M5_reg,

    input wire [QUAN_SIZE-1:0] t_00,
    input wire [QUAN_SIZE-1:0] t_01,
    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M3,
    input wire [QUAN_SIZE-1:0] M4,
    input wire [QUAN_SIZE-1:0] M5          
);

	// For the first decomposed LUT
	assign f10_y0[QUAN_SIZE-1:0] = t_00[QUAN_SIZE-1:0];
	assign f10_y1[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];    
	// For the second decomposed LUT
	assign f11_y0[QUAN_SIZE-1:0] = t_01[QUAN_SIZE-1:0];
	assign f11_y1[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
	
	assign M0_reg[QUAN_SIZE-1:0] = M0[QUAN_SIZE-1:0];
	assign M1_reg[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0];
	assign M2_reg[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];
	assign M3_reg[QUAN_SIZE-1:0] = M3[QUAN_SIZE-1:0];
	assign M4_reg[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];
	assign M5_reg[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
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
    output wire [QUAN_SIZE-1:0] M1_reg,
    output wire [QUAN_SIZE-1:0] M2_reg,
    output wire [QUAN_SIZE-1:0] M4_reg,
    output wire [QUAN_SIZE-1:0] M5_reg,

    input wire [QUAN_SIZE-1:0] t_10,
    input wire [QUAN_SIZE-1:0] t_11,
    input wire [QUAN_SIZE-1:0] M0,
    input wire [QUAN_SIZE-1:0] M1,
    input wire [QUAN_SIZE-1:0] M2,
    input wire [QUAN_SIZE-1:0] M3,
    input wire [QUAN_SIZE-1:0] M4,
    input wire [QUAN_SIZE-1:0] M5
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
	
	assign M1_reg[QUAN_SIZE-1:0] = M1[QUAN_SIZE-1:0];
	assign M2_reg[QUAN_SIZE-1:0] = M2[QUAN_SIZE-1:0];
	assign M4_reg[QUAN_SIZE-1:0] = M4[QUAN_SIZE-1:0];
	assign M5_reg[QUAN_SIZE-1:0] = M5[QUAN_SIZE-1:0];    
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