`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2020 10:14:22 PM
// Design Name: 
// Module Name: test_dff
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


module test_dff;

    reg sys_clk;
    initial begin
        #0 sys_clk <= 1'b0;
        #10;
        forever #10 sys_clk <= ~sys_clk;
    end

    wire qout;
    reg din;
    initial #0 din <= 1'b0;
    always @(posedge sys_clk) begin
        din <= ~din;
    end
           FDCE #(
              .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
           ) FDCE_inst (
              .Q(qout),      // 1-bit Data output
              .C(sys_clk),      // 1-bit Clock input
              .CE(1'b1),    // 1-bit Clock enable input
              .CLR(1'b0),  // 1-bit Asynchronous clear input
              .D(din)       // 1-bit Data input
           ); 
           initial #(10+20*20) $finish; 
endmodule
