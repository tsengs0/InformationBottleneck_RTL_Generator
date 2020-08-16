`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: sym_vn_lut_out
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
module sym_vn_lut_out (
	// For read operation
	// Port A
	output wire [3:0] t_c_A,
	output wire transpose_en_outA,
	input wire transpose_en_inA,
	input wire [3:0] y0_in_A,
	input wire [3:0] y1_in_A,

	// Port B
	output wire [3:0] t_c_B,
	output wire transpose_en_outB,
	input wire transpose_en_inB,
	input wire [3:0] y0_in_B,
	input wire [3:0] y1_in_B,

	// Port C
	output wire [3:0] t_c_C,
	output wire transpose_en_outC,
	input wire transpose_en_inC,
	input wire [3:0] y0_in_C,
	input wire [3:0] y1_in_C,

	// Port D
	output wire [3:0] t_c_D,
	output wire transpose_en_outD,
	input wire transpose_en_inD,
	input wire [3:0] y0_in_D,
	input wire [3:0] y1_in_D,

	output wire read_addr_offset_out,
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
	// Input port of Read Port A to D
	wire [3:0] y0_mux_A, y1_mux_A;
	xor transpose_y02A(y0_mux_A[2], y0_in_A[2], y0_in_A[3]);
	xor transpose_y01A(y0_mux_A[1], y0_in_A[1], y0_in_A[3]);
	xor transpose_y00A(y0_mux_A[0], y0_in_A[0], y0_in_A[3]);
	xor transpose_y03A(y0_mux_A[3], transpose_en_inA, y0_in_A[3]);
	assign y1_mux_A[3:0] = (y0_mux_A[3] == 1'b1) ? ~y1_in_A[3:0] : y1_in_A[3:0];

	wire [3:0] y0_mux_B, y1_mux_B;
	xor transpose_y02B(y0_mux_B[2], y0_in_B[2], y0_in_B[3]);
	xor transpose_y01B(y0_mux_B[1], y0_in_B[1], y0_in_B[3]);
	xor transpose_y00B(y0_mux_B[0], y0_in_B[0], y0_in_B[3]);
	xor transpose_y03B(y0_mux_B[3], transpose_en_inB, y0_in_B[3]);
	assign y1_mux_B[3:0] = (y0_mux_B[3] == 1'b1) ? ~y1_in_B[3:0] : y1_in_B[3:0];

	wire [3:0] y0_mux_C, y1_mux_C;
	xor transpose_y02C(y0_mux_C[2], y0_in_C[2], y0_in_C[3]);
	xor transpose_y01C(y0_mux_C[1], y0_in_C[1], y0_in_C[3]);
	xor transpose_y00C(y0_mux_C[0], y0_in_C[0], y0_in_C[3]);
	xor transpose_y03C(y0_mux_C[3], transpose_en_inC, y0_in_C[3]);
	assign y1_mux_C[3:0] = (y0_mux_C[3] == 1'b1) ? ~y1_in_C[3:0] : y1_in_C[3:0];

	wire [3:0] y0_mux_D, y1_mux_D;
	xor transpose_y02D(y0_mux_D[2], y0_in_D[2], y0_in_D[3]);
	xor transpose_y01D(y0_mux_D[1], y0_in_D[1], y0_in_D[3]);
	xor transpose_y00D(y0_mux_D[0], y0_in_D[0], y0_in_D[3]);
	xor transpose_y03D(y0_mux_D[3], transpose_en_inD, y0_in_D[3]);
	assign y1_mux_D[3:0] = (y0_mux_D[3] == 1'b1) ? ~y1_in_D[3:0] : y1_in_D[3:0];
	
	wire msb_A, msb_B, msb_C, msb_D;
	assign msb_A = y0_mux_A[3];
	assign msb_B = y0_mux_B[3];
	assign msb_C = y0_mux_C[3];
	assign msb_D = y0_mux_D[3];
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 0
	reg [2:0] y0_pipe0_A, y0_pipe0_B, y0_pipe0_C, y0_pipe0_D;
	reg [3:0] y1_pipe0_A, y1_pipe0_B, y1_pipe0_C, y1_pipe0_D;
	reg msb_pipe0_A, msb_pipe0_B, msb_pipe0_C, msb_pipe0_D;
	reg read_addr_offset_pipe0;
	initial begin
		y0_pipe0_A[2:0] <= 0;
		y0_pipe0_B[2:0] <= 0;
		y0_pipe0_C[2:0] <= 0;
		y0_pipe0_D[2:0] <= 0;
		y1_pipe0_A[3:0] <= 0;
		y1_pipe0_B[3:0] <= 0;
		y1_pipe0_C[3:0] <= 0;
		y1_pipe0_D[3:0] <= 0;
		read_addr_offset_pipe0 <= 0;
		msb_pipe0_A <= 0;
		msb_pipe0_B <= 0;
		msb_pipe0_C <= 0;
		msb_pipe0_D <= 0;
	end
	always @(posedge read_clk) begin
		y0_pipe0_A[2:0] <= y0_mux_A[2:0];
		y0_pipe0_B[2:0] <= y0_mux_B[2:0];
		y0_pipe0_C[2:0] <= y0_mux_C[2:0];
		y0_pipe0_D[2:0] <= y0_mux_D[2:0];
		y1_pipe0_A[3:0] <= y1_mux_A[3:0];
		y1_pipe0_B[3:0] <= y1_mux_B[3:0];
		y1_pipe0_C[3:0] <= y1_mux_C[3:0];
		y1_pipe0_D[3:0] <= y1_mux_D[3:0];
	end
	always @(posedge read_clk) begin
		msb_pipe0_A <= msb_A;
		msb_pipe0_B <= msb_B;
		msb_pipe0_C <= msb_C;
		msb_pipe0_D <= msb_D;
	end
	always @(posedge read_clk) read_addr_offset_pipe0 <= read_addr_offset;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 1
	wire [5:0] page_addr_pipe0_A, page_addr_pipe0_B, page_addr_pipe0_C, page_addr_pipe0_D;
	wire bank_addr_pipe0_A, bank_addr_pipe0_B, bank_addr_pipe0_C, bank_addr_pipe0_D; 
	vn_addr_bus addr_bus(
		// For port A (output)
		.page_addr_A (page_addr_pipe0_A[5:0]),
		.bank_addr_A (bank_addr_pipe0_A),
		// For port B (output)
		.page_addr_B (page_addr_pipe0_B[5:0]),
		.bank_addr_B (bank_addr_pipe0_B),
		// For port C (output)
		.page_addr_C (page_addr_pipe0_C[5:0]),
		.bank_addr_C (bank_addr_pipe0_C),
		// For port D (output)
		.page_addr_D (page_addr_pipe0_D[5:0]),
		.bank_addr_D (bank_addr_pipe0_D),
		
		// For port A (input, two coreesponding incoming messages)
		.y0_in_A (y0_pipe0_A[2:0]),
		.y1_in_A (y1_pipe0_A[3:0]),
		// For port B (input, two coreesponding incoming messages)
		.y0_in_B (y0_pipe0_B[2:0]),
		.y1_in_B (y1_pipe0_B[3:0]),
		// For port C (input, two coreesponding incoming messages)
		.y0_in_C (y0_pipe0_C[2:0]),
		.y1_in_C (y1_pipe0_C[3:0]),
		// For port D (input, two coreesponding incoming messages)
		.y0_in_D (y0_pipe0_D[2:0]),
		.y1_in_D (y1_pipe0_D[3:0])
	);		
	
	wire [3:0] OutA, OutB, OutC, OutD;
	reg [3:0] OutA_pipe1, OutB_pipe1, OutC_pipe1, OutD_pipe1;
	reg msb_pipe1_A, msb_pipe1_B, msb_pipe1_C, msb_pipe1_D;
	reg read_addr_offset_pipe1;
	sym_vn_rank rank_m(
		// For read operation
	   .lut_data0    (OutA[3:0]),   
	   .lut_data1    (OutB[3:0]),   
	   .lut_data2    (OutC[3:0]),   
	   .lut_data3    (OutD[3:0]),

	   // For VNU0
	   .bank_addr_0        (bank_addr_pipe0_A),
	   .page_addr_0        (page_addr_pipe0_A[5:0]),
	   .page_addr_offset_0 (read_addr_offset_pipe0),
	   // For VNU1
	   .bank_addr_1        (bank_addr_pipe0_B),
	   .page_addr_1        (page_addr_pipe0_B[5:0]),
	   .page_addr_offset_1 (read_addr_offset_pipe0),
	   // For VNU2
	   .bank_addr_2 	   (bank_addr_pipe0_C),
	   .page_addr_2 	   (page_addr_pipe0_C[5:0]),
	   .page_addr_offset_2 (read_addr_offset_pipe0),
	   // For VNU3
	   .bank_addr_3        (bank_addr_pipe0_D),
	   .page_addr_3        (page_addr_pipe0_D[5:0]),
	   .page_addr_offset_3 (read_addr_offset_pipe0),
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
		OutC_pipe1[3:0]        <= 0;
		OutD_pipe1[3:0]        <= 0;
		msb_pipe1_A <= 0;
		msb_pipe1_B <= 0;
		msb_pipe1_C <= 0;
		msb_pipe1_D <= 0;
		read_addr_offset_pipe1 <= 0;
	end
	always @(posedge read_clk) OutA_pipe1[3:0] <= OutA[3:0];
	always @(posedge read_clk) OutB_pipe1[3:0] <= OutB[3:0];
	always @(posedge read_clk) OutC_pipe1[3:0] <= OutC[3:0];
	always @(posedge read_clk) OutD_pipe1[3:0] <= OutD[3:0];
	always @(posedge read_clk) begin
		msb_pipe1_A <= msb_pipe0_A;
		msb_pipe1_B <= msb_pipe0_B;
		msb_pipe1_C <= msb_pipe0_C;
		msb_pipe1_D <= msb_pipe0_D;
	end
	always @(posedge read_clk) read_addr_offset_pipe1 <= read_addr_offset_pipe0;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 2	
	assign t_c_A[3:0] = (msb_pipe1_A == 1'b1) ? ~OutA_pipe1[3:0] : OutA_pipe1[3:0];
	assign t_c_B[3:0] = (msb_pipe1_B == 1'b1) ? ~OutB_pipe1[3:0] : OutB_pipe1[3:0];
	assign t_c_C[3:0] = (msb_pipe1_C == 1'b1) ? ~OutC_pipe1[3:0] : OutC_pipe1[3:0];
	assign t_c_D[3:0] = (msb_pipe1_D == 1'b1) ? ~OutD_pipe1[3:0] : OutD_pipe1[3:0];
	assign transpose_en_outA = msb_pipe1_A; // for the decision node in the next stage
	assign transpose_en_outB = msb_pipe1_B; // for the decision node in the next stage
	assign transpose_en_outC = msb_pipe1_C; // for the decision node in the next stage
	assign transpose_en_outD = msb_pipe1_D; // for the decision node in the next stage
	assign read_addr_offset_out = read_addr_offset_pipe1;
endmodule