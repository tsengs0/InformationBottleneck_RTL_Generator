`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2020, AM2:23
// Design Name: 
// Module Name: reconf_ib_lut2
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
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module ib_lut_ram(
    output wire [`QUAN_SIZE-1:0] t_c_A, // For first reader  (A)    
    output wire [`QUAN_SIZE-1:0] t_c_B, // For second reader (B) 
    output wire [`QUAN_SIZE-1:0] t_c_C, // For third reader  (C)  
    output wire [`QUAN_SIZE-1:0] t_c_D, // For fourth reader (D)
    
    // For Read-related address buses
    input wire [4:0] addr_readA,// page address across 32 pages
    input wire [4:0] addr_readB,// page address across 32 pages
    input wire [4:0] addr_readC,// page address across 32 pages
    input wire [4:0] addr_readD,// page address across 32 pages
    input wire [2:0] bank_readA, // bank address across 8 banks
    input wire [2:0] bank_readB, // bank address across 8 banks
    input wire [2:0] bank_readC, // bank address across 8 banks
    input wire [2:0] bank_readD, // bank address across 8 banks
    
    // Write Port Addresses
    input wire [4:0] page_addr_write, // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    input wire [`QUAN_SIZE-1:0] bank_data_write0, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write1, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write2, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write3, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write4, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write5, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write6, // Same bank of all 4 ports are written same page data
    input wire [`QUAN_SIZE-1:0] bank_data_write7, // Same bank of all 4 ports are written same page data       
    
    input wire write_en,
    input sys_clk
);
wire [`QUAN_SIZE-1:0] t_c_bankA[0:7];
wire [`QUAN_SIZE-1:0] t_c_bankB[0:7];
wire [`QUAN_SIZE-1:0] t_c_bankC[0:7];
wire [`QUAN_SIZE-1:0] t_c_bankD[0:7];                                                                                                                            
ib_distributed_ram_bank bank_0 (
    .ib_ram_outA (t_c_bankA[0]),
    .ib_ram_outB (t_c_bankB[0]),
    .ib_ram_outC (t_c_bankC[0]),
    .ib_ram_outD (t_c_bankD[0]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write0[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_1 (
    .ib_ram_outA (t_c_bankA[1]),
    .ib_ram_outB (t_c_bankB[1]),
    .ib_ram_outC (t_c_bankC[1]),
    .ib_ram_outD (t_c_bankD[1]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write1[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_2 (
    .ib_ram_outA (t_c_bankA[2]),
    .ib_ram_outB (t_c_bankB[2]),
    .ib_ram_outC (t_c_bankC[2]),
    .ib_ram_outD (t_c_bankD[2]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write2[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_3 (
    .ib_ram_outA (t_c_bankA[3]),
    .ib_ram_outB (t_c_bankB[3]),
    .ib_ram_outC (t_c_bankC[3]),
    .ib_ram_outD (t_c_bankD[3]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write3[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_4 (
    .ib_ram_outA (t_c_bankA[4]),
    .ib_ram_outB (t_c_bankB[4]),
    .ib_ram_outC (t_c_bankC[4]),
    .ib_ram_outD (t_c_bankD[4]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write4[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_5 (
    .ib_ram_outA (t_c_bankA[5]),
    .ib_ram_outB (t_c_bankB[5]),
    .ib_ram_outC (t_c_bankC[5]),
    .ib_ram_outD (t_c_bankD[5]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write5[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk)  
);

ib_distributed_ram_bank bank_6 (
    .ib_ram_outA (t_c_bankA[6]),
    .ib_ram_outB (t_c_bankB[6]),
    .ib_ram_outC (t_c_bankC[6]),
    .ib_ram_outD (t_c_bankD[6]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write6[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_7 (
    .ib_ram_outA (t_c_bankA[7]),
    .ib_ram_outB (t_c_bankB[7]),
    .ib_ram_outC (t_c_bankC[7]),
    .ib_ram_outD (t_c_bankD[7]),
    
    // Read Port Addresses
    .ram_addr_readA (addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (page_addr_write[4:0]), // synchronous write address
    // Write Qual-port
    .ib_ram_in (bank_data_write7[`QUAN_SIZE-1:0]),

    .write_en (write_en),
    .sys_clk (sys_clk) 
);

assign t_c_A[`QUAN_SIZE-1:0] = t_c_bankA[bank_readA[2:0]];
assign t_c_B[`QUAN_SIZE-1:0] = t_c_bankB[bank_readB[2:0]];
assign t_c_C[`QUAN_SIZE-1:0] = t_c_bankC[bank_readC[2:0]];
assign t_c_D[`QUAN_SIZE-1:0] = t_c_bankD[bank_readD[2:0]];               
endmodule

