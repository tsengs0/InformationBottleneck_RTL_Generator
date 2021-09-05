`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: sym_vn_lut_in
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
// Pipeline stage: 3, i.e., two set of pipeline registers
// 
//////////////////////////////////////////////////////////////////////////////////
`include "revision_def.vh"
`include "define.vh"
module sym_vn_lut_in (
	// For read operation
	// Port A
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif [3:0] t_c_A,
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif transpose_en_outA,
	input wire [3:0] y0_in_A,
	input wire [3:0] y1_in_A,

	// Port B
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif [3:0] t_c_B,
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif transpose_en_outB,
	input wire [3:0] y0_in_B,
	input wire [3:0] y1_in_B,

	output `ifdef SYM_NO_IO_CONV reg `else wire `endif read_addr_offset_out,
	input wire read_addr_offset,
	input wire read_clk,
//////////////////////////////////////////////////////////
	// For write operation
	input wire [3:0] lut_in_bank0, // input data
	input wire [3:0] lut_in_bank1, // input data 
	input wire [5:0] page_write_addr, // write address
	input wire write_addr_offset, // write address offset
	input wire we,
	input wire write_clk
);
`ifdef SYM_VN_REV_1
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A;
	wire [3:0] y1_mux_A;
	assign y0_mux_A[2:0] = y0_in_A[2:0];//(y0_in_A[3] == 1'b1) ? ~y0_in_A[2:0] : y0_in_A[2:0];//y0_in_A[2:0];
	assign y1_mux_A[3:0] = (y0_in_A[3] == 1'b1) ? ~y1_in_A[3:0] : y1_in_A[3:0];
	
	wire [2:0] y0_mux_B;
	wire [3:0] y1_mux_B;
	assign y0_mux_B[2:0] = y0_in_B[2:0];//(y0_in_B[3] == 1'b1) ? ~y0_in_B[2:0] : y0_in_B[2:0];//y0_in_B[2:0];
	assign y1_mux_B[3:0] = (y0_in_B[3] == 1'b1) ? ~y1_in_B[3:0] : y1_in_B[3:0];
	
	wire msb_A, msb_B;
	assign msb_A = y0_in_A[3];
	assign msb_B = y0_in_B[3];
`elsif SYM_NO_IO_CONV
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A;
	wire [3:0] y1_mux_A;
	assign y0_mux_A[2:0] = y0_in_A[2:0];
	assign y1_mux_A[2:0] = y1_in_A[2:0];
	assign y1_mux_A[3] = y0_in_A[3]^y1_in_A[3];

	wire [2:0] y0_mux_B;
	wire [3:0] y1_mux_B;
	assign y0_mux_B[2:0] = y0_in_B[2:0];
	assign y1_mux_B[2:0] = y1_in_B[2:0];
	assign y1_mux_B[3] = y0_in_B[3]^y1_in_B[3];
	
	wire msb_A, msb_B;
	assign msb_A = y0_in_A[3];
	assign msb_B = y0_in_B[3];
