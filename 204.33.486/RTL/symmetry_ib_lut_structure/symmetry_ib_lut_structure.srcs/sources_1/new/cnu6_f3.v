module cnu6_f3 #(
	parameter QUAN_SIZE = 4,
	parameter CN_DEGREE = 6
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath
    // For the first CNU
    output wire [QUAN_SIZE-1:0] cnu0_c2v_0, 
    output wire [QUAN_SIZE-1:0] cnu0_c2v_1, 
    output wire [QUAN_SIZE-1:0] cnu0_c2v_2, 
    output wire [QUAN_SIZE-1:0] cnu0_c2v_3,
    output wire [QUAN_SIZE-1:0] cnu0_c2v_4,
    output wire [QUAN_SIZE-1:0] cnu0_c2v_5, 
    // For the second CNU
    output wire [QUAN_SIZE-1:0] cnu1_c2v_0, 
    output wire [QUAN_SIZE-1:0] cnu1_c2v_1, 
    output wire [QUAN_SIZE-1:0] cnu1_c2v_2, 
    output wire [QUAN_SIZE-1:0] cnu1_c2v_3,
    output wire [QUAN_SIZE-1:0] cnu1_c2v_4,
    output wire [QUAN_SIZE-1:0] cnu1_c2v_5, 
    
    // From the first CNU
    input wire [QUAN_SIZE-1:0] cnu0_t_20,
    input wire [QUAN_SIZE-1:0] cnu0_t_21,
    input wire [QUAN_SIZE-1:0] cnu0_t_22,
    input wire [QUAN_SIZE-1:0] cnu0_t_23,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_1,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_2,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_4,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_5,
    // From the second CNU
    input wire [QUAN_SIZE-1:0] cnu1_t_20,
    input wire [QUAN_SIZE-1:0] cnu1_t_21,
    input wire [QUAN_SIZE-1:0] cnu1_t_22,
    input wire [QUAN_SIZE-1:0] cnu1_t_23,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_1,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_2,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_4,
    input wire [QUAN_SIZE-1:0] cnu1_v2c_5,
        
	input wire read_clk,
	input wire read_addr_offset, // offset determing the switch between multi-frame under the following sub-datapath
	
    // Iteration-Update Page Address 
    input wire [5:0] page_addr_ram,
    // Ieration-Update Data
    input wire [5:0] ram_write_data_3,

    input wire write_clk,
    input wire ib_ram_we
);
/*-------------Pipeline Register 3 to IB-CNU RAM 3--------------------*/
wire [QUAN_SIZE-1:0] cnu0_f3_y0 [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] cnu0_f3_y1 [0:CN_DEGREE-1];
ib_cnu6_f3_route cnu0_f3_in_pipe(
    .f30_y0 (cnu0_f3_y0[0]),
    .f30_y1 (cnu0_f3_y1[0]),
    .f31_y0 (cnu0_f3_y0[1]),
    .f31_y1 (cnu0_f3_y1[1]),
    .f32_y0 (cnu0_f3_y0[2]),
    .f32_y1 (cnu0_f3_y1[2]),
    .f33_y0 (cnu0_f3_y0[3]),
    .f33_y1 (cnu0_f3_y1[3]),
    .f34_y0 (cnu0_f3_y0[4]),
    .f34_y1 (cnu0_f3_y1[4]),
    .f35_y0 (cnu0_f3_y0[5]),
    .f35_y1 (cnu0_f3_y1[5]),
        
    .t_20 (cnu0_t_20[QUAN_SIZE-1:0]),
    .t_21 (cnu0_t_21[QUAN_SIZE-1:0]),
    .t_22 (cnu0_t_22[QUAN_SIZE-1:0]),
    .t_23 (cnu0_t_23[QUAN_SIZE-1:0]),
    .M1(cnu0_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu0_v2c_2[QUAN_SIZE-1:0]),
    .M4(cnu0_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu0_v2c_5[QUAN_SIZE-1:0])
);

