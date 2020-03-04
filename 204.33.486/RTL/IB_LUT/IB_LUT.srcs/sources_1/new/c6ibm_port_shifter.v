`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2020 11:26:26 PM
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
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module c6ibm_port_shifter(
    output reg [31:0] port_out,
    
    input wire [31:0] in_portA,
    input wire [31:0] in_portB,
    input wire [31:0] in_portC,
    
    input wire en,
    input wire ram_clk
);

reg [1:0] cnt = 2'b00;
always @(negedge ram_clk) begin
    if(!en) cnt[1:0] <= 2'b00;
    else cnt[1:0] <= cnt[1:0]+1'b1;
end

reg [95:0] ports_data = 96'd0;
always @(posedge ram_clk) begin
    if(!en) 
        ports_data[95:0] <= 96'd0;
    else if(cnt[1:0] == 2'b00) 
        ports_data[95:0] <= 96'd0;
    else if(cnt[1:0] == 2'b01) 
        ports_data[95:0] <= {in_portA[31:0], in_portB[31:0], in_portC[31:0]};
    else
        ports_data[95:0] <= {ports_data[63:0], 32'd0};
end

initial port_out[31:0] <= 32'd0;
always @(negedge ram_clk) begin
    if(!en)
        port_out[31:0] <= 32'd0;
    else if(cnt[1:0] == 2'b00)
        port_out[31:0] <= 32'd0;
    else
        port_out[31:0] <= ports_data[95:64];
end
endmodule