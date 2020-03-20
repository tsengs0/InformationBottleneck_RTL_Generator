`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 7th March, 2020 PM8:50
// Design Name: 
// Module Name: c6ibwr_ram_sel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 1.2
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module c6ibwr_ram_sel(
    output wire [31:0] interBank_data_ram0,
    output wire [31:0] interBank_data_ram1,
    output wire [31:0] interBank_data_ram2,
    output wire [31:0] interBank_data_ram3,
    
    input wire [31:0] interBank_write_data,
    input wire [1:0] ram_sel
);
// Since the there is a register between output of the ram_sel_counter and
// input of ram_sel of this module, the selected channel of the following 
// 1-to-4 DEMUX suppose be latched as well. That is, at falling edge of m_clk,
// the DEMUX should still branch the latched value of ram_sel at the timing t
// where t=[0, falling edge of m_clk).   
assign interBank_data_ram0 = (ram_sel[1:0] == 2'b00) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram1 = (ram_sel[1:0] == 2'b01) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram2 = (ram_sel[1:0] == 2'b10) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram3 = (ram_sel[1:0] == 2'b11) ? interBank_write_data[31:0] : 32'd0;
endmodule
