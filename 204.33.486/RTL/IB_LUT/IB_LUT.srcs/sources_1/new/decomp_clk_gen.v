`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2020 09:18:18 PM
// Design Name: 
// Module Name: decom_clk_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  Generating a clock source where the clock rate is 15 times lower than the clock rate of ram_clk
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module decomp_clk_gen(
    input wire ram_clk,
    output wire m_clk
);

reg [3:0] cnt = 4'b0000; // counting from 0 to 14
always @(posedge ram_clk) begin
    if(cnt[3:0] == 4'd14)
        cnt[3:0] <= 4'b0000;
    else
        cnt[3:0] <= cnt[3:0] + 1'b1;
end
assign m_clk = (cnt[3:0] == 4'd0) ? ram_clk : 1'b0;
endmodule
