`include "define.v"
module cnu6_f1(
    // For the first CNU
    output wire [`QUAN_SIZE-1:0] t_portA, // internal signals accounting for each 256-entry partial LUT's output
    output wire [`QUAN_SIZE-1:0] t_portB, // internal signals accounting for each 256-entry partial LUT's output
    // For the second CNU
    output wire [`QUAN_SIZE-1:0] t_portC, // internal signals accounting for each 256-entry partial LUT's output
    output wire [`QUAN_SIZE-1:0] t_portD, // internal signals accounting for each 256-entry partial LUT's output
    // For the first CNU
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg0,
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg1,
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg2,
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg3,
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg4,
    output wire [`QUAN_SIZE-1:0] cnu0_M_reg5,
    // For the second CNU
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg0,
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg1,
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg2,
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg3,
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg4,
    output wire [`QUAN_SIZE-1:0] cnu1_M_reg5,

    // From the first CNU
    input wire [`QUAN_SIZE-1:0] t_00,
    input wire [`QUAN_SIZE-1:0] t_01,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_0,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_1,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_2,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_3,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_4,
    input wire [`QUAN_SIZE-1:0] cnu0_v2c_5,
    // From the second CNU
    input wire [`QUAN_SIZE-1:0] t_02,
    input wire [`QUAN_SIZE-1:0] t_03,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_0,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_1,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_2,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_3,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_4,
    input wire [`QUAN_SIZE-1:0] cnu1_v2c_5,
        
    // Interation-Update Page Address 
    input wire [4:0] page_addr_ram,
    // Iteration-Update Data
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_1,

    input wire ram_clk,
    input wire ib_ram_we
);

/*-------------Pipeline Register 1 to IB-CNU RAM 1--------------------*/
wire [4:0] cnu0_f1_page_addr [0:1];
wire [2:0] cnu0_f1_bank_addr [0:1];
ib_cnu6_f1_pipeReg cnu0_f1_in_pipe(
    .f10_page_addr (cnu0_f1_page_addr[0]),
    .f10_bank_addr (cnu0_f1_bank_addr[0]),
    .f11_page_addr (cnu0_f1_page_addr[1]),
    .f11_bank_addr (cnu0_f1_bank_addr[1]),
    .M0_reg (cnu0_M_reg0[`QUAN_SIZE-1:0]),
    .M1_reg (cnu0_M_reg1[`QUAN_SIZE-1:0]),
    .M2_reg (cnu0_M_reg2[`QUAN_SIZE-1:0]),
    .M3_reg (cnu0_M_reg3[`QUAN_SIZE-1:0]),
    .M4_reg (cnu0_M_reg4[`QUAN_SIZE-1:0]),
    .M5_reg (cnu0_M_reg5[`QUAN_SIZE-1:0]),

    .t_00 (t_00[`QUAN_SIZE-1:0]),
    .t_01 (t_01[`QUAN_SIZE-1:0]),   
    .M0(cnu0_v2c_0[`QUAN_SIZE-1:0]),
    .M1(cnu0_v2c_1[`QUAN_SIZE-1:0]),
    .M2(cnu0_v2c_2[`QUAN_SIZE-1:0]),
    .M3(cnu0_v2c_3[`QUAN_SIZE-1:0]),
    .M4(cnu0_v2c_4[`QUAN_SIZE-1:0]),
    .M5(cnu0_v2c_5[`QUAN_SIZE-1:0]),
    .ram_clk (ram_clk),
    .en (ib_ram_we)
);

wire [4:0] cnu1_f1_page_addr [0:1];
wire [2:0] cnu1_f1_bank_addr [0:1];
ib_cnu6_f1_pipeReg cnu1_f1_in_pipe(
    .f10_page_addr (cnu1_f1_page_addr[0]),
    .f10_bank_addr (cnu1_f1_bank_addr[0]),
    .f11_page_addr (cnu1_f1_page_addr[1]),
    .f11_bank_addr (cnu1_f1_bank_addr[1]),
    .M0_reg (cnu1_M_reg0[`QUAN_SIZE-1:0]),
    .M1_reg (cnu1_M_reg1[`QUAN_SIZE-1:0]),
    .M2_reg (cnu1_M_reg2[`QUAN_SIZE-1:0]),
    .M3_reg (cnu1_M_reg3[`QUAN_SIZE-1:0]),
    .M4_reg (cnu1_M_reg4[`QUAN_SIZE-1:0]),
    .M5_reg (cnu1_M_reg5[`QUAN_SIZE-1:0]),

    .t_00 (t_02[`QUAN_SIZE-1:0]),
    .t_01 (t_03[`QUAN_SIZE-1:0]),       
    .M0(cnu1_v2c_0[`QUAN_SIZE-1:0]),
    .M1(cnu1_v2c_1[`QUAN_SIZE-1:0]),
    .M2(cnu1_v2c_2[`QUAN_SIZE-1:0]),
    .M3(cnu1_v2c_3[`QUAN_SIZE-1:0]),
    .M4(cnu1_v2c_4[`QUAN_SIZE-1:0]),
    .M5(cnu1_v2c_5[`QUAN_SIZE-1:0]),
    .ram_clk (ram_clk),
    .en (ib_ram_we)
);
ib_lut_ram func_ram_1(
    .t_c_A (t_portA[`QUAN_SIZE-1:0]), // For first reader  (A)    
    .t_c_B (t_portB[`QUAN_SIZE-1:0]), // For second reader (B) 
    .t_c_C (t_portC[`QUAN_SIZE-1:0]), // For third reader  (C)  
    .t_c_D (t_portD[`QUAN_SIZE-1:0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (cnu0_f1_page_addr[0]),// page address across 32 pages
    .addr_readB (cnu0_f1_page_addr[1]),// page address across 32 pages
    .addr_readC (cnu1_f1_page_addr[0]),// page address across 32 pages
    .addr_readD (cnu1_f1_page_addr[1]),// page address across 32 pages
    .bank_readA (cnu0_f1_bank_addr[0]), // bank address across 8 banks
    .bank_readB (cnu0_f1_bank_addr[1]), // bank address across 8 banks
    .bank_readC (cnu1_f1_bank_addr[0]), // bank address across 8 banks
    .bank_readD (cnu1_f1_bank_addr[1]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data_1[31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data_1[27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data_1[23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data_1[19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data_1[15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data_1[11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data_1[7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data_1[3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ib_ram_we),
    .sys_clk (~ram_clk)
);
endmodule