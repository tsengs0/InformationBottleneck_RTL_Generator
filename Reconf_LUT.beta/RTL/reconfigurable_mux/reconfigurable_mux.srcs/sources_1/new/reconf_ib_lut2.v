`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 08:22:41 PM
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
//`include "define.v"
`define QUAN_SIZE 4
`define IB_ADDR 8
`define CARDINALITY 16
`define RAM_DEPTH 256

module reconf_ib_lut2(
    output wire [4:0] ib_ram_addr,
    output wire [2:0] bank_read_sel,
    
    //input wire [`QUAN_SIZE-1:0] ib_ram_in, // read 4-bit result from distributed RAM
    input wire [`QUAN_SIZE-1:0] y1,
    input wire [`QUAN_SIZE-1:0] y0,
    input sys_clk
);
    
assign {ib_ram_addr[4:0], bank_read_sel[2:0]} = 
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd32)  ? {y1[0], y0[`QUAN_SIZE-1:0], 3'b000} : // for bank 0
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd48)  ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b001} : // for bank 1
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd64)  ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b001} : // for bank 1
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd80)  ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b010} : // for bank 2
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd96)  ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b010} : // for bank 2 
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd112) ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b011} : // for bank 3
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd128) ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b011} : // for bank 3 
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd144) ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b100} : // for bank 4
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd160) ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b100} : // for bank 4  
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd176) ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b101} : // for bank 5
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd192) ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b101} : // for bank 5 
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd208) ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b110} : // for bank 6
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd224) ? {1'b1 , y0[`QUAN_SIZE-1:0], 3'b110} : // for bank 6 
                        ({y1[`QUAN_SIZE-1:0], y0[`QUAN_SIZE-1:0]} < `IB_ADDR'd240) ? {1'b0 , y0[`QUAN_SIZE-1:0], 3'b111} : // for bank 7
                                                                                     {1'b1 , y0[`QUAN_SIZE-1:0], 3'b111};  // for bank 7                                                                                                                                        
endmodule