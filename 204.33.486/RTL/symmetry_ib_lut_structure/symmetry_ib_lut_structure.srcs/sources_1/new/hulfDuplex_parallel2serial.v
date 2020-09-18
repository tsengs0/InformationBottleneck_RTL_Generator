`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2020 05:13:21 PM
// Design Name: 
// Module Name: hulfDuplex_parallel2serial
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
module hulfDuplex_parallel2serial #(
    parameter MSG_WIDTH = 4 // the default bit widith of one message is 4-bit
)(
    inout wire serial_inout,
    output wire [MSG_WIDTH-1:0] parallel_out,
    
    input wire [MSG_WIDTH-1:0] parallel_in,
    input wire load,
    input wire parallel_en,
    input wire sys_clk
    );
       
   wire [MSG_WIDTH-1:0] ff_source;
   wire [MSG_WIDTH-1:0] Q_out;
   assign ff_source[MSG_WIDTH-1:0] = (load)? parallel_in[MSG_WIDTH-1:0] : {Q_out[MSG_WIDTH-2:0], serial_inout};
   assign parallel_out[MSG_WIDTH-1:0] = Q_out[MSG_WIDTH-1:0];
   assign serial_inout = (parallel_en)? Q_out[MSG_WIDTH-1] : 1'bz;
   
   reg [MSG_WIDTH-1:0] d_ff;
    genvar i;
    generate
        for(i=0;i<MSG_WIDTH;i=i+1) begin: d_ff_inst
            always @(posedge sys_clk) begin
                d_ff[i] <= ff_source[i];
            end
            assign Q_out[i] = d_ff[i];  
        end
    endgenerate
endmodule