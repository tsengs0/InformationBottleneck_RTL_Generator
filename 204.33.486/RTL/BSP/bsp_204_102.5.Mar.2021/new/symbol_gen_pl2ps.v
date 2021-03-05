//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Jun 10 00:56:10 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module symbol_gen_pl2ps(
    output reg ready_work,

    input wire CLK_300_N,
    input wire CLK_300_P,
    input wire GPIO_PB_SW2, // for PLL Rst
    input wire GPIO_PB_SW3 // for System RSTn
);


parameter [15:0] std_dev_0 = 16'b0000010110101000;
parameter [15:0] std_dev_1 = 16'b0000010100001010;
parameter [15:0] std_dev_2 = 16'b0000010001111110; 
parameter [15:0] std_dev_3 = 16'b0000010000000001;
parameter [15:0] std_dev_4 = 16'b0000001110010001;
parameter [15:0] std_dev_5 = 16'b0000001100101110;
parameter [15:0] std_dev_6 = 16'b0000001011010101;
parameter [15:0] std_dev_7 = 16'b0000001010000110;
parameter [15:0] std_dev_8 = 16'b0000001001000000;
parameter [15:0] std_dev_9 = 16'b0000001000000001;
parameter [15:0] std_dev_10 = 16'b0000000111001001;
localparam SYMBOL_NUM = 8;

  wire pl_fifo_wr_clk;
  wire result_fifo_we;
  wire clk_lock, clk_150MHz;
  wire pll_rst, sys_rstn, symbol_gen_ce;
  
  assign pll_rst = GPIO_PB_SW2;
  assign sys_rstn = ~GPIO_PB_SW3;
  assign symbol_gen_ce = clk_lock; //sys_rstn;
clock_domain_wrapper clock_u0 (
    .clk_150MHz (clk_150MHz),
    .clk_300mhz_clk_n (CLK_300_N),
    .clk_300mhz_clk_p (CLK_300_P),
    .locked (clk_lock),
    .reset_0 (pll_rst)
);
assign pl_fifo_wr_clk = (clk_lock & clk_150MHz);
assign result_fifo_we = clk_lock;
initial ready_work <= 1'b1;
always @(negedge pl_fifo_wr_clk) ready_work <= result_fifo_we;

wire [3:0] ch_msg [0:SYMBOL_NUM-1];
wire [15:0] sigma_in [0:SYMBOL_NUM-1];
assign sigma_in[0] = std_dev_0[15:0];
assign sigma_in[1] = std_dev_1[15:0];
assign sigma_in[2] = std_dev_2[15:0];
assign sigma_in[3] = std_dev_3[15:0];
assign sigma_in[4] = std_dev_4[15:0];
assign sigma_in[5] = std_dev_6[15:0];
assign sigma_in[6] = std_dev_8[15:0];
assign sigma_in[7] = std_dev_10[15:0];
generate
genvar i;
for(i = 0; i < SYMBOL_NUM; i = i+1) begin : symbol_gen_inst
    symbol_generator symbol_gnerator_u0(
        .ch_msg (ch_msg[i]),
    
        .sigma_in (sigma_in[i]), // standard deviation of underlying AWGN channel
        //.coded_bit (coded_bit), // without BPSK modulation
        .sys_clk (pl_fifo_wr_clk),
        .rstn (sys_rstn),
        .ce (symbol_gen_ce)
        );
end
endgenerate


reg [31:0] result_fifo_in;
initial result_fifo_in[31:0] <= 32'd0;
always @(posedge pl_fifo_wr_clk) begin
    if(!sys_rstn)
        result_fifo_in[31:0] <= 32'd0;
    else
    result_fifo_in[31:0] <= {
                                ch_msg[7], 
                                ch_msg[6], 
                                ch_msg[5], 
                                ch_msg[4],
                                ch_msg[3],
                                ch_msg[2],
                                ch_msg[1],
                                ch_msg[0]
                             };
end

  design_1_wrapper design_1_i
       (.pl_fifo_wr_clk(pl_fifo_wr_clk),
        .result_fifo_in(result_fifo_in[31:0]),
        .result_fifo_we(result_fifo_we));
endmodule