`else
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A;
	wire [3:0] y1_mux_A;
	assign y0_mux_A[2:0] = (y0_in_A[3] == 1'b1) ? ~y0_in_A[2:0] : y0_in_A[2:0];
	assign y1_mux_A[3:0] = (y0_in_A[3] == 1'b1) ? ~y1_in_A[3:0] : y1_in_A[3:0];
	
	wire [2:0] y0_mux_B;
	wire [3:0] y1_mux_B;
	assign y0_mux_B[2:0] = (y0_in_B[3] == 1'b1) ? ~y0_in_B[2:0] : y0_in_B[2:0];
	assign y1_mux_B[3:0] = (y0_in_B[3] == 1'b1) ? ~y1_in_B[3:0] : y1_in_B[3:0];
	
	wire msb_A, msb_B;
	assign msb_A = y0_in_A[3];
	assign msb_B = y0_in_B[3];
`endif
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 0
	reg [2:0] y0_pipe0_A, y0_pipe0_B;
	reg [3:0] y1_pipe0_A, y1_pipe0_B;
	reg msb_pipe0_A, msb_pipe0_B;
	reg read_addr_offset_pipe0;
	
	initial begin
		y0_pipe0_A[2:0] <= 0;
		y0_pipe0_B[2:0] <= 0;
		y1_pipe0_A[3:0] <= 0;
		y1_pipe0_B[3:0] <= 0;
		read_addr_offset_pipe0 <= 0;
		msb_pipe0_A <= 0;
		msb_pipe0_B <= 0;
	end
	always @(posedge read_clk) begin
		y0_pipe0_A[2:0] <= y0_mux_A[2:0];
		y0_pipe0_B[2:0] <= y0_mux_B[2:0];
		y1_pipe0_A[3:0] <= y1_mux_A[3:0];
		y1_pipe0_B[3:0] <= y1_mux_B[3:0];
	end
	always @(posedge read_clk) begin
		msb_pipe0_A <= msb_A;
		msb_pipe0_B <= msb_B;
	end
	always @(posedge read_clk) read_addr_offset_pipe0 <= read_addr_offset;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 1
	wire [5:0] page_addr_pipe0_A, page_addr_pipe0_B;
	wire bank_addr_pipe0_A, bank_addr_pipe0_B; 
	vn_addr_bus addr_bus(
		// For port A (output)
		.page_addr_A (page_addr_pipe0_A[5:0]),
		.bank_addr_A (bank_addr_pipe0_A),
		// For port B (output)
		.page_addr_B (page_addr_pipe0_B[5:0]),
		.bank_addr_B (bank_addr_pipe0_B),
		
		// For port A (input, two coreesponding incoming messages)
		.y0_in_A (y0_pipe0_A[2:0]),
		.y1_in_A (y1_pipe0_A[3:0]),
		// For port B (input, two coreesponding incoming messages)
		.y0_in_B (y0_pipe0_B[2:0]),
		.y1_in_B (y1_pipe0_B[3:0])
	);	
	
	wire [3:0] OutA, OutB;
	reg [3:0] OutA_pipe1, OutB_pipe1;
	reg msb_pipe1_A, msb_pipe1_B;
	reg read_addr_offset_pipe1;
	sym_vn_rank rank_m(
		// For read operation
	   .lut_data0    (OutA[3:0]),   
	   .lut_data1    (OutB[3:0]),   
	   
	   // For VNU0
	   .bank_addr_0        (bank_addr_pipe0_A),
	   .page_addr_0        (page_addr_pipe0_A[5:0]),
	   .page_addr_offset_0 (read_addr_offset_pipe0),
	   // For VNU1
	   .bank_addr_1        (bank_addr_pipe0_B),
	   .page_addr_1        (page_addr_pipe0_B[5:0]),
	   .page_addr_offset_1 (read_addr_offset_pipe0),
	   /////////////////////////////////////////////////////////////////////
	   // For write operation
	   .lut_in_bank0 (lut_in_bank0[3:0]), // update data in  
	   .lut_in_bank1 (lut_in_bank1[3:0]), // update data in

	   .page_write_addr   (page_write_addr[5:0]),
	   .write_addr_offset (write_addr_offset),

   	   .we (we),
	   .write_clk (write_clk)
	);

	initial begin
		OutA_pipe1[3:0]        <= 0;
		OutB_pipe1[3:0]        <= 0;
		msb_pipe1_A <= 0;
		msb_pipe1_B <= 0;
		read_addr_offset_pipe1 <= 0;
	end
	always @(posedge read_clk) OutA_pipe1[3:0] <= OutA[3:0];
	always @(posedge read_clk) OutB_pipe1[3:0] <= OutB[3:0];
	always @(posedge read_clk) begin
		msb_pipe1_A <= msb_pipe0_A;
		msb_pipe1_B <= msb_pipe0_B;
	end
	always @(posedge read_clk) read_addr_offset_pipe1 <= read_addr_offset_pipe0;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 2
`ifdef SYM_NO_IO_CONV
	always @(posedge read_clk) read_addr_offset_out <= read_addr_offset_pipe1;
	// Output of 2-input IB-LUT
	always @(posedge read_clk) t_c_A[3:0] <= OutA_pipe1[3:0];
	always @(posedge read_clk) t_c_B[3:0] <= OutB_pipe1[3:0];
	// Enable signal of matrix transpose 
	always @(posedge read_clk) transpose_en_outA <= msb_pipe1_A;
	always @(posedge read_clk) transpose_en_outB <= msb_pipe1_B;
`else
	assign read_addr_offset_out = read_addr_offset_pipe1;
	// Output of 2-input IB-LUT
	assign t_c_A[3:0] = OutA_pipe1[3:0];
	assign t_c_B[3:0] = OutB_pipe1[3:0];
	// Enable signal of matrix transpose 
	assign transpose_en_outA = msb_pipe1_A;
	assign transpose_en_outB = msb_pipe1_B;
`endif
endmodule