`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 7th March, 2020 PM8:49
// Design Name: 
// Module Name: ram_sel_counter
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
module ram_sel_counter(
    output reg [1:0] ram_sel,
    input wire en,
    input wire m_clk
);

wire clk_gate;
assign clk_gate = m_clk & en;
initial ram_sel[1:0] <= 2'b00;
always @(negedge clk_gate) begin
	if(m_clk == 1'b0)
		ram_sel[1:0] <= ram_sel[1:0] + 2'b01;  
end
endmodule
