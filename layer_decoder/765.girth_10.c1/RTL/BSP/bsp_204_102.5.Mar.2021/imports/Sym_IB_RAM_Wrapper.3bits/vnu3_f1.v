`include "define.vh"
module vnu3_f1 #(
	parameter QUAN_SIZE  = 3,
	parameter PIPELINE_DEPTH = 3,
	parameter ENTRY_ADDR = 5, // regardless of bank interleaving here
	parameter BANK_NUM   = 2,
	parameter MULTI_FRAME_NUM = 2,
	parameter LUT_PORT_SIZE = 3
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
    // For the first VNU
    output wire [QUAN_SIZE-1:0] vnu0_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu0_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu0_v2c2, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu0_dn_in, // the input source to decision node in the next step
	output wire [QUAN_SIZE-1:0] vnu0_E_reg2,
`ifdef V2C_C2V_PROBE
	output wire [QUAN_SIZE-1:0] vnu0_E_reg0,
	output wire [QUAN_SIZE-1:0] vnu0_E_reg1,
	output wire [QUAN_SIZE-1:0] vnu0_ch_llr_probe,
`endif		
	
    // For the second VNU       
    output wire [QUAN_SIZE-1:0] vnu1_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu1_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu1_v2c2, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu1_E_reg2,
	output wire [QUAN_SIZE-1:0] vnu1_dn_in, // the input source to decision node in the next step
    // For the third VNU        
    output wire [QUAN_SIZE-1:0] vnu2_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu2_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu2_v2c2, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu2_E_reg2,
	output wire [QUAN_SIZE-1:0] vnu2_dn_in, // the input source to decision node in the next step
	// For the fourth VNU       
    output wire [QUAN_SIZE-1:0] vnu3_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu3_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu3_v2c2, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu3_E_reg2,
	output wire [QUAN_SIZE-1:0] vnu3_dn_in, // the input source to decision node in the next step

	output wire vnu0_tranEn_out0, // for the decision node in the next stage
	output wire vnu1_tranEn_out0, // for the decision node in the next stage
	output wire vnu2_tranEn_out0, // for the decision node in the next stage
	output wire vnu3_tranEn_out0, // for the decision node in the next stage
	
    // From the first VNU
    input wire [QUAN_SIZE-1:0] vnu0_t00,
    input wire [QUAN_SIZE-1:0] vnu0_t01,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_2,
`ifdef V2C_C2V_PROBE
	input wire [QUAN_SIZE-1:0] vnu0_c2v_0,
	input wire [QUAN_SIZE-1:0] vnu0_ch_llr,
