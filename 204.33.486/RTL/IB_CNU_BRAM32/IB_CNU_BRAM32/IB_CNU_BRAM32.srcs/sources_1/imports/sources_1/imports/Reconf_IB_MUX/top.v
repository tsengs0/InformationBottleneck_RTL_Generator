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
reg CLK_300_N;
reg CLK_300_P;   
// For testbench
initial begin
    #0;
    CLK_300_N <= 1'b1;
    CLK_300_P <= 1'b0;
    // To generate 300MHz system clock
    forever #1.667 {CLK_300_N, CLK_300_P} <= {~CLK_300_N, ~CLK_300_P};
end
reg rstn_cnu_fsm, iter_rqst, iter_termination, pipeline_en;
wire rom_port_fetch, ram_mux_en, ram_write_en, iter_update, c6ib_rom_rst;
wire [2:0] state;
cnu6ib_control_unit control_unit (
    .rom_port_fetch (rom_port_fetch),
    .ram_mux_en   (ram_mux_en),
    .ram_write_en (ram_write_en),
    .iter_update  (iter_update),
    .c6ib_rom_rst (c6ib_rom_rst),
    .state (state[2:0]),
    
    .sys_clk (ram_clk),
    .rstn (rstn_cnu_fsm),
    .iter_rqst (iter_rqst),
    .iter_termination (iter_termination),
    .pipeline_en (pipeline_en)
);

// Clock Domain
wire ram_clk, rom_clk, mmcm_nlocked;
wire [1:0] clk_gate; 
clock_domain_wrapper clock_domain_0(
    .clk_out1_0 (clk_gate[1]),
    .clk_out2_0 (clk_gate[0]),
    .locked_0 (mmcm_nlocked),
    
    .reset (1'b0),
    .clk_300mhz_clk_n (CLK_300_N),
    .clk_300mhz_clk_p (CLK_300_P)
);
assign {ram_clk, rom_clk} = {clk_gate[1] & mmcm_nlocked, clk_gate[0] & mmcm_nlocked};

// Decomposition Clock Generator
wire m_clk; // 9.3750 MHz
decomp_clk_gen #(.RAM_DEPTH(`IB_ROM_SIZE)) decomp_clk_gen_0 (
	.m_clk   (m_clk),
	.en      (ram_write_en),
	.ram_clk (ram_clk)
);

// Configuration of IB-LUT ROM
wire [`IB_ROM_SIZE-1:0] entry_set_8[0:1];        
wire [`IB_ROM_ADDR_WIDTH-1:0] entry_set_addr[0:1];
IB_RAM_wrapper IB_CNU_ROM32 (
    .BRAM_PORTA_0_dout (entry_set_8[0]),
    .BRAM_PORTB_0_dout (entry_set_8[1]), 
    
    .BRAM_PORTA_0_addr (entry_set_addr[0]),
    .BRAM_PORTA_0_clk (rom_clk),
     
    .BRAM_PORTB_0_addr (entry_set_addr[1]),
    .BRAM_PORTB_0_clk(rom_clk)
  );
   
wire [`QUAN_SIZE-1:0] bank_portA[0:7]; 
wire [`QUAN_SIZE-1:0] bank_portB[0:7];  
cnu6_ib_map ib_map_0(
	.bank0_portA (bank_portA[0]),
	.bank0_portB (bank_portB[0]),

	.bank1_portA (bank_portA[1]),
	.bank1_portB (bank_portB[1]),

	.bank2_portA (bank_portA[2]),
	.bank2_portB (bank_portB[2]),

	.bank3_portA (bank_portA[3]),
	.bank3_portB (bank_portB[3]),

	.bank4_portA (bank_portA[4]),
	.bank4_portB (bank_portB[4]),

	.bank5_portA (bank_portA[5]),
	.bank5_portB (bank_portB[5]),

	.bank6_portA (bank_portA[6]),
	.bank6_portB (bank_portB[6]),

	.bank7_portA (bank_portA[7]),
	.bank7_portB (bank_portB[7]),

	.rom_read_addrA (entry_set_addr[0]),
	.rom_read_addrB (entry_set_addr[1]),

	.rom_readA (entry_set_8[0]),
	.rom_readB (entry_set_8[1]),
	.sys_clk (rom_clk),
	.rstn    (rom_port_fetch)
);

