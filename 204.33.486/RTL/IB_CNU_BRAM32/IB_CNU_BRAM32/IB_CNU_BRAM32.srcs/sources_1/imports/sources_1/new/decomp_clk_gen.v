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
    input wire ram_clk
);

reg [4:0] cnt = 5'b00000; // counting from 0 to 31
always @(posedge ram_clk) begin
    if(!en) 
	   cnt[4:0] <= cnt[4:0];
    else
        cnt[4:0] <= cnt[4:0] + 1'b1;
end

initial m_clk <= 1'b0;
always @(posedge ram_clk) begin
	if(!en) m_clk <= 1'b0;
	else if(cnt[4:0] == 5'd29)
		m_clk <= ~m_clk;
    else if(cnt[4:0] == 5'd30)
        m_clk <= ~m_clk;
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