wire [QUAN_SIZE-1:0] cnu1_f3_y0 [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] cnu1_f3_y1 [0:CN_DEGREE-1];
ib_cnu6_f3_route cnu1_f3_in_pipe(
    .f30_y0 (cnu1_f3_y0[0]),
    .f30_y1 (cnu1_f3_y1[0]),
    .f31_y0 (cnu1_f3_y0[1]),
    .f31_y1 (cnu1_f3_y1[1]),
    .f32_y0 (cnu1_f3_y0[2]),
    .f32_y1 (cnu1_f3_y1[2]),
    .f33_y0 (cnu1_f3_y0[3]),
    .f33_y1 (cnu1_f3_y1[3]),
    .f34_y0 (cnu1_f3_y0[4]),
    .f34_y1 (cnu1_f3_y1[4]),
    .f35_y0 (cnu1_f3_y0[5]),
    .f35_y1 (cnu1_f3_y1[5]),
        
    .t_20 (cnu1_t_20[QUAN_SIZE-1:0]),
    .t_21 (cnu1_t_21[QUAN_SIZE-1:0]),
    .t_22 (cnu1_t_22[QUAN_SIZE-1:0]),
    .t_23 (cnu1_t_23[QUAN_SIZE-1:0]),
    .M1(cnu1_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu1_v2c_2[QUAN_SIZE-1:0]),
    .M4(cnu1_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu1_v2c_5[QUAN_SIZE-1:0])
);

sym_cn_lut_out func_ram_30(
	// For read operation
	.t_c_A (cnu0_c2v_0[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (cnu0_c2v_1[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (cnu0_c2v_2[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (cnu0_c2v_3[QUAN_SIZE-1:0]), // For fourth reader (D)	
	.read_addr_offset_out (read_addr_offset_out),

    .y0_in_A (cnu0_f3_y0[0]),// page address across 32 pages
    .y0_in_B (cnu0_f3_y0[1]),// page address across 32 pages
    .y0_in_C (cnu0_f3_y0[2]),// page address across 32 pages
    .y0_in_D (cnu0_f3_y0[3]),// page address across 32 pages
    .y1_in_A (cnu0_f3_y1[0]), // bank address across 2 banks
    .y1_in_B (cnu0_f3_y1[1]), // bank address across 2 banks
    .y1_in_C (cnu0_f3_y1[2]), // bank address across 2 banks
    .y1_in_D (cnu0_f3_y1[3]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_3[5:3]), // input data
	.lut_in_bank1 (ram_write_data_3[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);

sym_cn_lut_out func_ram_31(
	// For read operation
	.t_c_A (cnu0_c2v_4[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (cnu0_c2v_5[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (cnu1_c2v_0[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (cnu1_c2v_1[QUAN_SIZE-1:0]), // For fourth reader (D)	
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_30 is enought

    .y0_in_A (cnu0_f3_y0[4]),// page address across 32 pages
    .y0_in_B (cnu0_f3_y0[5]),// page address across 32 pages
    .y0_in_C (cnu1_f3_y0[0]),// page address across 32 pages
    .y0_in_D (cnu1_f3_y0[1]),// page address across 32 pages
    .y1_in_A (cnu0_f3_y1[4]), // bank address across 2 banks
    .y1_in_B (cnu0_f3_y1[5]), // bank address across 2 banks
    .y1_in_C (cnu1_f3_y1[0]), // bank address across 2 banks
    .y1_in_D (cnu1_f3_y1[1]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_3[5:3]), // input data
	.lut_in_bank1 (ram_write_data_3[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);

sym_cn_lut_out func_ram_32(
	// For read operation
	.t_c_A (cnu1_c2v_2[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (cnu1_c2v_3[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (cnu1_c2v_4[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (cnu1_c2v_5[QUAN_SIZE-1:0]), // For fourth reader (D)	
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_30 is enought

    .y0_in_A (cnu1_f3_y0[2]),// page address across 32 pages
    .y0_in_B (cnu1_f3_y0[3]),// page address across 32 pages
    .y0_in_C (cnu1_f3_y0[4]),// page address across 32 pages
    .y0_in_D (cnu1_f3_y0[5]),// page address across 32 pages
    .y1_in_A (cnu1_f3_y1[2]), // bank address across 2 banks
    .y1_in_B (cnu1_f3_y1[3]), // bank address across 2 banks
    .y1_in_C (cnu1_f3_y1[4]), // bank address across 2 banks
    .y1_in_D (cnu1_f3_y1[5]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_3[5:3]), // input data
	.lut_in_bank1 (ram_write_data_3[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule