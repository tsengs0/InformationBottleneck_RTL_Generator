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
`include "define.v"

module cnu_ib_lut_ram;

wire [`IB_ROM_SIZE-1:0] entry_set_9[0:1];        
wire [`IB_ROM_ADDR_WIDTH-1:0] entry_set_addr[0:1];
reg rst; 
reg sys_clk;  
wire [`QUAN_SIZE-1:0] bank_portA[0:7]; 
wire [`QUAN_SIZE-1:0] bank_portB[0:7];  
wire [`QUAN_SIZE-1:0] bank_portC[0:7];  
wire [`QUAN_SIZE-1:0] bank_portD[0:7];                   
    
IB_RAM_wrapper RAMB36E1_0 (
    .BRAM_PORTA_0_dout (entry_set_9[0]),
    .BRAM_PORTB_0_dout (entry_set_9[1]), 
    
    .BRAM_PORTA_0_addr (entry_set_addr[0]),
    .BRAM_PORTA_0_clk (sys_clk),
    .BRAM_PORTA_0_din ({36{1'bx}}),
    .BRAM_PORTA_0_we ((1'b0)),
     
    .BRAM_PORTB_0_addr (entry_set_addr[1]),
    .BRAM_PORTB_0_clk(sys_clk),
    .BRAM_PORTB_0_din({36{1'bx}}),
    .BRAM_PORTB_0_we (1'b0)
  );
  
cnu6_ib_map ib_map_0(
	.bank0_portA (bank_portA[0]),
	.bank0_portB (bank_portB[0]),
	.bank0_portC (bank_portC[0]),
	.bank0_portD (bank_portD[0]),

	.bank1_portA (bank_portA[1]),
	.bank1_portB (bank_portB[1]),
	.bank1_portC (bank_portC[1]),
	.bank1_portD (bank_portD[1]),

	.bank2_portA (bank_portA[2]),
	.bank2_portB (bank_portB[2]),
	.bank2_portC (bank_portC[2]),
	.bank2_portD (bank_portD[2]),

	.bank3_portA (bank_portA[3]),
	.bank3_portB (bank_portB[3]),
	.bank3_portC (bank_portC[3]),
	.bank3_portD (bank_portD[3]),

	.bank4_portA (bank_portA[4]),
	.bank4_portB (bank_portB[4]),
	.bank4_portC (bank_portC[4]),
	.bank4_portD (bank_portD[4]),

	.bank5_portA (bank_portA[5]),
	.bank5_portB (bank_portB[5]),
	.bank5_portC (bank_portC[5]),
	.bank5_portD (bank_portD[5]),

	.bank6_portA (bank_portA[6]),
	.bank6_portB (bank_portB[6]),
	.bank6_portC (bank_portC[6]),
	.bank6_portD (bank_portD[6]),

	.bank7_portA (bank_portA[7]),
	.bank7_portB (bank_portB[7]),
	.bank7_portC (bank_portC[7]),
	.bank7_portD (bank_portD[7]),

	.rom_read_addrA (entry_set_addr[0]),
	.rom_read_addrB (entry_set_addr[1]),

	.rom_readA (entry_set_9[0]),
	.rom_readB (entry_set_9[1]),
	.sys_clk (sys_clk),
	.rstn    (rstn)
);

integer f0, f1;
initial begin
    f0 = $fopen("ib_map_bank0_7.csv", "w");
end

initial begin
    #0;
    sys_clk <= 0;
    
    #100;
    forever #10 sys_clk <= ~sys_clk;
end

initial begin
    #0
    rst <= 1'b0;
    
    #100
    rst <= 1'b1; 
end

integer i;
initial begin    
    #100;
    for(i=0;i<114;i=i+1) begin
       #20;
       //$display("%h,%h,%h,%h\n", bank_portA[0], bank_portB[0], bank_portC[0], bank_portD[0]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[0], bank_portB[0], bank_portC[0], bank_portD[0]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[1], bank_portB[1], bank_portC[1], bank_portD[1]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[2], bank_portB[2], bank_portC[2], bank_portD[2]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[3], bank_portB[3], bank_portC[3], bank_portD[3]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[4], bank_portB[4], bank_portC[4], bank_portD[4]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[5], bank_portB[5], bank_portC[5], bank_portD[5]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[6], bank_portB[6], bank_portC[6], bank_portD[6]);
       $fwrite(f0, "%h,%h,%h,%h\n", bank_portA[7], bank_portB[7], bank_portC[7], bank_portD[7]);
    end
    $fclose(f0); $fclose(f1);
end

initial #(100+20*114+50) $finish;
   
endmodule
