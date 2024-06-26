`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 11:40:19 PM
// Design Name: 
// Module Name: top
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
`include "define.v"
module top;
wire [`QUAN_SIZE-1:0] t_c;

wire [`QUAN_SIZE-1:0] t_c_0;
wire [`QUAN_SIZE-1:0] t_c_1;
wire [`QUAN_SIZE-1:0] t_c_2;
wire [`QUAN_SIZE-1:0] t_c_3;
reg [`QUAN_SIZE-1:0] y0;
reg [`QUAN_SIZE-1:0] y1;
reg [`QUAN_SIZE-1:0] y2;
reg [`QUAN_SIZE-1:0] y3;
reg [`QUAN_SIZE-1:0] y4;
reg sys_clk_n;
reg sys_clk_p;   
// For testbench
initial begin
    #0;
    sys_clk_n <= 1'b1;
    sys_clk_p <= 1'b0;
    // To generate 200MHz system clock
    forever #2.5 {sys_clk_n, sys_clk_p} <= {~sys_clk_n, ~sys_clk_p};
end
reg rstn_cnu_fsm, iter_rqst, iter_termination;
wire ram_write_en, iter_update, c6ib_rom_rst;
wire [2:0] state;
cnu6ib_control_unit control_unit (
    .ram_write_en (ram_write_en),
    .iter_update  (iter_update),
    .c6ib_rom_rst (c6ib_rom_rst),
    .state (state[2:0]),
    
    .sys_clk (ram_clk),
    .rstn (rstn_cnu_fsm),
    .iter_rqst (iter_rqst),
    .iter_termination (iter_termination)
);

// Clock Domain
wire ram_clk, rom_clk, mmcm_nlocked;
wire [1:0] clk_gate; 
clock_domain_wrapper clock_domain_0(
    .clk_out1_0 (clk_gate[1]),
    .clk_out2_0 (clk_gate[0]),
    .locked_0 (mmcm_nlocked),
    
    .reset (1'b0),
    .sys_diff_clock_clk_n (sys_clk_n),
    .sys_diff_clock_clk_p (sys_clk_p)
);
assign {ram_clk, rom_clk} = {clk_gate[1] & mmcm_nlocked, clk_gate[0] & mmcm_nlocked};

// Decomposition Clock Generator
wire m_clk; // 20MHz
decomp_clk_gen decomp_clk_gen_0 (
	.m_clk   (m_clk),
	.en      (ram_write_en),
	.rom_clk (rom_clk)
);

// Configuration of IB-LUT ROM
wire [`IB_ROM_SIZE-1:0] entry_set_9[0:1];        
wire [`IB_ROM_ADDR_WIDTH-1:0] entry_set_addr[0:1];
IB_RAM_wrapper RAMB36E1_0 (
    .BRAM_PORTA_0_dout (entry_set_9[0]),
    .BRAM_PORTB_0_dout (entry_set_9[1]), 
    
    .BRAM_PORTA_0_addr (entry_set_addr[0]),
    .BRAM_PORTA_0_clk (rom_clk),
    .BRAM_PORTA_0_din ({36{1'bx}}),
    .BRAM_PORTA_0_we ((1'b0)),
     
    .BRAM_PORTB_0_addr (entry_set_addr[1]),
    .BRAM_PORTB_0_clk(rom_clk),
    .BRAM_PORTB_0_din({36{1'bx}}),
    .BRAM_PORTB_0_we (1'b0)
  );
  
wire [`QUAN_SIZE-1:0] bank_portA[0:7]; 
wire [`QUAN_SIZE-1:0] bank_portB[0:7];  
wire [`QUAN_SIZE-1:0] bank_portC[0:7];  
//wire [`QUAN_SIZE-1:0] bank_portD[0:7]; 
cnu6_ib_map ib_map_0(
	.bank0_portA (bank_portA[0]),
	.bank0_portB (bank_portB[0]),
	.bank0_portC (bank_portC[0]),
	//.bank0_portD (bank_portD[0]),

	.bank1_portA (bank_portA[1]),
	.bank1_portB (bank_portB[1]),
	.bank1_portC (bank_portC[1]),
	//.bank1_portD (bank_portD[1]),

	.bank2_portA (bank_portA[2]),
	.bank2_portB (bank_portB[2]),
	.bank2_portC (bank_portC[2]),
	//.bank2_portD (bank_portD[2]),

	.bank3_portA (bank_portA[3]),
	.bank3_portB (bank_portB[3]),
	.bank3_portC (bank_portC[3]),
	//.bank3_portD (bank_portD[3]),

	.bank4_portA (bank_portA[4]),
	.bank4_portB (bank_portB[4]),
	.bank4_portC (bank_portC[4]),
	//.bank4_portD (bank_portD[4]),

	.bank5_portA (bank_portA[5]),
	.bank5_portB (bank_portB[5]),
	.bank5_portC (bank_portC[5]),
	//.bank5_portD (bank_portD[5]),

	.bank6_portA (bank_portA[6]),
	.bank6_portB (bank_portB[6]),
	.bank6_portC (bank_portC[6]),
	//.bank6_portD (bank_portD[6]),

	.bank7_portA (bank_portA[7]),
	.bank7_portB (bank_portB[7]),
	.bank7_portC (bank_portC[7]),
	//.bank7_portD (bank_portD[7]),
	//.port_shifter (port_shifter[3:0]),

	.rom_read_addrA (entry_set_addr[0]),
	.rom_read_addrB (entry_set_addr[1]),

	.rom_readA (entry_set_9[0]),
	.rom_readB (entry_set_9[1]),
	.sys_clk (rom_clk),
	.rstn    (ram_write_en)
);

// MUX following (datapath) the output of CNU-IB Map and input
wire [31:0] interBank_write_data;
c6ibm_port_shifter c6ibm_port_shifter_0(
    .port_out (interBank_write_data[31:0]),
    
    .in_portA ({bank_portA[0], bank_portA[1], bank_portA[2], bank_portA[3], bank_portA[4], bank_portA[5], bank_portA[6], bank_portA[7]}),
    .in_portB ({bank_portB[0], bank_portB[1], bank_portB[2], bank_portB[3], bank_portB[4], bank_portB[5], bank_portB[6], bank_portB[7]}),
    .in_portC ({bank_portC[0], bank_portC[1], bank_portC[2], bank_portC[3], bank_portC[4], bank_portC[5], bank_portC[6], bank_portC[7]}),
    
    .en (ram_write_en),
    .ram_clk (ram_clk)
);

// RAM-Seletor Counter to decide the destination of page data
wire [1:0] ram_sel;
ram_sel_counter ram_sel_cnt_0(
	.ram_sel (ram_sel[1:0]),
	.en      (ram_write_en),
	.m_clk   (m_clk)
);

// DEMUX following (datapath) the output of MUX abov
// The interleaving-bank data[#Bank*QUAN_SIZE-1:0] is forwarded to one of CNU-IB RAM x, x in {0, 1, 2, 3}
wire [31:0] ram_write_data [0:3];
c6ibwr_ram_sel c6ibwr_ram_sel_0 (
    .interBank_data_ram0 (ram_write_data[0]),
    .interBank_data_ram1 (ram_write_data[1]),
    .interBank_data_ram2 (ram_write_data[2]),
    .interBank_data_ram3 (ram_write_data[3]),
    
    .interBank_write_data (interBank_write_data[31:0]),
    .ram_sel (ram_sel[1:0])
);

// Configuration of IB-LUT RAM
wire [`QUAN_SIZE-1:0] t_portA[0:3]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portB[0:3]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portC[0:3]; // internal signals accounting for each 256-entry partial LUT's output
wire [`QUAN_SIZE-1:0] t_portD[0:3]; // internal signals accounting for each 256-entry partial LUT's output
wire [4:0] ib_ram_addr[0:3];
wire [2:0] bank_read_sel[0:3];
reconf_ib_lut2 func_0(
     .ib_ram_page_addr (ib_ram_addr[0]  ),
     .ib_ram_bank_addr (bank_read_sel[0]),
    
     .y1 (y1[`QUAN_SIZE-1:0]),
     .y0 (y0[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_1(
     .ib_ram_page_addr (ib_ram_addr[1]  ),
     .ib_ram_bank_addr (bank_read_sel[1]),
    
     .y1 (t_portA[0]),
     .y0 (y2[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_2(
     .ib_ram_page_addr (ib_ram_addr[2]  ),
     .ib_ram_bank_addr (bank_read_sel[2]),
    
     .y1 (t_portA[1]),
     .y0 (y3[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_3(
     .ib_ram_page_addr (ib_ram_addr[3]  ),
     .ib_ram_bank_addr (bank_read_sel[3]),
    
     .y1 (t_portA[2]),
     .y0 (y4[`QUAN_SIZE-1:0])
);

wire [4:0] page_addr_ram0; 
wire [4:0] page_addr_ram1; 
wire [4:0] page_addr_ram2;
wire [4:0] page_addr_ram3; 
c6ibAddr_ram_sel ram_write_addr_gate (
	.page_addr_ram0 (page_addr_ram0[4:0]), 
	.page_addr_ram1 (page_addr_ram1[4:0]), 
	.page_addr_ram2 (page_addr_ram2[4:0]), 
	.page_addr_ram3 (page_addr_ram3[4:0]), 

	.en      (ram_write_en),
	.ram_sel (ram_sel[1:0]), 
	.ram_clk (ram_clk) 
);

ib_lut_ram func_ram_0(
    .t_c_A (t_portA[0]), // For first reader  (A)    
    .t_c_B (t_portB[0]), // For second reader (B) 
    .t_c_C (t_portC[0]), // For third reader  (C)  
    .t_c_D (t_portD[0]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[0]),// page address across 32 pages
    .addr_readB (ib_ram_addr[0]),// page address across 32 pages
    .addr_readC (ib_ram_addr[0]),// page address across 32 pages
    .addr_readD (ib_ram_addr[0]),// page address across 32 pages
    .bank_readA (bank_read_sel[0]), // bank address across 8 banks
    .bank_readB (bank_read_sel[0]), // bank address across 8 banks
    .bank_readC (bank_read_sel[0]), // bank address across 8 banks
    .bank_readD (bank_read_sel[0]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram0[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data[0][31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data[0][27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data[0][23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data[0][19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data[0][15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data[0][11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data[0][7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data[0][3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ram_write_en),
    .sys_clk (ram_clk)
);

ib_lut_ram func_ram_1(
    .t_c_A (t_portA[1]), // For first reader  (A)    
    .t_c_B (t_portB[1]), // For second reader (B) 
    .t_c_C (t_portC[1]), // For third reader  (C)  
    .t_c_D (t_portD[1]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[1]),// page address across 32 pages
    .addr_readB (ib_ram_addr[1]),// page address across 32 pages
    .addr_readC (ib_ram_addr[1]),// page address across 32 pages
    .addr_readD (ib_ram_addr[1]),// page address across 32 pages
    .bank_readA (bank_read_sel[1]), // bank address across 8 banks
    .bank_readB (bank_read_sel[1]), // bank address across 8 banks
    .bank_readC (bank_read_sel[1]), // bank address across 8 banks
    .bank_readD (bank_read_sel[1]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram1[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data[1][31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data[1][27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data[1][23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data[1][19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data[1][15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data[1][11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data[1][7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data[1][3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ram_write_en),
    .sys_clk (ram_clk)
);

ib_lut_ram func_ram_2(
    .t_c_A (t_portA[2]), // For first reader  (A)    
    .t_c_B (t_portB[2]), // For second reader (B) 
    .t_c_C (t_portC[2]), // For third reader  (C)  
    .t_c_D (t_portD[2]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[2]),// page address across 32 pages
    .addr_readB (ib_ram_addr[2]),// page address across 32 pages
    .addr_readC (ib_ram_addr[2]),// page address across 32 pages
    .addr_readD (ib_ram_addr[2]),// page address across 32 pages
    .bank_readA (bank_read_sel[2]), // bank address across 8 banks
    .bank_readB (bank_read_sel[2]), // bank address across 8 banks
    .bank_readC (bank_read_sel[2]), // bank address across 8 banks
    .bank_readD (bank_read_sel[2]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram2[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data[2][31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data[2][27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data[2][23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data[2][19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data[2][15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data[2][11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data[2][7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data[2][3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ram_write_en),
    .sys_clk (ram_clk)
);

ib_lut_ram func_ram_3(
    .t_c_A (t_portA[3]), // For first reader  (A)    
    .t_c_B (t_portB[3]), // For second reader (B) 
    .t_c_C (t_portC[3]), // For third reader  (C)  
    .t_c_D (t_portD[3]), // For fourth reader (D)
    
    // For Read-related address buses
    .addr_readA (ib_ram_addr[3]),// page address across 32 pages
    .addr_readB (ib_ram_addr[3]),// page address across 32 pages
    .addr_readC (ib_ram_addr[3]),// page address across 32 pages
    .addr_readD (ib_ram_addr[3]),// page address across 32 pages
    .bank_readA (bank_read_sel[3]), // bank address across 8 banks
    .bank_readB (bank_read_sel[3]), // bank address across 8 banks
    .bank_readC (bank_read_sel[3]), // bank address across 8 banks
    .bank_readD (bank_read_sel[3]), // bank address across 8 banks
    
    // Write Port Addresses
    .page_addr_write (page_addr_ram3[4:0]), // All 8 banks are synchronously updated in the same page 

    // Write Qual-port    
    .bank_data_write0 (ram_write_data[3][31:28]), // Same bank of all 4 ports are written same page data
    .bank_data_write1 (ram_write_data[3][27:24]), // Same bank of all 4 ports are written same page data
    .bank_data_write2 (ram_write_data[3][23:20]), // Same bank of all 4 ports are written same page data
    .bank_data_write3 (ram_write_data[3][19:16]), // Same bank of all 4 ports are written same page data
    .bank_data_write4 (ram_write_data[3][15:12]), // Same bank of all 4 ports are written same page data
    .bank_data_write5 (ram_write_data[3][11:8] ), // Same bank of all 4 ports are written same page data
    .bank_data_write6 (ram_write_data[3][7:4]  ), // Same bank of all 4 ports are written same page data
    .bank_data_write7 (ram_write_data[3][3:0]  ), // Same bank of all 4 ports are written same page data       
    
    .write_en (ram_write_en),
    .sys_clk (ram_clk)
);
assign t_c_0[`QUAN_SIZE-1:0] = t_portA[3];
assign t_c_1[`QUAN_SIZE-1:0] = t_portA[3];
assign t_c_2[`QUAN_SIZE-1:0] = t_portA[3];
assign t_c_3[`QUAN_SIZE-1:0] = t_portA[3];
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
integer f0;
initial begin
    f0 = $fopen("ib_map_bank0_7.csv", "w");
end

integer i;
initial begin    
    #105;
    
    for(i=0;i<114;i=i+1) begin
       #20;
       //$display("%h,%h,%h,%h\n", bank_portA[0], bank_portB[0], bank_portC[0], bank_portD[0]);
       $fwrite(f0, "%h,%h,%h,%h,%h,%h,%h,%h\n", bank_portA[0], bank_portA[1], bank_portA[2], bank_portA[3], bank_portA[4], bank_portA[5], bank_portA[6], bank_portA[7]);
       $fwrite(f0, "%h,%h,%h,%h,%h,%h,%h,%h\n", bank_portB[0], bank_portB[1], bank_portB[2], bank_portB[3], bank_portB[4], bank_portB[5], bank_portB[6], bank_portB[7]);
       $fwrite(f0, "%h,%h,%h,%h,%h,%h,%h,%h\n", bank_portC[0], bank_portC[1], bank_portC[2], bank_portC[3], bank_portC[4], bank_portC[5], bank_portC[6], bank_portC[7]);
       //$fwrite(f0, "%h,%h,%h,%h,%h,%h,%h,%h\n\n", bank_portD[0], bank_portD[1], bank_portD[2], bank_portD[3], bank_portD[4], bank_portD[5], bank_portD[6], bank_portD[7]);
    end
    $fclose(f0);
end
*/
/*
initial begin
	#0;
	en <= 1'b0;
	//{in_portA, in_portB, in_portC} <= 96'd0;

	#(2.5*3);
	{in_portA, in_portB, in_portC} <= {32'd1, 32'd2, 32'd3};

	#(2.5*2);
	en <= 1'b1;
	
	//forever #(20*3) {in_portA, in_portB, in_portC} <= {in_portA+1, in_portB+1, in_portC+1};
end
*/
initial begin
	#0;
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b000;

	#2.5;
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b110;

	#(7.5+5*3*60);
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b001;
end
initial #(7.5+2.5+5*3*60+5) $finish;
endmodule
