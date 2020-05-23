`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2020 06:25:34 PM
// Design Name: 
// Module Name: duplex_tb
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
module duplex_tb;

    parameter MSG_WIDTH = 4; // the default bit widith of one message is 4-bit
    
    wire interconnect;
    wire [MSG_WIDTH-1:0] parallel_out [0:1];
    reg [MSG_WIDTH-1:0] parallel_in [0:1];
    reg [1:0] parallel_en;
    reg [1:0] load;
    reg sys_clk;
    initial begin
        #0 sys_clk <= 1'b0;
        #10;
        forever #10 sys_clk <= ~sys_clk;
    end
    
    initial begin
        #0;
        load[0] <= 1'b0;
        load[1] <= 1'b0;
        
        #20;
        load[0] <= 1'b1;
        load[1] <= 1'b0;
        
        #20;
        load[0] <= 1'b0;
        load[1] <= 1'b0;
        
        #(20*4);
        load[0] <= 1'b0;
        load[1] <= 1'b1;
        
        #20;
        load[0] <= 1'b0;
        load[1] <= 1'b0;

        #(20*4);
        load[0] <= 1'b1;
        load[1] <= 1'b0;

        #20;
        load[0] <= 1'b0;
        load[1] <= 1'b0;

        #(20*4);
        load[0] <= 1'b0;
        load[1] <= 1'b1;
        
        #20;
        load[0] <= 1'b0;
        load[1] <= 1'b0;
    end
    
    initial begin
        #0;
        parallel_en[0] <= 1'b0;
        parallel_en[1] <= 1'b0;
        
        #20;
        parallel_en[0] <= 1'b1;
        parallel_en[1] <= 1'b0; 
        
        #100;
        parallel_en[0] <= 1'b0;
        parallel_en[1] <= 1'b1;
        
        #100;
        parallel_en[0] <= 1'b1;
        parallel_en[1] <= 1'b0; 
        
        #100;
        parallel_en[0] <= 1'b0;
        parallel_en[1] <= 1'b1;                               
 
         #100;
        parallel_en[0] <= 1'b0;
        parallel_en[1] <= 1'b0;
    end
    
    initial begin
        #10 parallel_in[0] <= 4'hA;
        #160 parallel_in[0] <= 4'hB;
    end
    
        
    initial begin
        #0 parallel_in[1] <= 4'h0;
        #90 parallel_in[1] <= 4'h5;
        #160 parallel_in[1] <= 4'h6;
    end
    
    hulfDuplex_parallel2serial dut0(
        .serial_inout (interconnect),
        .parallel_out (parallel_out[0]),
        
        .load (load[0]),
        .parallel_in (parallel_in[0]),
        .parallel_en (parallel_en[0]),
        .sys_clk (sys_clk)
    );
    hulfDuplex_parallel2serial dut1(
        .serial_inout (interconnect),
        .parallel_out (parallel_out[1]),
        
        .load (load[1]),
        .parallel_in (parallel_in[1]),
        .parallel_en (parallel_en[1]),
        .sys_clk (sys_clk)
    );
    
    reg [MSG_WIDTH-1:0] dut0_parallel_in;
    reg [MSG_WIDTH-1:0] dut1_parallel_in;
    always @(posedge sys_clk) begin
        dut0_parallel_in[MSG_WIDTH-1:0] <= parallel_out[0];
        dut1_parallel_in[MSG_WIDTH-1:0] <= parallel_out[1];
    end
    initial #440 $finish;
endmodule
