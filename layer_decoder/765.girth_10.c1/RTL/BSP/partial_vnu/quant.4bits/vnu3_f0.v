`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: vnu3_f0
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
`include "define.vh"
module vnu3_f0 #(
	parameter QUAN_SIZE  = 4,
	parameter PIPELINE_DEPTH = 3,
	parameter ENTRY_ADDR = 7, // regardless of bank interleaving here
	parameter MULTI_FRAME_NUM = 2,
	parameter BANK_NUM   = 2,
	parameter LUT_PORT_SIZE = 4
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
    // For the first VNU
    output wire [QUAN_SIZE-1:0] vnu0_tPort0, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu0_c2v1,
	output wire [QUAN_SIZE-1:0] vnu0_c2v2,
`ifdef V2C_C2V_PROBE
	output wire [QUAN_SIZE-1:0] vnu0_c2v0,
	output wire [QUAN_SIZE-1:0] vnu0_ch_llr_probe,
`endif	
    // For the second VNU       
    output wire [QUAN_SIZE-1:0] vnu1_tPort0, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu1_c2v1,
	output wire [QUAN_SIZE-1:0] vnu1_c2v2,
	
	output wire vnu0_tranEn_out0,
	output wire vnu1_tranEn_out0,
	
    // From the first VNU
    input wire [QUAN_SIZE-1:0] vnu0_c2v_0,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_2,
    input wire [QUAN_SIZE-1:0] vnu0_ch_llr,

    // From the second VNU
    input wire [QUAN_SIZE-1:0] vnu1_c2v_0,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_2,
    input wire [QUAN_SIZE-1:0] vnu1_ch_llr,
	
	input wire read_clk,
	input wire read_addr_offset, // offset determing the switch between multi-frame,
	input wire rstn,
	
    // Iteration-Update Page Address 
    input wire [ENTRY_ADDR-1:0] page_addr_ram,
    // Ieration-Update Data
    input wire [LUT_PORT_SIZE*BANK_NUM-1:0] ram_write_data_0,

    input wire write_clk,
    input wire ib_ram_we
);

/*-------------Pipeline Register 1 to IB-VNU RAM 0--------------------*/
wire [QUAN_SIZE-1:0] vnu0_f0_y0;
wire [QUAN_SIZE-1:0] vnu0_f0_y1;
ib_vnu3_f0_route vnu0_f0_in_pipe(
    .f00_y0 (vnu0_f0_y0),
    .f00_y1 (vnu0_f0_y1),

    .E0 (vnu0_c2v_0[QUAN_SIZE-1:0]),
    /*No need as input source of any 2-LUT.F0*///.E1 (vnu0_c2v_1[QUAN_SIZE-1:0]),
    /*No need as input source of any 2-LUT.F0*///.E2 (vnu0_c2v_2[QUAN_SIZE-1:0]),
    .ch_llr (vnu0_ch_llr[QUAN_SIZE-1:0]) // priori LLR from the underlying channel
);
wire [QUAN_SIZE-1:0] vnu1_f0_y0;
wire [QUAN_SIZE-1:0] vnu1_f0_y1;
ib_vnu3_f0_route vnu1_f0_in_pipe(
    .f00_y0 (vnu1_f0_y0),
    .f00_y1 (vnu1_f0_y1),

    .E0 (vnu1_c2v_0[QUAN_SIZE-1:0]),
    /*No need as input source of any 2-LUT.F0*///.E1 (vnu1_c2v_1[QUAN_SIZE-1:0]),
    /*No need as input source of any 2-LUT.F0*///.E2 (vnu1_c2v_2[QUAN_SIZE-1:0]),
    .ch_llr (vnu1_ch_llr[QUAN_SIZE-1:0]) // priori LLR from the underlying channel
);
//================================================================================//
// Pipeline Mechanism for V2C messages where it will be used in VNU3.f1 
ib_f0_c2v_pipeline #(
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu0_c2v_pipe (
	.E1_reg (vnu0_c2v1[QUAN_SIZE-1:0]),
	.E2_reg (vnu0_c2v2[QUAN_SIZE-1:0]),
	
`ifdef V2C_C2V_PROBE
	.E0_reg (vnu0_c2v0[QUAN_SIZE-1:0]),
	.ch_llr_reg (vnu0_ch_llr_probe[QUAN_SIZE-1:0]),
	
	.c2v0_in (vnu0_c2v_0[QUAN_SIZE-1:0]),
	.ch_llr_in (vnu0_ch_llr[QUAN_SIZE-1:0]),
`endif	
	.c2v1_in  (vnu0_c2v_1[QUAN_SIZE-1:0]),
	.c2v2_in  (vnu0_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk),
	.rstn (rstn)
);
ib_f0_c2v_pipeline #(
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu1_c2v_pipe (
	.E1_reg (vnu1_c2v1[QUAN_SIZE-1:0]),
	.E2_reg (vnu1_c2v2[QUAN_SIZE-1:0]),
	
	.c2v1_in  (vnu1_c2v_1[QUAN_SIZE-1:0]),
	.c2v2_in  (vnu1_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk),
	.rstn (rstn)
);
//================================================================================//
// vnu0 pipe and vnu1 pipe share the first IB-VNU RAM
sym_vn_lut_in func_ram_00(
    .t_c_A (vnu0_tPort0[QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu1_tPort0[QUAN_SIZE-1:0]), // For second reader (B) 
	.read_addr_offset_out (read_addr_offset_out),
	.transpose_en_outA (vnu0_tranEn_out0),	
	.transpose_en_outB (vnu1_tranEn_out0),	
	
	// For read operation	
	.y0_in_A (vnu0_f0_y0), // page address across 64 pages
    .y0_in_B (vnu1_f0_y0), // page address across 64 pages
    .y1_in_A (vnu0_f0_y1),  // bank address across 2 banks
    .y1_in_B (vnu1_f0_y1),  // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_0[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-MULTI_FRAME_NUM:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule