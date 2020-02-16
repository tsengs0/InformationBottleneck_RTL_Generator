`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 11:06:56 PM
// Design Name: 
// Module Name: cnu_ib_lut_ram
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
`timescale 1 ns / 1 ps
//`include "define.v"

module cnu_ib_lut_ram;

reg sys_clk;

wire [1023:0] func_m[0:1];        
reg [31:0] func_addr[0:1];
reg rst;                   
    
IB_RAM_wrapper u0(
    .BRAM_PORTA_0_addr  (func_addr[0]),
    .BRAM_PORTA_0_clk   (sys_clk),
    .BRAM_PORTA_0_din   (1024'd0),
    .BRAM_PORTA_0_dout  (func_m[0]),
    .BRAM_PORTA_0_en    (1'b1),
    .BRAM_PORTA_0_rst   (rst),
    .BRAM_PORTA_0_we    (1024'd0),
    
    .BRAM_PORTB_0_addr  (func_addr[1]),
    .BRAM_PORTB_0_clk   (sys_clk),
    .BRAM_PORTB_0_din   (1024'd0),
    .BRAM_PORTB_0_dout  (func_m[1]),
    .BRAM_PORTB_0_en    (1'b1),
    .BRAM_PORTB_0_rst   (rst),
    .BRAM_PORTB_0_we    (1024'd0)
);

integer f;
initial f = $fopen("bram_readout.txt", "w");

initial begin
    #0;
    sys_clk <= 0;
    
    #100;
    forever #10 sys_clk <= ~sys_clk;
end

initial begin
    #0
    rst <= 1'b1;
    
    #100
    rst <= 1'b0; 
end

integer i;
initial begin
    #0;
    func_addr[0] <= 32'd0;
    func_addr[1] <= 32'd0;
    
    #100;
    for(i=0;i<10;i=i+1) begin
       #20;
       func_addr[0] <= func_addr[0] + 32'd128;
       func_addr[1] <= func_addr[1] + 32'd128;
       $fwrite(f, "Address: %d\n%h\n\n", func_addr[0], func_m[0]);
    end
    $fclose(f);
end

initial #500000 $finish;
   
endmodule
