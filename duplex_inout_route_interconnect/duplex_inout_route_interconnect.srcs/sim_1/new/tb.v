`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2020 02:18:57 PM
// Design Name: 
// Module Name: tb
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


module tb;

    reg sys_clk, we;
    reg [2:0] address;
    reg [7:0] dataIn;
    wire [7:0] data_inout;
    
    bidir_port dut0 (
        .sys_clk (sys_clk),
        .we (we), // '1' => write enable; '0' => read enable
        .address (address),
        .data (data_inout) 
    );
    
    initial begin
        #0 sys_clk <= 1'b0;
        forever #10 sys_clk <= ~sys_clk;
    end
    initial begin
        #0 we <= 1;
        #160 we <= 0;
    end
    
    initial #0 address <= 0;
    always @(posedge sys_clk) begin
        address <= address + 1;
    end
   
    always @(posedge sys_clk) begin
        dataIn <= address;
    end
    
    assign data_inout = (we)? dataIn : {8{1'hz}}; 
endmodule
