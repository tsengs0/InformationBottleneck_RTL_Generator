`include "define.v"
module cnu6_f3(
    // For the first CNU
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_0, 
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_1, 
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_2, 
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_3,
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_4,
    output wire [`QUAN_SIZE-1:0] cnu0_c2v_5, 
    // For the second CNU
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_0, 
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_1, 
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_2, 
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_3,
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_4,
    output wire [`QUAN_SIZE-1:0] cnu1_c2v_5, 
    
    // From the first CNU
    input wire [`QUAN_SIZE-1:0] cnu0_t_20,
    input wire [`QUAN_SIZE-1:0] cnu0_t_21,
    input wire [`QUAN_SIZE-1:0] cnu0_t_22,
    input wire [`QUAN_SIZE-1:0] cnu0_t_23,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_1,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_2,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_4,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_5,
    // From the second CNU
    input wire [`QUAN_SIZE-1:0] cnu1_t_20,
    input wire [`QUAN_SIZE-1:0] cnu1_t_21,
    input wire [`QUAN_SIZE-1:0] cnu1_t_22,
    input wire [`QUAN_SIZE-1:0] cnu1_t_23,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_1,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_2,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_4,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_5,
        
    // Interation-Update Page Address 
    input wire [4:0] page_addr_ram,
    // Iteration-Update Data
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_3,

    input wire ram_clk,
    input wire ib_ram_we
);
/*-------------Pipeline Register 3 to IB-CNU RAM 3--------------------*/
wire [4:0] cnu0_f3_page_addr [0:`CN_DEGREE-1];
wire [2:0] cnu0_f3_bank_addr [0:`CN_DEGREE-1];
ib_cnu6_f3_pipeReg cnu0_f3_in_pipe(
    .f30_page_addr (cnu0_f3_page_addr[0]),
    .f30_bank_addr (cnu0_f3_bank_addr[0]),
    .f31_page_addr (cnu0_f3_page_addr[1]),
    .f31_bank_addr (cnu0_f3_bank_addr[1]),
    .f32_page_addr (cnu0_f3_page_addr[2]),
    .f32_bank_addr (cnu0_f3_bank_addr[2]),
    .f33_page_addr (cnu0_f3_page_addr[3]),
    .f33_bank_addr (cnu0_f3_bank_addr[3]),
    .f34_page_addr (cnu0_f3_page_addr[4]),
    .f34_bank_addr (cnu0_f3_bank_addr[4]),
    .f35_page_addr (cnu0_f3_page_addr[5]),
    .f35_bank_addr (cnu0_f3_bank_addr[5]),
        
    .t_20 (cnu0_t_20[`QUAN_SIZE-1:0]),
    .t_21 (cnu0_t_21[`QUAN_SIZE-1:0]),
    .t_22 (cnu0_t_22[`QUAN_SIZE-1:0]),
    .t_23 (cnu0_t_23[`QUAN_SIZE-1:0]),
    .M1(cnu0_v2c_1[`QUAN_SIZE-1:0]),
    .M2(cnu0_v2c_2[`QUAN_SIZE-1:0]),
    .M4(cnu0_v2c_4[`QUAN_SIZE-1:0]),
    .M5(cnu0_v2c_5[`QUAN_SIZE-1:0]),
    .ram_clk (ram_clk),
    .en (ib_ram_we)
);

wire [4:0] cnu1_f3_page_addr [0:`CN_DEGREE-1];
wire [2:0] cnu1_f3_bank_addr [0:`CN_DEGREE-1];
ib_cnu6_f3_pipeReg cnu1_f3_in_pipe(
    .f30_page_addr (cnu1_f3_page_addr[0]),
    .f30_bank_addr (cnu1_f3_bank_addr[0]),
    .f31_page_addr (cnu1_f3_page_addr[1]),
    .f31_bank_addr (cnu1_f3_bank_addr[1]),
    .f32_page_addr (cnu1_f3_page_addr[2]),
    .f32_bank_addr (cnu1_f3_bank_addr[2]),
    .f33_page_addr (cnu1_f3_page_addr[3]),
    .f33_bank_addr (cnu1_f3_bank_addr[3]),
    .f34_page_addr (cnu1_f3_page_addr[4]),
    .f34_bank_addr (cnu1_f3_bank_addr[4]),
    .f35_page_addr (cnu1_f3_page_addr[5]),
    .f35_bank_addr (cnu1_f3_bank_addr[5]),
        
    .t_20 (cnu1_t_20[`QUAN_SIZE-1:0]),
    .t_21 (cnu1_t_21[`QUAN_SIZE-1:0]),
    .t_22 (cnu1_t_22[`QUAN_SIZE-1:0]),
    .t_23 (cnu1_t_23[`QUAN_SIZE-1:0]),
    .M1(cnu1_v2c_1[`QUAN_SIZE-1:0]),
    .M2(cnu1_v2c_2[`QUAN_SIZE-1:0]),
    .M4(cnu1_v2c_4[`QUAN_SIZE-1:0]),
    .M5(cnu1_v2c_5[`QUAN_SIZE-1:0]),
    .ram_clk (ram_clk),
    .en (ib_ram_we)
);

ib_lut_ram func_ram_30(
    .t_c_A (cnu0_c2v_0[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (cnu0_c2v_1[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (cnu0_c2v_2[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (cnu0_c2v_3[`QUAN_SIZE-1:0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (cnu0_f3_page_addr[0]),// page address across 32 pages
    .addr_readB (cnu0_f3_page_addr[1]),// page address across 32 pages
    .addr_readC (cnu0_f3_page_addr[2]),// page address across 32 pages
    .addr_readD (cnu0_f3_page_addr[3]),// page address across 32 pages
    .bank_readA (cnu0_f3_bank_addr[0]), // bank address across 8 banks
    .bank_readB (cnu0_f3_bank_addr[1]), // bank address across 8 banks
    .bank_readC (cnu0_f3_bank_addr[2]), // bank address across 8 banks
    .bank_readD (cnu0_f3_bank_addr[3]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data_3[31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data_3[27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data_3[23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data_3[19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data_3[15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data_3[11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data_3[7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data_3[3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ib_ram_we),
    .sys_clk (~ram_clk)
);

ib_lut_ram func_ram_31(
    .t_c_A (cnu0_c2v_4[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (cnu0_c2v_5[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (cnu1_c2v_0[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (cnu1_c2v_1[`QUAN_SIZE-1:0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (cnu0_f3_page_addr[4]),// page address across 32 pages
    .addr_readB (cnu0_f3_page_addr[5]),// page address across 32 pages

    .addr_readC (cnu1_f3_page_addr[0]),// page address across 32 pages
    .addr_readD (cnu1_f3_page_addr[1]),// page address across 32 pages
    
    .bank_readA (cnu0_f3_bank_addr[4]), // bank address across 8 banks
    .bank_readB (cnu0_f3_bank_addr[5]), // bank address across 8 banks

    .bank_readC (cnu1_f3_bank_addr[0]), // bank address across 8 banks
    .bank_readD (cnu1_f3_bank_addr[1]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data_3[31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data_3[27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data_3[23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data_3[19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data_3[15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data_3[11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data_3[7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data_3[3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ib_ram_we),
    .sys_clk (~ram_clk)
);

ib_lut_ram func_ram_32(
    .t_c_A (cnu1_c2v_2[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (cnu1_c2v_3[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (cnu1_c2v_4[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (cnu1_c2v_5[`QUAN_SIZE-1:0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (cnu1_f3_page_addr[2]),// page address across 32 pages
    .addr_readB (cnu1_f3_page_addr[3]),// page address across 32 pages
    .addr_readC (cnu1_f3_page_addr[4]),// page address across 32 pages
    .addr_readD (cnu1_f3_page_addr[5]),// page address across 32 pages
    .bank_readA (cnu1_f3_bank_addr[2]), // bank address across 8 banks
    .bank_readB (cnu1_f3_bank_addr[3]), // bank address across 8 banks
    .bank_readC (cnu1_f3_bank_addr[4]), // bank address across 8 banks
    .bank_readD (cnu1_f3_bank_addr[5]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data_3[31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data_3[27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data_3[23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data_3[19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data_3[15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data_3[11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data_3[7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data_3[3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ib_ram_we),
    .sys_clk (~ram_clk)
);
endmodule