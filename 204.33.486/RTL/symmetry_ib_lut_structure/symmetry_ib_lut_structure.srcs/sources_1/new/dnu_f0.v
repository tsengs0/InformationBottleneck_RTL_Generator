module dnu_f0 #(
	parameter ENTRY_ADDR = 7, // regardless of bank interleaving here
	parameter BANK_NUM   = 2,
	parameter LUT_PORT_SIZE = 1
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
    // For the first DNU
    output wire dnu0_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
    // For the second DNU       
    output wire dnu1_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
    // For the third DNU        
    output wire dnu2_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
	// For the fourth DNU       
    output wire dnu3_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
	
    // From the first DNU
    input wire [QUAN_SIZE-1:0] vnu0_t10,
    input wire [QUAN_SIZE-1:0] vnu0_c2v_2,
	input wire vnu0_tranEn_in0,

    // From the second DNU
    input wire [QUAN_SIZE-1:0] vnu1_t10,
    input wire [QUAN_SIZE-1:0] vnu1_c2v_2,
	input wire vnu1_tranEn_in0,
	
    // From the third DNU
    input wire [QUAN_SIZE-1:0] vnu2_t10,
    input wire [QUAN_SIZE-1:0] vnu2_c2v_2,
	input wire vnu2_tranEn_in0,
	
    // From the fourth DNU
    input wire [QUAN_SIZE-1:0] vnu3_t10,
    input wire [QUAN_SIZE-1:0] vnu3_c2v_2,
	input wire vnu3_tranEn_in0,
	
	input wire read_clk,
	input wire read_addr_offset, // offset determing the switch between multi-frame
	
    // Iteration-Update Page Address 
    input wire [ENTRY_ADDR-1:0] page_addr_ram,
    // Ieration-Update Data
    input wire [LUT_PORT_SIZE*BANK_NUM-1:0] ram_write_data_1,

    input wire write_clk,
    input wire ib_ram_we
);
/*-------------Pipeline Register 0 to IB-DNU RAM 0--------------------*/
wire [QUAN_SIZE-1:0] dnu0_f0_y0;
wire [QUAN_SIZE-1:0] dnu0_f0_y1;
ib_dnu_f0_route dnu0_f1_in_pipe(
    .f0_y0 (dnu0_f0_y0),
    .f0_y1 (dnu0_f0_y1),

    .t_00 (vnu0_t10),
    .E2   (vnu0_c2v_2)            
);
wire [QUAN_SIZE-1:0] dnu1_f0_y0;
wire [QUAN_SIZE-1:0] dnu1_f0_y1;
ib_dnu_f0_route dnu1_f1_in_pipe(
    .f0_y0 (dnu1_f0_y0),
    .f0_y1 (dnu1_f0_y1),

    .t_00 (vnu1_t10),
    .E2   (vnu1_c2v_2)            
);
wire [QUAN_SIZE-1:0] dnu2_f0_y0;
wire [QUAN_SIZE-1:0] dnu2_f0_y1;
ib_dnu_f0_route dnu2_f1_in_pipe(
    .f0_y0 (dnu2_f0_y0),
    .f0_y1 (dnu2_f0_y1),

    .t_00 (vnu2_t10),
    .E2   (vnu2_c2v_2)            
);
wire [QUAN_SIZE-1:0] dnu3_f0_y0;
wire [QUAN_SIZE-1:0] dnu3_f0_y1;
ib_dnu_f0_route dnu3_f1_in_pipe(
    .f0_y0 (dnu3_f0_y0),
    .f0_y1 (dnu3_f0_y1),

    .t_00 (vnu3_t10),
    .E2   (vnu3_c2v_2)            
);
/*-------------IB-DNU RAM 0--------------------*/
sym_dn_lut_out func_ram_10(
    .t_c_A (dnu0_hard_decision), // For first reader  (A)    
    .t_c_B (dnu1_hard_decision), // For second reader (B) 
    .t_c_C (dnu2_hard_decision), // For third reader  (C)  
    .t_c_D (dnu3_hard_decision), // For fourth reader (D)
	.read_addr_offset_out (read_addr_offset_out),
	
	.transpose_en_inA (vnu0_tranEn_in0),
	.transpose_en_inB (vnu1_tranEn_in0),
	.transpose_en_inC (vnu2_tranEn_in0),
	.transpose_en_inD (vnu3_tranEn_in0),

	.y0_in_A (dnu0_f0_y0),
	.y0_in_B (dnu1_f0_y0),
	.y0_in_C (dnu2_f0_y0),
	.y0_in_D (dnu3_f0_y0),
	.y1_in_A (dnu0_f0_y1),
	.y1_in_B (dnu1_f0_y1),
	.y1_in_C (dnu2_f0_y1),
	.y1_in_D (dnu3_f0_y1),

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:LUT_PORT_SIZE]), // input data
	.lut_in_bank1 (ram_write_data_1[LUT_PORT_SIZE-1:0]), // input data 
	.page_write_addr (page_addr_ram[ENTRY_ADDR-2:0]), // write address
	.write_addr_offset ((page_addr_ram[ENTRY_ADDR-1])), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule