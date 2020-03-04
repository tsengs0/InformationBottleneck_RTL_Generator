`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 02:34:00 AM
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
// Revision 0.01 - File Created
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

assign interBank_data_ram0 = (ram_sel[1:0] == 2'b00) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram0 = (ram_sel[1:0] == 2'b01) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram0 = (ram_sel[1:0] == 2'b10) ? interBank_write_data[31:0] : 32'd0;
assign interBank_data_ram0 = (ram_sel[1:0] == 2'b11) ? interBank_write_data[31:0] : 32'd0;
endmodule
