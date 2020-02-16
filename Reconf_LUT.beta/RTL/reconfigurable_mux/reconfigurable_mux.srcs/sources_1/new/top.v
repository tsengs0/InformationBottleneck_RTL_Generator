`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 11:40:19 PM
// Design Name: 
// Module Name: top
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

module top(
    output wire [`QUAN_SIZE-1:0] t_c,
        
    input wire [`QUAN_SIZE-1:0] y0,
    input wire [`QUAN_SIZE-1:0] y1,
    input wire [`QUAN_SIZE-1:0] y2,
    input wire [`QUAN_SIZE-1:0] y3,
    input wire [`QUAN_SIZE-1:0] y4,
    input sys_clk
);

wire [`QUAN_SIZE-1:0] t[0:2]; // internal signals accounting for each 256-entry partial LUT's output
wire [4:0] ib_ram_addr[0:3];
wire [2:0] bank_read_sel[0:3];
reconf_ib_lut2 func_0(
     .ib_ram_addr (ib_ram_addr[0]),
     .bank_read_sel (bank_read_sel[0]),
    
     .y1 (y1[`QUAN_SIZE-1:0]),
     .y0 (y0[`QUAN_SIZE-1:0]),
     .sys_clk (sys_clk)
);

reconf_ib_lut2 func_1(
     .ib_ram_addr (ib_ram_addr[1]),
     .bank_read_sel (bank_read_sel[1]),
    
     .y1 (t[0]),
     .y0 (y2[`QUAN_SIZE-1:0]),
     .sys_clk (sys_clk)
);

reconf_ib_lut2 func_2(
     .ib_ram_addr (ib_ram_addr[2]),
     .bank_read_sel (bank_read_sel[2]),
    
     .y1 (t[1]),
     .y0 (y3[`QUAN_SIZE-1:0]),
     .sys_clk (sys_clk)
);

reconf_ib_lut2 func_3(
     .ib_ram_addr (ib_ram_addr[3]),
     .bank_read_sel (bank_read_sel[3]),
    
     .y1 (t[2]),
     .y0 (y4[`QUAN_SIZE-1:0]),
     .sys_clk (sys_clk)
);


wire [`QUAN_SIZE-1:0] t_c_0_bank[0:7];
ib_lut_ram func_ram_0(
    .t_c_bank0 (t_c_0_bank[0]),
    .t_c_bank1 (t_c_0_bank[1]),
    .t_c_bank2 (t_c_0_bank[2]),
    .t_c_bank3 (t_c_0_bank[3]),
    .t_c_bank4 (t_c_0_bank[4]),
    .t_c_bank5 (t_c_0_bank[5]),
    .t_c_bank6 (t_c_0_bank[6]),
    .t_c_bank7 (t_c_0_bank[7]),
    
    .ib_ram_addr (ib_ram_addr[0]),
    .sys_clk (sys_clk)
);
assign t[0] = t_c_0_bank[bank_read_sel[0]];

wire [`QUAN_SIZE-1:0] t_c_1_bank[0:7];
ib_lut_ram func_ram_1(
    .t_c_bank0 (t_c_1_bank[0]),
    .t_c_bank1 (t_c_1_bank[1]),
    .t_c_bank2 (t_c_1_bank[2]),
    .t_c_bank3 (t_c_1_bank[3]),
    .t_c_bank4 (t_c_1_bank[4]),
    .t_c_bank5 (t_c_1_bank[5]),
    .t_c_bank6 (t_c_1_bank[6]),
    .t_c_bank7 (t_c_1_bank[7]),
    
    .ib_ram_addr (ib_ram_addr[1]),
    .sys_clk (sys_clk)
);
assign t[1] = t_c_1_bank[bank_read_sel[1]];

wire [`QUAN_SIZE-1:0] t_c_2_bank[0:7];
ib_lut_ram func_ram_2(
    .t_c_bank0 (t_c_2_bank[0]),
    .t_c_bank1 (t_c_2_bank[1]),
    .t_c_bank2 (t_c_2_bank[2]),
    .t_c_bank3 (t_c_2_bank[3]),
    .t_c_bank4 (t_c_2_bank[4]),
    .t_c_bank5 (t_c_2_bank[5]),
    .t_c_bank6 (t_c_2_bank[6]),
    .t_c_bank7 (t_c_2_bank[7]),
    
    .ib_ram_addr (ib_ram_addr[2]),
    .sys_clk (sys_clk)
);
assign t[2] = t_c_2_bank[bank_read_sel[2]];

wire [`QUAN_SIZE-1:0] t_c_3_bank[0:7];
ib_lut_ram func_ram_3(
    .t_c_bank0 (t_c_3_bank[0]),
    .t_c_bank1 (t_c_3_bank[1]),
    .t_c_bank2 (t_c_3_bank[2]),
    .t_c_bank3 (t_c_3_bank[3]),
    .t_c_bank4 (t_c_3_bank[4]),
    .t_c_bank5 (t_c_3_bank[5]),
    .t_c_bank6 (t_c_3_bank[6]),
    .t_c_bank7 (t_c_3_bank[7]),
    
    .ib_ram_addr (ib_ram_addr[3]),
    .sys_clk (sys_clk)
);
assign t_c[`QUAN_SIZE-1:0] = t_c_3_bank[bank_read_sel[3]];
endmodule