// MUX following (datapath) the output of CNU-IB Map and input
wire [31:0] interBank_write_data;
c6ibm_port_shifter c6ibm_port_shifter_0(
    .port_out (interBank_write_data[31:0]),
    
    .in_portA ({bank_portA[0], bank_portA[1], bank_portA[2], bank_portA[3], bank_portA[4], bank_portA[5], bank_portA[6], bank_portA[7]}),
    .in_portB ({bank_portB[0], bank_portB[1], bank_portB[2], bank_portB[3], bank_portB[4], bank_portB[5], bank_portB[6], bank_portB[7]}),

    .en (ram_mux_en),
    .ram_clk (ram_clk)
);

// RAM-Seletor Counter to decide the destination of page data
wire [1:0] ram_sel;
ram_sel_counter ram_sel_cnt_0(
	.ram_sel (ram_sel[1:0]),
	.en      (rom_port_fetch),
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
reg [31:0] ram_write_data_latch [0:3];
always @(negedge ram_clk) begin
    ram_write_data_latch[0] <= ram_write_data[0];
    ram_write_data_latch[1] <= ram_write_data[1];
    ram_write_data_latch[2] <= ram_write_data[2];
    ram_write_data_latch[3] <= ram_write_data[3];
end

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
    
     .y1 (y0[`QUAN_SIZE-1:0]),
     .y0 (y1[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_1(
     .ib_ram_page_addr (ib_ram_addr[1]  ),
     .ib_ram_bank_addr (bank_read_sel[1]),
    
     .y1 (y0[`QUAN_SIZE-1:0]),//(t_portA[0]),
     .y0 (y1[`QUAN_SIZE-1:0])//(y2[`QUAN_SIZE-1:0])
);

reconf_ib_lut2 func_2(
     .ib_ram_page_addr (ib_ram_addr[2]  ),
     .ib_ram_bank_addr (bank_read_sel[2]),
    
     .y1 (y0[`QUAN_SIZE-1:0]),//(t_portA[1]),
     .y0 (y1[`QUAN_SIZE-1:0])//(y3[`QUAN_SIZE-1:0])
);

reg [`QUAN_SIZE-1:0] a[0:1];
reconf_ib_lut2 func_3(
     .ib_ram_page_addr (ib_ram_addr[3]  ),
     .ib_ram_bank_addr (bank_read_sel[3]),
    
     .y1 (y0[`QUAN_SIZE-1:0]),//(t_portA[2]),
     .y0 (y1[`QUAN_SIZE-1:0])//(y4[`QUAN_SIZE-1:0])
);

wire [4:0] page_addr_ram0; 
wire [4:0] page_addr_ram1; 
wire [4:0] page_addr_ram2;
wire [4:0] page_addr_ram3; 
wire [`IB_CNU_DECOMP_funNum-1:0] ib_ram_we;
c6ibAddr_ram_sel #(
    .RAM_DEPTH(`IB_ROM_SIZE), 
    .RAM_NUM(`IB_CNU_DECOMP_funNum)
) ram_write_addr_gate (
	.page_addr_ram0 (page_addr_ram0[4:0]), 
	.page_addr_ram1 (page_addr_ram1[4:0]), 
	.page_addr_ram2 (page_addr_ram2[4:0]), 
	.page_addr_ram3 (page_addr_ram3[4:0]), 
	.we (ib_ram_we[`IB_CNU_DECOMP_funNum-1:0]),

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
    
    .write_en (ib_ram_we[0]),
    .sys_clk (~ram_clk)
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
    
    .write_en (ib_ram_we[1]),
    .sys_clk (~ram_clk)
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
    
    .write_en (ib_ram_we[2]),
    .sys_clk (~ram_clk)
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
    
    .write_en (ib_ram_we[3]),
    .sys_clk (~ram_clk)
);
assign t_c_0[`QUAN_SIZE-1:0] = t_portA[0];
assign t_c_1[`QUAN_SIZE-1:0] = t_portA[1];
assign t_c_2[`QUAN_SIZE-1:0] = t_portA[2];
assign t_c_3[`QUAN_SIZE-1:0] = t_portA[3];
assign t_c[`QUAN_SIZE-1:0] = t_c_3[`QUAN_SIZE-1:0];
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg update_finish;
reg [7:0] write_cnt;
initial begin
    #0;
 	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b000;
	update_finish  <= 1'b0; 
	pipeline_en <= 1'b0;
	write_cnt[7:0] <= 8'd0;   
