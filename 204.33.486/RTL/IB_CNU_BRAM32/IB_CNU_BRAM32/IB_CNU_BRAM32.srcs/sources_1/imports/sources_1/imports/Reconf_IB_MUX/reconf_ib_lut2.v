`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JAIST
// Engineer: Bo-Yu TSENG 
// Student ID: 1820419
//
// Create Date: 28/02/2020 PM06:10
// Design Name: 
// Module Name: reconf_ib_lut2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Changing the address mapping scheme in a bank-interleaving fashion
// 
// Dependencies: 
// 
// Revision: 1
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module reconf_ib_lut2(
    // Address width: log2(depth)+log2(#bank), where depth=32 and #bank=8,
    // e.g. 5+3=8
    output wire [4:0] ib_ram_page_addr,
    output wire [2:0] ib_ram_bank_addr,
    
    //input wire [`QUAN_SIZE-1:0] ib_ram_in, // read 4-bit result from distributed RAM
    input wire [`QUAN_SIZE-1:0] y1,
    input wire [`QUAN_SIZE-1:0] y0
);
    
assign ib_ram_page_addr[4:0] = {y0[3:0], y1[3]};
assign ib_ram_bank_addr[2:0] = y1[2:0];
endmodule
