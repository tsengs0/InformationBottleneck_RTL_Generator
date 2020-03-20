`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 7th March, 2020 PM8:46
// Design Name: 
// Module Name: decom_clk_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  Generating a clock source where the clock rate is 15 times lower than the clock rate of ram_clk
// Dependencies: 
// 
// Revision 1.2
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module decomp_clk_gen(
    output reg m_clk,
    input wire en,
    input wire rom_clk
);

wire en_reg;
//initial en_reg <= 1'b0;
//always @(posedge rom_clk) en_reg <= en;
assign en_reg = en;
reg [3:0] cnt = 4'b0000; // counting from 0 to 14
always @(posedge rom_clk) begin
    if(!en_reg) 
	cnt[3:0] <= 4'd0;
    else if(cnt[3:0] == 4'd14)
        cnt[3:0] <= 4'b0000;
    else
        cnt[3:0] <= cnt[3:0] + 1'b1;
end
always @(rom_clk) begin
	if(!en_reg) m_clk <= 1'b0;
	else if(cnt[3:0] == 4'd14) begin
		if(rom_clk == 1'b1) m_clk <= 1'b1;
		else m_clk <= 1'b0;
	end
	else m_clk <= 1'b0;
end
endmodule