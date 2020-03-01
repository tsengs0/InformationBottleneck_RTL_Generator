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
`include "define.v"

module top(
    output wire [`QUAN_SIZE-1:0] t_c,
        
    input wire [`QUAN_SIZE-1:0] y0,
    input wire [`QUAN_SIZE-1:0] y1,
    input wire [`QUAN_SIZE-1:0] y2,
    input wire [`QUAN_SIZE-1:0] y3,
    input wire [`QUAN_SIZE-1:0] y4,
    input sys_clk
);

wire [`QUAN_SIZE-1:0] t_portA[0:2]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portB[0:2]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portC[0:2]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portD[0:2]; // internal signals accounting for each 256-entry partial LUT's output
wire [4:0] ib_ram_addr[0:3];
wire [2:0] bank_read_sel[0:3];
reconf_ib_lut2 func_0(
     .ib_ram_page_addr (ib_ram_addr[0]  ),
     .ib_ram_bank_addr (bank_read_sel[0]),
    
     .y1 (y1[`QUAN_SIZE-1:0]),
     .y0 (y0[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_1(
     .ib_ram_page_addr (ib_ram_addr[1]  ),
     .ib_ram_bank_addr (bank_read_sel[1]),
    
     .y1 (t_portA[0]),
     .y0 (y2[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_2(
     .ib_ram_page_addr (ib_ram_addr[2]  ),
     .ib_ram_bank_addr (bank_read_sel[2]),
    
     .y1 (t_portA[1]),
     .y0 (y3[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_3(
     .ib_ram_page_addr (ib_ram_addr[3]  ),
     .ib_ram_bank_addr (bank_read_sel[3]),
    
     .y1 (t_portA[2]),
     .y0 (y4[`QUAN_SIZE-1:0])
);

ib_lut_ram func_ram_0(
    .t_c_A (t_portA[0]), // For first reader  (A)    
    .t_c_B (t_portB[0]), // For second reader (B) 
    .t_c_C (t_portC[0]), // For third reader  (C)  
    .t_c_D (t_portD[0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[0]),// page address across 32 pages
    .addr_readB (ib_ram_addr[0]),// page address across 32 pages
    .addr_readC (ib_ram_addr[0]),// page address across 32 pages
    .addr_readD (ib_ram_addr[0]),// page address across 32 pages
    .bank_readA (bank_read_sel[0]), // bank address across 8 banks
    .bank_readB (bank_read_sel[0]), // bank address across 8 banks
    .bank_readC (bank_read_sel[0]), // bank address across 8 banks
    .bank_readD (bank_read_sel[0]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (), // Same bank of all 4 ports are written same page data       
    
    .write_en (),
    .sys_clk ()
);

ib_lut_ram func_ram_1(
    .t_c_A (t_portA[1]), // For first reader  (A)    
    .t_c_B (t_portB[1]), // For second reader (B) 
    .t_c_C (t_portC[1]), // For third reader  (C)  
    .t_c_D (t_portD[1]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[1]),// page address across 32 pages
    .addr_readB (ib_ram_addr[1]),// page address across 32 pages
    .addr_readC (ib_ram_addr[1]),// page address across 32 pages
    .addr_readD (ib_ram_addr[1]),// page address across 32 pages
    .bank_readA (bank_read_sel[1]), // bank address across 8 banks
    .bank_readB (bank_read_sel[1]), // bank address across 8 banks
    .bank_readC (bank_read_sel[1]), // bank address across 8 banks
    .bank_readD (bank_read_sel[1]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (), // Same bank of all 4 ports are written same page data       
    
    .write_en (),
    .sys_clk ()
);

ib_lut_ram func_ram_2(
    .t_c_A (t_portA[2]), // For first reader  (A)    
    .t_c_B (t_portB[2]), // For second reader (B) 
    .t_c_C (t_portC[2]), // For third reader  (C)  
    .t_c_D (t_portD[2]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[2]),// page address across 32 pages
    .addr_readB (ib_ram_addr[2]),// page address across 32 pages
    .addr_readC (ib_ram_addr[2]),// page address across 32 pages
    .addr_readD (ib_ram_addr[2]),// page address across 32 pages
    .bank_readA (bank_read_sel[2]), // bank address across 8 banks
    .bank_readB (bank_read_sel[2]), // bank address across 8 banks
    .bank_readC (bank_read_sel[2]), // bank address across 8 banks
    .bank_readD (bank_read_sel[2]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (), // Same bank of all 4 ports are written same page data       
    
    .write_en (),
    .sys_clk ()
);

ib_lut_ram func_ram_3(
    .t_c_A (t_portA[3]), // For first reader  (A)    
    .t_c_B (t_portB[3]), // For second reader (B) 
    .t_c_C (t_portC[3]), // For third reader  (C)  
    .t_c_D (t_portD[3]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[3]),// page address across 32 pages
    .addr_readB (ib_ram_addr[3]),// page address across 32 pages
    .addr_readC (ib_ram_addr[3]),// page address across 32 pages
    .addr_readD (ib_ram_addr[3]),// page address across 32 pages
    .bank_readA (bank_read_sel[3]), // bank address across 8 banks
    .bank_readB (bank_read_sel[3]), // bank address across 8 banks
    .bank_readC (bank_read_sel[3]), // bank address across 8 banks
    .bank_readD (bank_read_sel[3]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (), // Same bank of all 4 ports are written same page data       
    
    .write_en (),
    .sys_clk ()
);
assign t_c[`QUAN_SIZE-1:0] = t_portA[3];
endmodule
