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
    // For first reader (A)
    output wire [`QUAN_SIZE-1:0] t_c_bank0A,
    output wire [`QUAN_SIZE-1:0] t_c_bank1A,
    output wire [`QUAN_SIZE-1:0] t_c_bank2A,
    output wire [`QUAN_SIZE-1:0] t_c_bank3A,
    output wire [`QUAN_SIZE-1:0] t_c_bank4A,
    output wire [`QUAN_SIZE-1:0] t_c_bank5A,
    output wire [`QUAN_SIZE-1:0] t_c_bank6A,
    output wire [`QUAN_SIZE-1:0] t_c_bank7A,

    // For second reader (B)
    output wire [`QUAN_SIZE-1:0] t_c_bank0B,
    output wire [`QUAN_SIZE-1:0] t_c_bank1B,
    output wire [`QUAN_SIZE-1:0] t_c_bank2B,
    output wire [`QUAN_SIZE-1:0] t_c_bank3B,
    output wire [`QUAN_SIZE-1:0] t_c_bank4B,
    output wire [`QUAN_SIZE-1:0] t_c_bank5B,
    output wire [`QUAN_SIZE-1:0] t_c_bank6B,
    output wire [`QUAN_SIZE-1:0] t_c_bank7B, 
    
    // For third reader (C)
    output wire [`QUAN_SIZE-1:0] t_c_bank0C,
    output wire [`QUAN_SIZE-1:0] t_c_bank1C,
    output wire [`QUAN_SIZE-1:0] t_c_bank2C,
    output wire [`QUAN_SIZE-1:0] t_c_bank3C,
    output wire [`QUAN_SIZE-1:0] t_c_bank4C,
    output wire [`QUAN_SIZE-1:0] t_c_bank5C,
    output wire [`QUAN_SIZE-1:0] t_c_bank6C,
    output wire [`QUAN_SIZE-1:0] t_c_bank7C,   
    
    // For fourth reader (D)
    output wire [`QUAN_SIZE-1:0] t_c_bank0D,
    output wire [`QUAN_SIZE-1:0] t_c_bank1D,
    output wire [`QUAN_SIZE-1:0] t_c_bank2D,
    output wire [`QUAN_SIZE-1:0] t_c_bank3D,
    output wire [`QUAN_SIZE-1:0] t_c_bank4D,
    output wire [`QUAN_SIZE-1:0] t_c_bank5D,
    output wire [`QUAN_SIZE-1:0] t_c_bank6D,
    output wire [`QUAN_SIZE-1:0] t_c_bank7D,
    
    // For first 
    input wire [4:0] ram_addr_readA,
    input wire [4:0] ram_addr_readB,
    input wire [4:0] ram_addr_readC,
    input wire [4:0] ram_addr_readD,
    
    // Write Port Addresses
    input wire [4:0] ram_addr_write, // synchronous write address
    // Write Qual-port    
    input wire [3:0] ib_ram_inA,        
    input wire [3:0] ib_ram_inB,    
    input wire [3:0] ib_ram_inC,    
    input wire [3:0] ib_ram_inD, 
    
    input wire write_en,
    input sys_clk
);
                                                                                                                                       
ib_distributed_ram_bank bank_0 (
    .ib_ram_outA (t_c_bank0A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank0B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank0C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank0D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_1 (
    .ib_ram_outA (t_c_bank1A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank1B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank1C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank1D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_2 (
    .ib_ram_outA (t_c_bank2A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank2B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank2C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank2D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_3 (
    .ib_ram_outA (t_c_bank3A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank3B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank3C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank3D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_4 (
    .ib_ram_outA (t_c_bank4A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank4B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank4C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank4D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_5 (
    .ib_ram_outA (t_c_bank5A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank5B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank5C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank5D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_6 (
    .ib_ram_outA (t_c_bank6A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank6B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank6C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank6D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);

ib_distributed_ram_bank bank_7 (
    .ib_ram_outA (t_c_bank7A[`QUAN_SIZE-1:0]),
    .ib_ram_outB (t_c_bank7B[`QUAN_SIZE-1:0]),
    .ib_ram_outC (t_c_bank7C[`QUAN_SIZE-1:0]),
    .ib_ram_outD (t_c_bank7D[`QUAN_SIZE-1:0]),
    
    // Read Port Addresses
    .ram_addr_readA (ram_addr_readA[4:0]), // asynchronous read address
    .ram_addr_readB (ram_addr_readB[4:0]), // asynchronous read address
    .ram_addr_readC (ram_addr_readC[4:0]), // asynchronous read address
    .ram_addr_readD (ram_addr_readD[4:0]), // asynchronous read address
    // Write Port Addresses
    .ram_addr_write (ram_addr_write), // synchronous write address
    // Write Qual-port
    .ib_ram_inA (ib_ram_inA[3:0]),
    .ib_ram_inB (ib_ram_inB[3:0]),
    .ib_ram_inC (ib_ram_inC[3:0]),
    .ib_ram_inD (ib_ram_inD[3:0]), 
    
    .write_en (write_en),
    .sys_clk (sys_clk) 
);
endmodule