`endif
	input wire vnu0_tranEn_in0,
	input wire vnu0_tranEn_in1,

    // From the second VNU
    input wire [QUAN_SIZE-1:0] vnu1_t00,
    input wire [QUAN_SIZE-1:0] vnu1_t01,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_2, 
	input wire vnu1_tranEn_in0,
	input wire vnu1_tranEn_in1,	
   
    // From the third VNU
    input wire [QUAN_SIZE-1:0] vnu2_t00,
    input wire [QUAN_SIZE-1:0] vnu2_t01,
    input wire [QUAN_SIZE-1:0] vnu2_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu2_c2v_2,
	input wire vnu2_tranEn_in0,
	input wire vnu2_tranEn_in1,

    // From the fourth VNU
    input wire [QUAN_SIZE-1:0] vnu3_t00,
    input wire [QUAN_SIZE-1:0] vnu3_t01,
    input wire [QUAN_SIZE-1:0] vnu3_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu3_c2v_2,
	input wire vnu3_tranEn_in0,
	input wire vnu3_tranEn_in1,
	
	input wire read_clk,
	input wire read_addr_offset, // offset determing the switch between multi-frame
	
    // Iteration-Update Page Address 
    input wire [ENTRY_ADDR-1:0] page_addr_ram,
    // Ieration-Update Data
    input wire [LUT_PORT_SIZE*BANK_NUM-1:0] ram_write_data_1,

    input wire write_clk,
    input wire ib_ram_we
);
/*-------------Pipeline Register 0 to IB-VNU RAM 0--------------------*/
wire [QUAN_SIZE-1:0] vnu0_f1_y0 [0:2];
wire [QUAN_SIZE-1:0] vnu0_f1_y1 [0:2];
ib_vnu3_f1_route #(.QUAN_SIZE(QUAN_SIZE)) vnu0_f1_in_pipe(
    .f10_y0 (vnu0_f1_y0[0]),
    .f10_y1 (vnu0_f1_y1[0]),
    .f11_y0 (vnu0_f1_y0[1]),
    .f11_y1 (vnu0_f1_y1[1]),
    .f12_y0 (vnu0_f1_y0[2]),
    .f12_y1 (vnu0_f1_y1[2]),

    .t_00 (vnu0_t00[QUAN_SIZE-1:0]),
    .t_01 (vnu0_t01[QUAN_SIZE-1:0]),
    .E1   (vnu0_c2v_1[QUAN_SIZE-1:0]),
    .E2   (vnu0_c2v_2[QUAN_SIZE-1:0])           
);
wire [QUAN_SIZE-1:0] vnu1_f1_y0 [0:2];
wire [QUAN_SIZE-1:0] vnu1_f1_y1 [0:2];
ib_vnu3_f1_route #(.QUAN_SIZE(QUAN_SIZE)) vnu1_f1_in_pipe(
    .f10_y0 (vnu1_f1_y0[0]),
    .f10_y1 (vnu1_f1_y1[0]),
    .f11_y0 (vnu1_f1_y0[1]),
    .f11_y1 (vnu1_f1_y1[1]),
    .f12_y0 (vnu1_f1_y0[2]),
    .f12_y1 (vnu1_f1_y1[2]),

    .t_00 (vnu1_t00[QUAN_SIZE-1:0]),
    .t_01 (vnu1_t01[QUAN_SIZE-1:0]),
    .E1   (vnu1_c2v_1[QUAN_SIZE-1:0]),
    .E2   (vnu1_c2v_2[QUAN_SIZE-1:0])           
);
wire [QUAN_SIZE-1:0] vnu2_f1_y0 [0:2];
wire [QUAN_SIZE-1:0] vnu2_f1_y1 [0:2];
ib_vnu3_f1_route #(.QUAN_SIZE(QUAN_SIZE)) vnu2_f1_in_pipe(
    .f10_y0 (vnu2_f1_y0[0]),
    .f10_y1 (vnu2_f1_y1[0]),
    .f11_y0 (vnu2_f1_y0[1]),
    .f11_y1 (vnu2_f1_y1[1]),
    .f12_y0 (vnu2_f1_y0[2]),
    .f12_y1 (vnu2_f1_y1[2]),

    .t_00 (vnu2_t00[QUAN_SIZE-1:0]),
    .t_01 (vnu2_t01[QUAN_SIZE-1:0]),
    .E1   (vnu2_c2v_1[QUAN_SIZE-1:0]),
    .E2   (vnu2_c2v_2[QUAN_SIZE-1:0])           
);
wire [QUAN_SIZE-1:0] vnu3_f1_y0 [0:2];
wire [QUAN_SIZE-1:0] vnu3_f1_y1 [0:2];
ib_vnu3_f1_route #(.QUAN_SIZE(QUAN_SIZE)) vnu3_f1_in_pipe(
    .f10_y0 (vnu3_f1_y0[0]),
    .f10_y1 (vnu3_f1_y1[0]),
    .f11_y0 (vnu3_f1_y0[1]),
    .f11_y1 (vnu3_f1_y1[1]),
    .f12_y0 (vnu3_f1_y0[2]),
    .f12_y1 (vnu3_f1_y1[2]),

    .t_00 (vnu3_t00[QUAN_SIZE-1:0]),
    .t_01 (vnu3_t01[QUAN_SIZE-1:0]),
    .E1   (vnu3_c2v_1[QUAN_SIZE-1:0]),
    .E2   (vnu3_c2v_2[QUAN_SIZE-1:0])           
);

//================================================================================//
// Pipeline Mechanism for V2C messages where it will be used in DNU.f0 
ib_f1_c2v_pipeline #(
	.QUAN_SIZE (QUAN_SIZE),
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu0_c2v_pipe (
	.E2_reg   (vnu0_E_reg2[QUAN_SIZE-1:0]),
`ifdef V2C_C2V_PROBE
	.E0_reg     (vnu0_E_reg0[QUAN_SIZE-1:0]),
	.E1_reg     (vnu0_E_reg1[QUAN_SIZE-1:0]),
	.ch_llr_reg (vnu0_ch_llr_probe[QUAN_SIZE-1:0]),
	
	.c2v0_in   (vnu0_c2v_0[QUAN_SIZE-1:0]),
	.c2v1_in   (vnu0_c2v_1[QUAN_SIZE-1:0]),
	.ch_llr_in (vnu0_ch_llr[QUAN_SIZE-1:0]),
