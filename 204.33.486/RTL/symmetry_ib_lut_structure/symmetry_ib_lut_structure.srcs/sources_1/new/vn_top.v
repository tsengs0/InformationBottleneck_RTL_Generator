`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2020 05:05:56 PM
// Design Name: 
// Module Name: vn_top
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
module vn_top(
    output wire [3:0] v2cA,
	output wire [3:0] v2cB,
	output wire [3:0] v2cC,

	// Port A
    input wire [3:0] c2v_A0,
    input wire [3:0] c2v_A1,
    input wire [3:0] c2v_A2,
    input wire [3:0] c2v_A3,
/*
	// Port B
    input wire [3:0] v2c_B0,
    input wire [3:0] v2c_B1,
    input wire [3:0] v2c_B2,
    input wire [3:0] v2c_B3,
    input wire [3:0] v2c_B4,
	
	// Port C
    input wire [3:0] v2c_C0,
    input wire [3:0] v2c_C1,
    input wire [3:0] v2c_C2,
    input wire [3:0] v2c_C3,
    input wire [3:0] v2c_C4,
	
	// Port D
    input wire [3:0] v2c_D0,
    input wire [3:0] v2c_D1,
    input wire [3:0] v2c_D2,
    input wire [3:0] v2c_D3,
    input wire [3:0] v2c_D4,
*/
	output wire read_addr_offset_out,
	input wire read_addr_offset,
//////////////////////////////////////////////////////////
	// For write operation
	input wire [3:0] lut_in_bank0, // input data
	input wire [3:0] lut_in_bank1, // input data 
	input wire [5:0] page_write_addr, // write address
	input wire write_addr_offset, // write address offset
   	input wire we,
	input wire rstn,
	input wire CLK_300_N,
	input wire CLK_300_P
    );

wire clk_lock, read_clk, write_clk, clk_rd_gate, clk_wr_gate;
clock_domain_wrapper system_clock(
	.clk_300mhz_clk_n (CLK_300_N),
    .clk_300mhz_clk_p (CLK_300_P),
    .locked_0 (clk_lock),
    .read_clk_0 (clk_rd_gate),
    .reset (~rstn),
    .write_clk_0 (clk_wr_gate)
);
assign read_clk  = clk_rd_gate & clk_lock;
assign write_clk = clk_wr_gate & clk_lock; 

wire [3:0] t_c_A0, t_c_A1, t_c_A2;
wire [3:0] t_c_B0, t_c_B1, t_c_B2;
wire [3:0] t_c_C0, t_c_C1, t_c_C2;
wire [3:0] t_c_D0, t_c_D1, t_c_D2;
wire transpose_en_outA0, transpose_en_outB0, transpose_en_outC0, transpose_en_outD0;
wire transpose_en_outA1, transpose_en_outB1, transpose_en_outC1, transpose_en_outD1;
wire read_addr_offset_out0, read_addr_offset_out1, read_addr_offset_out2;
sym_vn_lut_in m0(
	// For read operation
	// Port A
	.t_c_A   (t_c_A0),
	.transpose_en_outA (transpose_en_outA0),
	.y0_in_A (c2v_A0),
	.y1_in_A (c2v_A1),

	// Port B
	.t_c_B   (t_c_B0),
	.transpose_en_outB (transpose_en_outB0),
	.y0_in_B (c2v_A0),
	.y1_in_B (c2v_A1),
	
	// Port C
	.t_c_C   (t_c_C0),
	.transpose_en_outC (transpose_en_outC0),
	.y0_in_C (c2v_A0),
	.y1_in_C (c2v_A1),
	
	// Port D
	.t_c_D   (t_c_D0),
	.transpose_en_outD (transpose_en_outD0),
	.y0_in_D (c2v_A0),
	.y1_in_D (c2v_A1),

	.read_addr_offset_out (read_addr_offset_out0),
	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (lut_in_bank0), // input data
	.lut_in_bank1 (lut_in_bank1), // input data 
	.page_write_addr (page_write_addr), // write address
	.write_addr_offset (write_addr_offset), // write address offset
	.we (we),
	.write_clk (write_clk)
);

sym_vn_lut_internal m1(
	// For read operation
	// Port A
	.t_c_A   (t_c_A1),
	.transpose_en_outA (transpose_en_outA1),
	.transpose_en_inA  (transpose_en_outA0),
	.y0_in_A (t_c_A0),
	.y1_in_A (c2v_A2),

	// Port B
	.t_c_B   (t_c_B1),
	.transpose_en_outB (transpose_en_outB1),
	.transpose_en_inB  (transpose_en_outB0),
	.y0_in_B (t_c_B0),
	.y1_in_B (c2v_A2),
	
	// Port C
	.t_c_C   (t_c_C1),
	.transpose_en_outC (transpose_en_outC1),
	.transpose_en_inC  (transpose_en_outC0),
	.y0_in_C (t_c_C0),
	.y1_in_C (c2v_A2),
	
	// Port D
	.t_c_D   (t_c_D1),
	.transpose_en_outD (transpose_en_outD1),
	.transpose_en_inD  (transpose_en_outD0),
	.y0_in_D (t_c_D0),
	.y1_in_D (c2v_A2),

	.read_addr_offset_out (read_addr_offset_out1),
	.read_addr_offset (read_addr_offset_out0),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (lut_in_bank0), // input data
	.lut_in_bank1 (lut_in_bank1), // input data 
	.page_write_addr (page_write_addr), // write address
	.write_addr_offset (write_addr_offset), // write address offset
	.we (we),
	.write_clk (write_clk)
);

sym_vn_lut_out m2(
	// For read operation
	// Port A
	.t_c_A   (v2cA),
	.transpose_en_inA (transpose_en_outA1),
	.y0_in_A (t_c_A1),
	.y1_in_A (c2v_A3),

	// Port B
	.t_c_B   (v2cB),
	.transpose_en_inB (transpose_en_outB1),
	.y0_in_B (t_c_B1),
	.y1_in_B (c2v_A3),
	
	// Port C
	.t_c_C   (v2cC),
	.transpose_en_inC (transpose_en_outC1),
	.y0_in_C (t_c_C1),
	.y1_in_C (c2v_A3),
	
	// Port D
	.t_c_D   (v2cD),
	.transpose_en_inD (transpose_en_outD1),
	.y0_in_D (t_c_D1),
	.y1_in_D (c2v_A3),

	.read_addr_offset_out (read_addr_offset_out),
	.read_addr_offset (read_addr_offset_out2),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (lut_in_bank0), // input data
	.lut_in_bank1 (lut_in_bank1), // input data 
	.page_write_addr (page_write_addr), // write address
	.write_addr_offset (write_addr_offset), // write address offset
	.we (we),
	.write_clk (write_clk)
);
endmodule