end
always @(posedge ram_clk) begin
    if(write_cnt < `ITER_WRITE_PAGE_NUM) begin
        {rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b110; 
        update_finish <= 1'b0;
    end
    else if(write_cnt == `ITER_WRITE_PAGE_NUM) begin
        {rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b001; 
        update_finish <= 1'b1;
        $fclose(f0);
    end
    else 
       {rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b000; 
end
always @(negedge ram_clk) begin
    if(state[2:0] == 3'd2 || state[2:0] == 3'd4)
        if(write_cnt <= `ITER_WRITE_PAGE_NUM+1)
            write_cnt[7:0] <= write_cnt[7:0] + 1'b1;
        else
            write_cnt[7:0] <= write_cnt[7:0];
    else
        write_cnt[7:0] <= write_cnt[7:0];
end

initial pipeline_en <= 1'b0;
always @(negedge ram_clk) begin
    if(state[2:0] == 3'd1) pipeline_en <= 1'b1;
    else pipeline_en <= pipeline_en;
end

integer f0;
initial begin
    f0 = $fopen("cnu_ram_dataIn.csv", "w");
end
always @(negedge ram_clk) begin
    if(state[2:0] == 3'd2 || state[2:0] == 3'd4) begin
        $fwrite(f0, "%h,%h,%h,%h,%h,%h,%h,%h\n", ram_write_data[ram_sel[1:0]][31:28],
                        ram_write_data[ram_sel[1:0]][27:24],
                        ram_write_data[ram_sel[1:0]][23:20],
                        ram_write_data[ram_sel[1:0]][19:16],
                        ram_write_data[ram_sel[1:0]][15:12],
                        ram_write_data[ram_sel[1:0]][11:8],
                        ram_write_data[ram_sel[1:0]][7:4],
                        ram_write_data[ram_sel[1:0]][3:0]
        );      
    end
end

initial begin
    #0;
    y0 <= 0;
    y1 <= 0;
    y2 <= 0;
    y3 <= 0;
    y4 <= 0;
end
always @(posedge ram_clk) begin
    if({ram_write_en, iter_update, c6ib_rom_rst} == 3'b001 && update_finish == 1'b1) begin 
        y0 <= y0 + 1;
        y1 <= y1 + &y0;
        y2 <= y2 + &y1;
        y3 <= y3 + &y2;
        y4 <= y4 + &y3;
    end
end

integer f1, f2, f3, f4;
initial begin
    f1 = $fopen("f0.csv", "w");
    f2 = $fopen("f1.csv", "w");
    f3 = $fopen("f2.csv", "w");
    f4 = $fopen("f3.csv", "w");
end

always @(posedge ram_clk) begin
    if(update_finish == 1'b1) begin
        if({y1, y0} != 8'hff) begin
            $fwrite(f1, "%h,%h,%h\n", y1, y0, t_c_0);
            $fwrite(f2, "%h,%h,%h\n", y1, y0, t_c_1);
            $fwrite(f3, "%h,%h,%h\n", y1, y0, t_c_2);
            $fwrite(f4, "%h,%h,%h\n", y1, y0, t_c_3); 
        end
        else if({y1, y0} == 8'hff) begin
            $fwrite(f1, "%h,%h,%h", y1, y0, t_c_0);
            $fwrite(f2, "%h,%h,%h", y1, y0, t_c_1);
            $fwrite(f3, "%h,%h,%h", y1, y0, t_c_2);
            $fwrite(f4, "%h,%h,%h", y1, y0, t_c_3);     
        end    
    end
end
always @(posedge ram_clk) begin
    if(update_finish == 1'b1 && {y1, y0} == 8'hff) begin
        $fclose(f1);
        $fclose(f2);
        $fclose(f3);
        $fclose(f4);
    end
end
//initial #(7.5+2.5+5*3*60+5) $finish;
always @(posedge ram_clk) begin
    if({y1, y0} == 8'hff)
        $finish; 
end
endmodule