`endif
	.c2v2_in  (vnu0_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
ib_f1_c2v_pipeline #(
	.QUAN_SIZE (QUAN_SIZE),
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu1_c2v_pipe (
	.E2_reg   (vnu1_E_reg2[QUAN_SIZE-1:0]),
	.c2v2_in  (vnu1_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
ib_f1_c2v_pipeline #(
	.QUAN_SIZE (QUAN_SIZE),
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu2_c2v_pipe (
	.E2_reg   (vnu2_E_reg2[QUAN_SIZE-1:0]),
	.c2v2_in  (vnu2_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
ib_f1_c2v_pipeline #(
	.QUAN_SIZE (QUAN_SIZE),
	.PIPELINE_DEPTH (PIPELINE_DEPTH)
) vnu3_c2v_pipe (
	.E2_reg   (vnu3_E_reg2[QUAN_SIZE-1:0]),
	.c2v2_in  (vnu3_c2v_2[QUAN_SIZE-1:0]),
	.read_clk (read_clk)
);
//================================================================================//
/*-------------IB-VNU RAM 0--------------------*/
sym_vn_lut_out #(
	.QUAN_SIZE       (QUAN_SIZE      ),
	.LUT_PORT_SIZE   (LUT_PORT_SIZE  ),
	.ENTRY_ADDR      (ENTRY_ADDR     ),
	.MULTI_FRAME_NUM (MULTI_FRAME_NUM)
) func_ram_10(
    .t_c_A (vnu0_v2c2[QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu0_v2c1[QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu0_v2c0[QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu1_v2c2[QUAN_SIZE-1:0]), // For fourth reader (D)
	.t_c_dinA (vnu0_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinB (), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinC (), // the input source to decision node in the next step (without complement conversion)
	.t_c_dinD (vnu1_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step (without complement conversion)
	.transpose_en_outA (vnu0_tranEn_out0),//(vnu0_tranEn_out0),
	.transpose_en_outB (),//(vnu1_tranEn_out0),
	.transpose_en_outC (),//(vnu2_tranEn_out0),
	.transpose_en_outD (vnu1_tranEn_out0),//(vnu3_tranEn_out0),
	.read_addr_offset_out (read_addr_offset_out),
	
	.transpose_en_inA (vnu0_tranEn_in0),
	.transpose_en_inB (vnu0_tranEn_in0),
	.transpose_en_inC (vnu0_tranEn_in1),
	.transpose_en_inD (vnu1_tranEn_in0),

	.y0_in_A (vnu0_f1_y0[0]),
	.y0_in_B (vnu0_f1_y0[1]),
	.y0_in_C (vnu0_f1_y0[2]),
	.y0_in_D (vnu1_f1_y0[0]),
	.y1_in_A (vnu0_f1_y1[0]),
	.y1_in_B (vnu0_f1_y1[1]),
	.y1_in_C (vnu0_f1_y1[2]),
	.y1_in_D (vnu1_f1_y1[0]),

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_1[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
/*-------------IB-VNU RAM 1--------------------*/
sym_vn_lut_out #(
	.QUAN_SIZE       (QUAN_SIZE      ),
	.LUT_PORT_SIZE   (LUT_PORT_SIZE  ),
	.ENTRY_ADDR      (ENTRY_ADDR     ),
	.MULTI_FRAME_NUM (MULTI_FRAME_NUM)
) func_ram_11(
    .t_c_A (vnu1_v2c1[QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu1_v2c0[QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu2_v2c2[QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu2_v2c1[QUAN_SIZE-1:0]), // For fourth reader (D)
	//.t_c_dinA (), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinB (), // the input source to decision node in the next step (without complement conversion)
	.t_c_dinC (vnu2_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinD (), // the input source to decision node in the next step (without complement conversion)
	.transpose_en_outA (),
	.transpose_en_outB (),
	.transpose_en_outC (vnu2_tranEn_out0),
	.transpose_en_outD (),
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_10 is enough
	
	.transpose_en_inA (vnu1_tranEn_in0),
	.transpose_en_inB (vnu1_tranEn_in1),
	.transpose_en_inC (vnu2_tranEn_in0),
	.transpose_en_inD (vnu2_tranEn_in0),

	.y0_in_A (vnu1_f1_y0[1]),
	.y0_in_B (vnu1_f1_y0[2]),
	.y0_in_C (vnu2_f1_y0[0]),
	.y0_in_D (vnu2_f1_y0[1]),
	.y1_in_A (vnu1_f1_y1[1]),
	.y1_in_B (vnu1_f1_y1[2]),
	.y1_in_C (vnu2_f1_y1[0]),
	.y1_in_D (vnu2_f1_y1[1]),

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_1[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
/*-------------IB-VNU RAM 2--------------------*/
sym_vn_lut_out #(
	.QUAN_SIZE       (QUAN_SIZE      ),
	.LUT_PORT_SIZE   (LUT_PORT_SIZE  ),
	.ENTRY_ADDR      (ENTRY_ADDR     ),
	.MULTI_FRAME_NUM (MULTI_FRAME_NUM)
) func_ram_12(
    .t_c_A (vnu2_v2c0[QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu3_v2c2[QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu3_v2c1[QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu3_v2c0[QUAN_SIZE-1:0]), // For fourth reader (D)
	//.t_c_dinA (), // the input source to decision node in the next step (without complement conversion)
	.t_c_dinB (vnu3_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinC (), // the input source to decision node in the next step (without complement conversion)
	//.t_c_dinD (), // the input source to decision node in the next step (without complement conversion)
	.transpose_en_outA (),
	.transpose_en_outB (vnu3_tranEn_out0),
	.transpose_en_outC (),
	.transpose_en_outD (),
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_10 is enough
		
	.transpose_en_inA (vnu2_tranEn_in1),
	.transpose_en_inB (vnu3_tranEn_in0),
	.transpose_en_inC (vnu3_tranEn_in0),
	.transpose_en_inD (vnu3_tranEn_in1),

	.y0_in_A (vnu2_f1_y0[2]),
	.y0_in_B (vnu3_f1_y0[0]),
	.y0_in_C (vnu3_f1_y0[1]),
	.y0_in_D (vnu3_f1_y0[2]),
	.y1_in_A (vnu2_f1_y1[2]),
	.y1_in_B (vnu3_f1_y1[0]),
	.y1_in_C (vnu3_f1_y1[1]),
	.y1_in_D (vnu3_f1_y1[2]),

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_1[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule