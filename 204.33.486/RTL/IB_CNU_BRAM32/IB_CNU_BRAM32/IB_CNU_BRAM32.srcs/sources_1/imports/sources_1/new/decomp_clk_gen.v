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
module decomp_clk_gen #(
    parameter RAM_DEPTH = 32
)(
    output reg m_clk,
    input wire en,
    input wire ram_clk
);

reg en_reg;
initial en_reg <= 1'b0;
always @(posedge ram_clk) en_reg <= en;

reg [4:0] cnt;
initial cnt[4:0] <= 5'd0;
always @(negedge ram_clk) begin
    if(en_reg == 1'b1) begin
        if(cnt[4:0] == RAM_DEPTH-1) cnt[4:0] <= 5'd0;
        else cnt[4:0] <= cnt[4:0] + 1'b1;
	end
end

initial m_clk <= 1'b0;
always @(negedge ram_clk) begin
	if(!en_reg) m_clk <= m_clk;
	//else if(cnt[4:0] == 5'd29)
	//	m_clk <= ~m_clk;
    else if(cnt[4:0] == RAM_DEPTH-2)
        m_clk <= 1'b1;
	else 
	    m_clk <= 1'b0;
end
endmodule
/*module decomp_clk_gen(
    output wire m_clk,
    input wire en,
    input wire ram_clk
);

reg [4:0] cnt = 5'b00000; // counting from 0 to 31
always @(posedge ram_clk) begin
    if(!en) 
	   cnt[4:0] <= cnt[4:0];
    else
        cnt[4:0] <= cnt[4:0] + 1'b1;
end

assign m_clk = (cnt[4:0] == 5'd1 && ram_clk == 1'b1) ? 1'b1 :
               (cnt[4:0] == 5'd1 && ram_clk == 1'b0) ? 1'b0 : 1'b0;
endmodule
*/