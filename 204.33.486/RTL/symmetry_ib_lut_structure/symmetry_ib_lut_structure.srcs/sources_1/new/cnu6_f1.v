`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: cnu6_f1
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
module cnu6_f1 #(
	parameter QUAN_SIZE = 4,
	parameter PIPELINE_DEPTH = 3
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath
    // For the first CNU
    output wire [QUAN_SIZE-1:0] t_portA, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] t_portB, // internal signals accounting for each 256-entry partial LUT's output
    // For the second CNU
    output wire [QUAN_SIZE-1:0] t_portC, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] t_portD, // internal signals accounting for each 256-entry partial LUT's output
    // For the first CNU
    output wire [QUAN_SIZE-1:0] cnu0_M_reg0,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg1,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg2,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg3,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg4,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg5,
    // For the second CNU
    output wire [QUAN_SIZE-1:0] cnu1_M_reg0,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg1,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg2,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg3,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg4,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg5,

    // From the first CNU
    input wire [QUAN_SIZE-1:0] t_00,
    input wire [QUAN_SIZE-1:0] t_01,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_0,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_1,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_2,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_3,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_4,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_5,
    // From the second CNU
    input wire [QUAN_SIZE-1:0] t_02,
    input wire [QUAN_SIZE-1:0] t_03,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_0,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_1,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_2,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_3,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_4,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_5,
     
	input wire read_clk,
	input wire read_addr_offset, // offset determing the switch between multi-frame under the following sub-datapath
	
    // Iteration-Update Page Address 
    input wire [5:0] page_addr_ram,
    // Ieration-Update Data
    input wire [5:0] ram_write_data_1,

    input wire write_clk,
    input wire ib_ram_we
);

/*-------------Pipeline Register 1 to IB-CNU RAM 1--------------------*/
wire [QUAN_SIZE:0] cnu0_f1_y0 [0:1];
wire [QUAN_SIZE:0] cnu0_f1_y1 [0:1];
ib_cnu6_f1_route cnu0_f1_in_pipe(
    .f10_y0 (cnu0_f1_y0[0]),
    .f10_y1 (cnu0_f1_y1[0]),
    .f11_y0 (cnu0_f1_y0[1]),
    .f11_y1 (cnu0_f1_y1[1]),

    .t_00 (t_00[QUAN_SIZE-1:0]),
    .t_01 (t_01[QUAN_SIZE-1:0]),   
    .M0(cnu0_v2c_0[QUAN_SIZE-1:0]),
    .M1(cnu0_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu0_v2c_2[QUAN_SIZE-1:0]),
    .M3(cnu0_v2c_3[QUAN_SIZE-1:0]),
    .M4(cnu0_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu0_v2c_5[QUAN_SIZE-1:0])
);

wire [QUAN_SIZE-1:0] cnu1_f1_y0 [0:1];
wire [QUAN_SIZE-1:0] cnu1_f1_y1 [0:1];
ib_cnu6_f1_route cnu1_f1_in_pipe(
    .f10_y0 (cnu1_f1_y0[0]),
    .f10_y1 (cnu1_f1_y1[0]),
    .f11_y0 (cnu1_f1_y0[1]),
    .f11_y1 (cnu1_f1_y1[1]),

    .t_00 (t_02[QUAN_SIZE-1:0]),
    .t_01 (t_03[QUAN_SIZE-1:0]),       
    .M0(cnu1_v2c_0[QUAN_SIZE-1:0]),
    .M1(cnu1_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu1_v2c_2[QUAN_SIZE-1:0]),
    .M3(cnu1_v2c_3[QUAN_SIZE-1:0]),
    .M4(cnu1_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu1_v2c_5[QUAN_SIZE-1:0])
);
//================================================================================//
// Pipeline Mechanism for V2C messages where it will be used in CNU6.f2 
ib_f1_v2c_pipeline #(
	.PIPELINE_DEPTH(PIPELINE_DEPTH)
) cnu0_v2c_pipe(
	.M0_reg (cnu0_M_reg0[QUAN_SIZE-1:0]),
	.M1_reg (cnu0_M_reg1[QUAN_SIZE-1:0]),
	.M2_reg (cnu0_M_reg2[QUAN_SIZE-1:0]),
	.M3_reg (cnu0_M_reg3[QUAN_SIZE-1:0]),
	.M4_reg (cnu0_M_reg4[QUAN_SIZE-1:0]),
	.M5_reg (cnu0_M_reg5[QUAN_SIZE-1:0]),
	
	.v2c0_in (cnu0_v2c_0[QUAN_SIZE-1:0]),
	.v2c1_in (cnu0_v2c_1[QUAN_SIZE-1:0]),
	.v2c2_in (cnu0_v2c_2[QUAN_SIZE-1:0]),
	.v2c3_in (cnu0_v2c_3[QUAN_SIZE-1:0]),
	.v2c4_in (cnu0_v2c_4[QUAN_SIZE-1:0]),
	.v2c5_in (cnu0_v2c_5[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
ib_f1_v2c_pipeline #(
	.PIPELINE_DEPTH(PIPELINE_DEPTH)
) cnu1_v2c_pipe(
	.M0_reg (cnu1_M_reg0[QUAN_SIZE-1:0]),
	.M1_reg (cnu1_M_reg1[QUAN_SIZE-1:0]),
	.M2_reg (cnu1_M_reg2[QUAN_SIZE-1:0]),
	.M3_reg (cnu1_M_reg3[QUAN_SIZE-1:0]),
	.M4_reg (cnu1_M_reg4[QUAN_SIZE-1:0]),
	.M5_reg (cnu1_M_reg5[QUAN_SIZE-1:0]),
	
	.v2c0_in (cnu1_v2c_0[QUAN_SIZE-1:0]),
	.v2c1_in (cnu1_v2c_1[QUAN_SIZE-1:0]),
	.v2c2_in (cnu1_v2c_2[QUAN_SIZE-1:0]),
	.v2c3_in (cnu1_v2c_3[QUAN_SIZE-1:0]),
	.v2c4_in (cnu1_v2c_4[QUAN_SIZE-1:0]),
	.v2c5_in (cnu1_v2c_5[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
//================================================================================//
sym_cn_lut_internal func_ram_1(
	// For read operation
	.t_c_A (t_portA[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (t_portB[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (t_portC[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (t_portD[QUAN_SIZE-1:0]), // For fourth reader (D)	
	.read_addr_offset_out (read_addr_offset_out),

    .y0_in_A (cnu0_f1_y0[0]),// page address across 32 pages
    .y0_in_B (cnu0_f1_y0[1]),// page address across 32 pages
    .y0_in_C (cnu1_f1_y0[0]),// page address across 32 pages
    .y0_in_D (cnu1_f1_y0[1]),// page address across 32 pages
    .y1_in_A (cnu0_f1_y1[0]), // bank address across 2 banks
    .y1_in_B (cnu0_f1_y1[1]), // bank address across 2 banks
    .y1_in_C (cnu1_f1_y1[0]), // bank address across 2 banks
    .y1_in_D (cnu1_f1_y1[1]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_1[5:3]), // input data
	.lut_in_bank1 (ram_write_data_1[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule