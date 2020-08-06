module cnu6_f2 #(
	parameter QUAN_SIZE = 4
)(
	output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath
    // For the first CNU
    output wire [QUAN_SIZE-1:0] cnu0_t_portA, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu0_t_portB, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu0_t_portC, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu0_t_portD, // internal signals accounting for each 256-entry partial LUT's output
    // For the second CNU
    output wire [QUAN_SIZE-1:0] cnu1_t_portA, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu1_t_portB, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu1_t_portC, // internal signals accounting for each 256-entry partial LUT's output
    output wire [QUAN_SIZE-1:0] cnu1_t_portD, // internal signals accounting for each 256-entry partial LUT's output
    // For the first CNU
    output wire [QUAN_SIZE-1:0] cnu0_M_reg1,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg2,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg4,
    output wire [QUAN_SIZE-1:0] cnu0_M_reg5,
    // For the second CNU
    output wire [QUAN_SIZE-1:0] cnu1_M_reg1,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg2,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg4,
    output wire [QUAN_SIZE-1:0] cnu1_M_reg5,

    // From the first CNU
    input wire [QUAN_SIZE-1:0] t_10,
    input wire [QUAN_SIZE-1:0] t_11,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_0,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_1,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_2,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_3,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_4,
    input wire [QUAN_SIZE-1:0] cnu0_v2c_5,
    // From the second CNU
    input wire [QUAN_SIZE-1:0] t_12,
    input wire [QUAN_SIZE-1:0] t_13,
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
    input wire [5:0] ram_write_data_2,

    input wire write_clk,
    input wire ib_ram_we
);

/*-------------Pipeline Register 1 to IB-CNU RAM 2--------------------*/
wire [QUAN_SIZE-1:0] cnu0_f2_y0 [0:3];
wire [QUAN_SIZE-1:0] cnu0_f2_y1 [0:3];
ib_cnu6_f2_route cnu0_f2_in_pipe(
    .f20_y0 (cnu0_f2_y0[0]),
    .f20_y1 (cnu0_f2_y1[0]),
    .f21_y0 (cnu0_f2_y0[1]),
    .f21_y1 (cnu0_f2_y1[1]),
    .f22_y0 (cnu0_f2_y0[2]),
    .f22_y1 (cnu0_f2_y1[2]),
    .f23_y0 (cnu0_f2_y0[3]),
    .f23_y1 (cnu0_f2_y1[3]),
    .M1_reg (cnu0_M_reg1[QUAN_SIZE-1:0]),
    .M2_reg (cnu0_M_reg2[QUAN_SIZE-1:0]),
    .M4_reg (cnu0_M_reg4[QUAN_SIZE-1:0]),
    .M5_reg (cnu0_M_reg5[QUAN_SIZE-1:0]),
        
    .t_10 (t_10[QUAN_SIZE-1:0]),
    .t_11 (t_11[QUAN_SIZE-1:0]),
    .M0(cnu0_v2c_0[QUAN_SIZE-1:0]),
    .M1(cnu0_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu0_v2c_2[QUAN_SIZE-1:0]),
    .M3(cnu0_v2c_3[QUAN_SIZE-1:0]),
    .M4(cnu0_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu0_v2c_5[QUAN_SIZE-1:0])
);

