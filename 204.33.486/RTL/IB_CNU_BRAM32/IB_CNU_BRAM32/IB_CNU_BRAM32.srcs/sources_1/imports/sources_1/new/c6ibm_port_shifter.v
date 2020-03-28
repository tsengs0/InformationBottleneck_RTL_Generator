`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 7th March, 2020 PM8:48
// Design Name: 
// Module Name: c6ibm_port_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 1.3
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module c6ibm_port_shifter(
    output reg [31:0] port_out,
    
    input wire [31:0] in_portA,
    input wire [31:0] in_portB,
    
    input wire en,
    input wire ram_clk
);

/*
reg en_reg;
initial en_reg <= 1'b0;
always @(posedge ram_clk) en_reg <= en;
*/
reg cnt;
initial cnt <= 1'b0;
always @(negedge ram_clk) begin
    if(!en) cnt <= 1'b0;
	else cnt <= cnt+1'b1;
end

reg [63:0] ports_data = 64'd0;
always @(posedge ram_clk) begin
    if(!en) 
	ports_data[63:0] <= 64'd0;
    else if(cnt == 1'b0) 
        ports_data[63:0] <= {in_portA[31:0], in_portB[31:0]};
    else begin
	   ports_data[63:32] <= ports_data[31: 0];
	   ports_data[31: 0] <= in_portA[31:0];
    end
end

initial port_out[31:0] <= 32'd0;
always @(negedge ram_clk) begin
    if(!en) 
	port_out[31:0] <= 32'd0;
    else
        port_out[31:0] <= ports_data[63:32];
end
endmodule