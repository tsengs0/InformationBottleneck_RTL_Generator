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
`include "revision_def.vh"
module sym_vn_lut_out #(
	parameter QUAN_SIZE = 3,
	parameter LUT_PORT_SIZE = 3,
	parameter ENTRY_ADDR = 5,
	parameter MULTI_FRAME_NUM = 2
) (
	// For read operation
	// Port A
	output wire [QUAN_SIZE-1:0] t_c_A,
	output wire [QUAN_SIZE-1:0] t_c_dinA, // the input source to decision node in the next step (without complement conversion)
	output wire transpose_en_outA,
	input wire transpose_en_inA,
	input wire [QUAN_SIZE-1:0] y0_in_A,
	input wire [QUAN_SIZE-1:0] y1_in_A,

	// Port B
	output wire [QUAN_SIZE-1:0] t_c_B,
	output wire [QUAN_SIZE-1:0] t_c_dinB, // the input source to decision node in the next step (without complement conversion)
	output wire transpose_en_outB,
	input wire transpose_en_inB,
	input wire [QUAN_SIZE-1:0] y0_in_B,
	input wire [QUAN_SIZE-1:0] y1_in_B,

	// Port C
	output wire [QUAN_SIZE-1:0] t_c_C,
	output wire [QUAN_SIZE-1:0] t_c_dinC, // the input source to decision node in the next step (without complement conversion)
	output wire transpose_en_outC,
	input wire transpose_en_inC,
	input wire [QUAN_SIZE-1:0] y0_in_C,
	input wire [QUAN_SIZE-1:0] y1_in_C,

	// Port D
	output wire [QUAN_SIZE-1:0] t_c_D,
	output wire [QUAN_SIZE-1:0] t_c_dinD, // the input source to decision node in the next step (without complement conversion)
	output wire transpose_en_outD,
	input wire transpose_en_inD,
	input wire [QUAN_SIZE-1:0] y0_in_D,
	input wire [QUAN_SIZE-1:0] y1_in_D,

	output wire read_addr_offset_out,
	input wire read_addr_offset,
	input wire read_clk,
//////////////////////////////////////////////////////////
	// For write operation
	input wire [LUT_PORT_SIZE-1:0] lut_in_bank0, // input data
	input wire [LUT_PORT_SIZE-1:0] lut_in_bank1, // input data 
	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_write_addr, // write address
	input wire write_addr_offset, // write address offset
	input wire we,
	input wire write_clk
);
	// Input port of Read Port A to D
	wire [QUAN_SIZE-1:0] y0_mux_A, y1_mux_A;
	wire [QUAN_SIZE-1:0] y0_mux_B, y1_mux_B;
	wire [QUAN_SIZE-1:0] y0_mux_C, y1_mux_C;
	wire [QUAN_SIZE-1:0] y0_mux_D, y1_mux_D;
	genvar i;
	generate
		for(i=0;i<QUAN_SIZE-1;i=i+1) begin : transpose_y_gen
			`ifndef SYM_VN_REV_1
				xor transpose_yA(y0_mux_A[i], y0_in_A[i], y0_in_A[QUAN_SIZE-1]);
				xor transpose_yB(y0_mux_B[i], y0_in_B[i], y0_in_B[QUAN_SIZE-1]);
				xor transpose_yC(y0_mux_C[i], y0_in_C[i], y0_in_C[QUAN_SIZE-1]);
				xor transpose_yD(y0_mux_D[i], y0_in_D[i], y0_in_D[QUAN_SIZE-1]);
			`else
				assign y0_mux_A[i] = y0_in_A[i];
				assign y0_mux_B[i] = y0_in_B[i];
				assign y0_mux_C[i] = y0_in_C[i];
				assign y0_mux_D[i] = y0_in_D[i];
			`endif
		end	
	endgenerate
	xor transpose_yA_MSB(y0_mux_A[QUAN_SIZE-1], transpose_en_inA, y0_in_A[QUAN_SIZE-1]);
	xor transpose_yB_MSB(y0_mux_B[QUAN_SIZE-1], transpose_en_inB, y0_in_B[QUAN_SIZE-1]);
	xor transpose_yC_MSB(y0_mux_C[QUAN_SIZE-1], transpose_en_inC, y0_in_C[QUAN_SIZE-1]);
	xor transpose_yD_MSB(y0_mux_D[QUAN_SIZE-1], transpose_en_inD, y0_in_D[QUAN_SIZE-1]);
	assign y1_mux_A[QUAN_SIZE-1:0] = (y0_mux_A[QUAN_SIZE-1] == 1'b1) ? ~y1_in_A[QUAN_SIZE-1:0] : y1_in_A[QUAN_SIZE-1:0];
	assign y1_mux_B[QUAN_SIZE-1:0] = (y0_mux_B[QUAN_SIZE-1] == 1'b1) ? ~y1_in_B[QUAN_SIZE-1:0] : y1_in_B[QUAN_SIZE-1:0];
	assign y1_mux_C[QUAN_SIZE-1:0] = (y0_mux_C[QUAN_SIZE-1] == 1'b1) ? ~y1_in_C[QUAN_SIZE-1:0] : y1_in_C[QUAN_SIZE-1:0];
	assign y1_mux_D[QUAN_SIZE-1:0] = (y0_mux_D[QUAN_SIZE-1] == 1'b1) ? ~y1_in_D[QUAN_SIZE-1:0] : y1_in_D[QUAN_SIZE-1:0];	
	
	wire msb_A, msb_B, msb_C, msb_D;
	assign msb_A = y0_mux_A[QUAN_SIZE-1];
	assign msb_B = y0_mux_B[QUAN_SIZE-1];
	assign msb_C = y0_mux_C[QUAN_SIZE-1];
	assign msb_D = y0_mux_D[QUAN_SIZE-1];
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 0
	reg [LUT_PORT_SIZE-2:0] y0_pipe0_A, y0_pipe0_B, y0_pipe0_C, y0_pipe0_D;
	reg [QUAN_SIZE-1:0] y1_pipe0_A, y1_pipe0_B, y1_pipe0_C, y1_pipe0_D;
	reg msb_pipe0_A, msb_pipe0_B, msb_pipe0_C, msb_pipe0_D;
	reg read_addr_offset_pipe0;
	initial begin
		y0_pipe0_A[LUT_PORT_SIZE-2:0] <= 0;
		y0_pipe0_B[LUT_PORT_SIZE-2:0] <= 0;
		y0_pipe0_C[LUT_PORT_SIZE-2:0] <= 0;
		y0_pipe0_D[LUT_PORT_SIZE-2:0] <= 0;
		y1_pipe0_A[QUAN_SIZE-1:0] <= 0;
		y1_pipe0_B[QUAN_SIZE-1:0] <= 0;
		y1_pipe0_C[QUAN_SIZE-1:0] <= 0;
		y1_pipe0_D[QUAN_SIZE-1:0] <= 0;
		read_addr_offset_pipe0 <= 0;
		msb_pipe0_A <= 0;
		msb_pipe0_B <= 0;
		msb_pipe0_C <= 0;
		msb_pipe0_D <= 0;
	end
	always @(posedge read_clk) begin
		y0_pipe0_A[LUT_PORT_SIZE-2:0] <= y0_mux_A[LUT_PORT_SIZE-2:0];
		y0_pipe0_B[LUT_PORT_SIZE-2:0] <= y0_mux_B[LUT_PORT_SIZE-2:0];
		y0_pipe0_C[LUT_PORT_SIZE-2:0] <= y0_mux_C[LUT_PORT_SIZE-2:0];
		y0_pipe0_D[LUT_PORT_SIZE-2:0] <= y0_mux_D[LUT_PORT_SIZE-2:0];
		y1_pipe0_A[QUAN_SIZE-1:0] <= y1_mux_A[QUAN_SIZE-1:0];
		y1_pipe0_B[QUAN_SIZE-1:0] <= y1_mux_B[QUAN_SIZE-1:0];
		y1_pipe0_C[QUAN_SIZE-1:0] <= y1_mux_C[QUAN_SIZE-1:0];
		y1_pipe0_D[QUAN_SIZE-1:0] <= y1_mux_D[QUAN_SIZE-1:0];
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
	wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_pipe0_A, page_addr_pipe0_B, page_addr_pipe0_C, page_addr_pipe0_D;
	wire bank_addr_pipe0_A, bank_addr_pipe0_B, bank_addr_pipe0_C, bank_addr_pipe0_D; 
	vn_addr_bus #(
		.QUAN_SIZE       (QUAN_SIZE      ),
		.LUT_PORT_SIZE   (LUT_PORT_SIZE  ),
		.ENTRY_ADDR      (ENTRY_ADDR     ),
		.MULTI_FRAME_NUM (MULTI_FRAME_NUM)
	) addr_bus(
		// For port A (output)
		.page_addr_A (page_addr_pipe0_A[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr_A (bank_addr_pipe0_A),
		// For port B (output)
		.page_addr_B (page_addr_pipe0_B[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr_B (bank_addr_pipe0_B),
		// For port C (output)
		.page_addr_C (page_addr_pipe0_C[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr_C (bank_addr_pipe0_C),
		// For port D (output)
		.page_addr_D (page_addr_pipe0_D[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr_D (bank_addr_pipe0_D),
		
		// For port A (input, two coreesponding incoming messages)
		.y0_in_A (y0_pipe0_A[LUT_PORT_SIZE-2:0]),
		.y1_in_A (y1_pipe0_A[QUAN_SIZE-1:0]),
		// For port B (input, two coreesponding incoming messages)
		.y0_in_B (y0_pipe0_B[LUT_PORT_SIZE-2:0]),
		.y1_in_B (y1_pipe0_B[QUAN_SIZE-1:0]),
		// For port C (input, two coreesponding incoming messages)
		.y0_in_C (y0_pipe0_C[LUT_PORT_SIZE-2:0]),
		.y1_in_C (y1_pipe0_C[QUAN_SIZE-1:0]),
		// For port D (input, two coreesponding incoming messages)
		.y0_in_D (y0_pipe0_D[LUT_PORT_SIZE-2:0]),
		.y1_in_D (y1_pipe0_D[QUAN_SIZE-1:0])
	);		
	
	wire [LUT_PORT_SIZE-1:0] OutA, OutB, OutC, OutD;
	reg [LUT_PORT_SIZE-1:0] OutA_pipe1, OutB_pipe1, OutC_pipe1, OutD_pipe1;
	reg msb_pipe1_A, msb_pipe1_B, msb_pipe1_C, msb_pipe1_D;
	reg read_addr_offset_pipe1;
	sym_vn_rank #(
		.QUAN_SIZE       (LUT_PORT_SIZE  ),
		.ENTRY_ADDR      (ENTRY_ADDR     ),
		.MULTI_FRAME_NUM (MULTI_FRAME_NUM)
	) rank_m(
		// For read operation
	   .lut_data0    (OutA[LUT_PORT_SIZE-1:0]),   
	   .lut_data1    (OutB[LUT_PORT_SIZE-1:0]),   
	   .lut_data2    (OutC[LUT_PORT_SIZE-1:0]),   
	   .lut_data3    (OutD[LUT_PORT_SIZE-1:0]),

	   // For VNU0
	   .bank_addr_0        (bank_addr_pipe0_A),
	   .page_addr_0        (page_addr_pipe0_A[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
	   .page_addr_offset_0 (read_addr_offset_pipe0),
	   // For VNU1
	   .bank_addr_1        (bank_addr_pipe0_B),
	   .page_addr_1        (page_addr_pipe0_B[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
	   .page_addr_offset_1 (read_addr_offset_pipe0),
	   // For VNU2
	   .bank_addr_2 	   (bank_addr_pipe0_C),
	   .page_addr_2 	   (page_addr_pipe0_C[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
	   .page_addr_offset_2 (read_addr_offset_pipe0),
	   // For VNU3
	   .bank_addr_3        (bank_addr_pipe0_D),
	   .page_addr_3        (page_addr_pipe0_D[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
	   .page_addr_offset_3 (read_addr_offset_pipe0),
	   /////////////////////////////////////////////////////////////////////
	   // For write operation
	   .lut_in_bank0 (lut_in_bank0[LUT_PORT_SIZE-1:0]), // update data in  
	   .lut_in_bank1 (lut_in_bank1[LUT_PORT_SIZE-1:0]), // update data in

	   .page_write_addr   (page_write_addr[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
	   .write_addr_offset (write_addr_offset),

   	   .we (we),
	   .write_clk (write_clk)
	);

	initial begin
		OutA_pipe1[LUT_PORT_SIZE-1:0]        <= 0;
		OutB_pipe1[LUT_PORT_SIZE-1:0]        <= 0;
		OutC_pipe1[LUT_PORT_SIZE-1:0]        <= 0;
		OutD_pipe1[LUT_PORT_SIZE-1:0]        <= 0;	
		msb_pipe1_A <= 0;
		msb_pipe1_B <= 0;
		msb_pipe1_C <= 0;
		msb_pipe1_D <= 0;
		read_addr_offset_pipe1 <= 0;
	end
	always @(posedge read_clk) OutA_pipe1[LUT_PORT_SIZE-1:0] <= OutA[LUT_PORT_SIZE-1:0];
	always @(posedge read_clk) OutB_pipe1[LUT_PORT_SIZE-1:0] <= OutB[LUT_PORT_SIZE-1:0];
	always @(posedge read_clk) OutC_pipe1[LUT_PORT_SIZE-1:0] <= OutC[LUT_PORT_SIZE-1:0];
	always @(posedge read_clk) OutD_pipe1[LUT_PORT_SIZE-1:0] <= OutD[LUT_PORT_SIZE-1:0];
	always @(posedge read_clk) begin
		msb_pipe1_A <= msb_pipe0_A;
		msb_pipe1_B <= msb_pipe0_B;
		msb_pipe1_C <= msb_pipe0_C;
		msb_pipe1_D <= msb_pipe0_D;
	end
	always @(posedge read_clk) read_addr_offset_pipe1 <= read_addr_offset_pipe0;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 2	
`ifndef SYM_VN_REV_1
	assign t_c_A[QUAN_SIZE-1:0] = (msb_pipe1_A == 1'b1) ? ~OutA_pipe1[LUT_PORT_SIZE-1:0] : OutA_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_B[QUAN_SIZE-1:0] = (msb_pipe1_B == 1'b1) ? ~OutB_pipe1[LUT_PORT_SIZE-1:0] : OutB_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_C[QUAN_SIZE-1:0] = (msb_pipe1_C == 1'b1) ? ~OutC_pipe1[LUT_PORT_SIZE-1:0] : OutC_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_D[QUAN_SIZE-1:0] = (msb_pipe1_D == 1'b1) ? ~OutD_pipe1[LUT_PORT_SIZE-1:0] : OutD_pipe1[LUT_PORT_SIZE-1:0];
`else
	assign t_c_A[QUAN_SIZE-1] = msb_pipe1_A^OutA_pipe1[LUT_PORT_SIZE-1];
	assign t_c_B[QUAN_SIZE-1] = msb_pipe1_B^OutB_pipe1[LUT_PORT_SIZE-1];
	assign t_c_C[QUAN_SIZE-1] = msb_pipe1_C^OutC_pipe1[LUT_PORT_SIZE-1];
	assign t_c_D[QUAN_SIZE-1] = msb_pipe1_D^OutD_pipe1[LUT_PORT_SIZE-1];
	
	generate
		for(i=0;i<LUT_PORT_SIZE-1;i=i+1) begin : v2c_lookahead_rotate_inst
			assign t_c_A[i] = OutA_pipe1[i];//((OutA_pipe1[i]^OutA_pipe1[LUT_PORT_SIZE-1])^msb_pipe1_A);
			assign t_c_B[i] = OutB_pipe1[i];//((OutB_pipe1[i]^OutB_pipe1[LUT_PORT_SIZE-1])^msb_pipe1_B);
			assign t_c_C[i] = OutC_pipe1[i];//((OutC_pipe1[i]^OutC_pipe1[LUT_PORT_SIZE-1])^msb_pipe1_C);
			assign t_c_D[i] = OutD_pipe1[i];//((OutD_pipe1[i]^OutD_pipe1[LUT_PORT_SIZE-1])^msb_pipe1_D);
		end
	endgenerate
`endif
	assign t_c_dinA[QUAN_SIZE-1:0] = OutA_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_dinB[QUAN_SIZE-1:0] = OutB_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_dinC[QUAN_SIZE-1:0] = OutC_pipe1[LUT_PORT_SIZE-1:0];
	assign t_c_dinD[QUAN_SIZE-1:0] = OutD_pipe1[LUT_PORT_SIZE-1:0];
	
	assign transpose_en_outA = msb_pipe1_A; // for the decision node in the next stage
	assign transpose_en_outB = msb_pipe1_B; // for the decision node in the next stage
	assign transpose_en_outC = msb_pipe1_C; // for the decision node in the next stage
	assign transpose_en_outD = msb_pipe1_D; // for the decision node in the next stage
	assign read_addr_offset_out = read_addr_offset_pipe1;
endmodule