wire [QUAN_SIZE-1:0] cnu1_f2_y0 [0:3];
wire [QUAN_SIZE-1:0] cnu1_f2_y1 [0:3];
ib_cnu6_f2_route cnu1_f2_in_pipe(
    .f20_y0 (cnu1_f2_y0[0]),
    .f20_y1 (cnu1_f2_y1[0]),
    .f21_y0 (cnu1_f2_y0[1]),
    .f21_y1 (cnu1_f2_y1[1]),
    .f22_y0 (cnu1_f2_y0[2]),
    .f22_y1 (cnu1_f2_y1[2]),
    .f23_y0 (cnu1_f2_y0[3]),
    .f23_y1 (cnu1_f2_y1[3]),
    .M1_reg (cnu1_M_reg1[QUAN_SIZE-1:0]),
    .M2_reg (cnu1_M_reg2[QUAN_SIZE-1:0]),
    .M4_reg (cnu1_M_reg4[QUAN_SIZE-1:0]),
    .M5_reg (cnu1_M_reg5[QUAN_SIZE-1:0]),
        
    .t_10 (t_12[QUAN_SIZE-1:0]),
    .t_11 (t_13[QUAN_SIZE-1:0]),
    .M0(cnu1_v2c_0[QUAN_SIZE-1:0]),
    .M1(cnu1_v2c_1[QUAN_SIZE-1:0]),
    .M2(cnu1_v2c_2[QUAN_SIZE-1:0]),
    .M3(cnu1_v2c_3[QUAN_SIZE-1:0]),
    .M4(cnu1_v2c_4[QUAN_SIZE-1:0]),
    .M5(cnu1_v2c_5[QUAN_SIZE-1:0])
);

sym_cn_lut_internal func_ram_20(
	// For read operation
	.t_c_A (cnu0_t_portA[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (cnu0_t_portB[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (cnu0_t_portC[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (cnu0_t_portD[QUAN_SIZE-1:0]), // For fourth reader (D)	
	.read_addr_offset_out (read_addr_offset_out),

    .y0_in_A (cnu0_f2_y0[0]),// page address across 32 pages
    .y0_in_B (cnu0_f2_y0[1]),// page address across 32 pages
    .y0_in_C (cnu0_f2_y0[2]),// page address across 32 pages
    .y0_in_D (cnu0_f2_y0[3]),// page address across 32 pages
    .y1_in_A (cnu0_f2_y1[0]), // bank address across 2 banks
    .y1_in_B (cnu0_f2_y1[1]), // bank address across 2 banks
    .y1_in_C (cnu0_f2_y1[2]), // bank address across 2 banks
    .y1_in_D (cnu0_f2_y1[3]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_2[5:3]), // input data
	.lut_in_bank1 (ram_write_data_2[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);

sym_cn_lut_internal func_ram_21(
	// For read operation
	.t_c_A (cnu1_t_portA[QUAN_SIZE-1:0]), // For first reader  (A)	
	.t_c_B (cnu1_t_portB[QUAN_SIZE-1:0]), // For second reader (B)	
	.t_c_C (cnu1_t_portC[QUAN_SIZE-1:0]), // For third reader  (C)	
	.t_c_D (cnu1_t_portD[QUAN_SIZE-1:0]), // For fourth reader (D)	
	//.read_addr_offset_out (read_addr_offset_out), // done by func_ram_20 is enough

    .y0_in_A (cnu1_f2_y0[0]),// page address across 32 pages
    .y0_in_B (cnu1_f2_y0[1]),// page address across 32 pages
    .y0_in_C (cnu1_f2_y0[2]),// page address across 32 pages
    .y0_in_D (cnu1_f2_y0[3]),// page address across 32 pages
    .y1_in_A (cnu1_f2_y1[0]), // bank address across 2 banks
    .y1_in_B (cnu1_f2_y1[1]), // bank address across 2 banks
    .y1_in_C (cnu1_f2_y1[2]), // bank address across 2 banks
    .y1_in_D (cnu1_f2_y1[3]), // bank address across 2 banks

	.read_addr_offset (read_addr_offset),
	.read_clk (read_clk),
//////////////////////////////////////////////////////////
	// For write operation
	.lut_in_bank0 (ram_write_data_2[5:3]), // input data
	.lut_in_bank1 (ram_write_data_2[2:0]), // input data 
	.page_write_addr (page_addr_ram[4:0]), // write address
	.write_addr_offset (page_addr_ram[5]), // write address offset
	.we (ib_ram_we),
	.write_clk (write_clk)
);
endmodule