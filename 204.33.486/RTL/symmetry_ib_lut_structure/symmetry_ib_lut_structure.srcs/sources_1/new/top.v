`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2020 05:05:56 PM
// Design Name: 
// Module Name: top
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

module top(
    output wire [3:0] c2vA,
	output wire [3:0] c2vB,
	output wire [3:0] c2vC,
	output wire [3:0] c2vD,

	// Port A
    input wire [3:0] v2c_A0,
    input wire [3:0] v2c_A1,
    input wire [3:0] v2c_A2,
    input wire [3:0] v2c_A3,
    input wire [3:0] v2c_A4,
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
	input wire [2:0] lut_in_bank0, // input data
	input wire [2:0] lut_in_bank1, // input data 
	input wire [4:0] page_write_addr, // write address
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
wire read_addr_offset_out0, read_addr_offset_out1, read_addr_offset_out2;
sym_cn_lut_in m0(
	// For read operation
	// Port A
	.t_c_A   (t_c_A0),
	.y0_in_A (v2c_A0),
	.y1_in_A (v2c_A1),

	// Port B
	.t_c_B   (t_c_B0),
	.y0_in_B (v2c_A0),
	.y1_in_B (v2c_A1),
	
	// Port C
	.t_c_C   (t_c_C0),
	.y0_in_C (v2c_A0),
	.y1_in_C (v2c_A1),
	
	// Port D
	.t_c_D   (t_c_D0),
	.y0_in_D (v2c_A0),
	.y1_in_D (v2c_A1),

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

sym_cn_lut_internal m1(
	// For read operation
	// Port A
	.t_c_A   (t_c_A1),
	.y0_in_A (t_c_A0),
	.y1_in_A (v2c_A2),

	// Port B
	.t_c_B   (t_c_B1),
	.y0_in_B (t_c_B0),
	.y1_in_B (v2c_A2),
	
	// Port C
	.t_c_C   (t_c_C1),
	.y0_in_C (t_c_C0),
	.y1_in_C (v2c_A2),
	
	// Port D
	.t_c_D   (t_c_D1),
	.y0_in_D (t_c_D0),
	.y1_in_D (v2c_A2),

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

sym_cn_lut_internal m2(
	// For read operation
	// Port A
	.t_c_A   (t_c_A2),
	.y0_in_A (t_c_A1),
	.y1_in_A (v2c_A3),

	// Port B
	.t_c_B   (t_c_B2),
	.y0_in_B (t_c_B1),
	.y1_in_B (v2c_A3),
	
	// Port C
	.t_c_C   (t_c_C2),
	.y0_in_C (t_c_C1),
	.y1_in_C (v2c_A3),
	
	// Port D
	.t_c_D   (t_c_D2),
	.y0_in_D (t_c_D1),
	.y1_in_D (v2c_A3),

	.read_addr_offset_out (read_addr_offset_out2),
	.read_addr_offset (read_addr_offset_out1),
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

sym_cn_lut_out m3(
	// For read operation
	// Port A
	.t_c_A   (c2vA),
	.y0_in_A (t_c_A2),
	.y1_in_A (v2c_A4),

	// Port B
	.t_c_B   (c2vB),
	.y0_in_B (t_c_B2),
	.y1_in_B (v2c_A4),
	
	// Port C
	.t_c_C   (c2vC),
	.y0_in_C (t_c_C2),
	.y1_in_C (v2c_A4),
	
	// Port D
	.t_c_D   (c2vD),
	.y0_in_D (t_c_D2),
	.y1_in_D (v2c_A4),

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
