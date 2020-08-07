module vnu3_f1 #(
	parameter QUAN_SIZE  = 4,
	parameter ENTRY_ADDR = 7, // regardless of bank interleaving here
	parameter BANK_NUM   = 2,
	parameter LUT_PORT_SIZE = 4
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
    // For the first VNU
    output wire [QUAN_SIZE-1:0] vnu0_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu0_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu0_v2c2, // internal signals accounting for each 128-entry partial LUT's output
    // For the second VNU       
    output wire [QUAN_SIZE-1:0] vnu1_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu1_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu1_v2c2, // internal signals accounting for each 128-entry partial LUT's output
    // For the third VNU        
    output wire [QUAN_SIZE-1:0] vnu2_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu2_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu2_v2c2, // internal signals accounting for each 128-entry partial LUT's output
	// For the fourth VNU       
    output wire [QUAN_SIZE-1:0] vnu3_v2c0, // internal signals accounting for each 128-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] vnu3_v2c1, // internal signals accounting for each 128-entry partial LUT's output
	output wire [QUAN_SIZE-1:0] vnu3_v2c2, // internal signals accounting for each 128-entry partial LUT's output

	//output wire vnu0_tranEn_out0,
	//output wire vnu0_tranEn_out1,
	//output wire vnu1_tranEn_out0,
	//output wire vnu1_tranEn_out1,
	//output wire vnu2_tranEn_out0,
	//output wire vnu2_tranEn_out1,
	//output wire vnu3_tranEn_out0,
	//output wire vnu3_tranEn_out1,
	
	input wire vnu0_tranEn_in0,
	input wire vnu0_tranEn_in1,
	input wire vnu0_tranEn_in2,
	input wire vnu1_tranEn_in0,
	input wire vnu1_tranEn_in1,
	input wire vnu1_tranEn_in2,
	input wire vnu2_tranEn_in0,
	input wire vnu2_tranEn_in1,
	input wire vnu2_tranEn_in2,
	input wire vnu3_tranEn_in0,
	input wire vnu3_tranEn_in1,
	input wire vnu3_tranEn_in2,
	
    // From the first VNU
    input wire [QUAN_SIZE-1:0] vnu0_t00,
    input wire [QUAN_SIZE-1:0] vnu0_t01,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_2,

    // From the second VNU
    input wire [QUAN_SIZE-1:0] vnu1_t00,
    input wire [QUAN_SIZE-1:0] vnu1_t01,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_2,            
   
    // From the third VNU
    input wire [QUAN_SIZE-1:0] vnu2_t00,
    input wire [QUAN_SIZE-1:0] vnu2_t01,
    input wire [QUAN_SIZE-1:0] vnu2_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu2_c2v_2,

    // From the fourth VNU
    input wire [QUAN_SIZE-1:0] vnu3_t00,
    input wire [QUAN_SIZE-1:0] vnu3_t01,
    input wire [QUAN_SIZE-1:0] vnu3_c2v_1,
    input wire [QUAN_SIZE-1:0] vnu3_c2v_2,
	
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
ib_vnu3_f1_route vnu0_f1_in_pipe(
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
ib_vnu3_f1_route vnu1_f1_in_pipe(
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
ib_vnu3_f1_route vnu2_f1_in_pipe(
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
ib_vnu3_f1_route vnu3_f1_in_pipe(
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

/*-------------IB-VNU RAM 0--------------------*/
sym_vn_lut_out func_ram_10(
    .t_c_A (vnu0_v2c2[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu0_v2c1[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu0_v2c0[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu1_v2c2[`QUAN_SIZE-1:0]), // For fourth reader (D)
	.read_addr_offset_out (read_addr_offset_out),
	
	.transpose_en_inA (vnu0_tranEn_in0),
	.transpose_en_inB (vnu0_tranEn_in1),
	.transpose_en_inC (vnu0_tranEn_in2),
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
	.lut_in_bank0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_0[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-2:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
/*-------------IB-VNU RAM 1--------------------*/
sym_vn_lut_out func_ram_11(
    .t_c_A (vnu1_v2c1[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu1_v2c0[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu2_v2c2[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu2_v2c1[`QUAN_SIZE-1:0]), // For fourth reader (D)
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_10 is enough
	
	.transpose_en_inA (vnu1_tranEn_in1),
	.transpose_en_inB (vnu1_tranEn_in2),
	.transpose_en_inC (vnu2_tranEn_in0),
	.transpose_en_inD (vnu2_tranEn_in1),

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
	.lut_in_bank0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_0[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-2:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
/*-------------IB-VNU RAM 2--------------------*/
sym_vn_lut_out func_ram_12(
    .t_c_A (vnu2_v2c0[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (vnu3_v2c2[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (vnu3_v2c1[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (vnu3_v2c0[`QUAN_SIZE-1:0]), // For fourth reader (D)
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_10 is enough
	
	.transpose_en_inA (vnu2_tranEn_in2),
	.transpose_en_inB (vnu3_tranEn_in0),
	.transpose_en_inC (vnu3_tranEn_in1),
	.transpose_en_inD (vnu3_tranEn_in2),

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
	.lut_in_bank0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_0[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-2:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule