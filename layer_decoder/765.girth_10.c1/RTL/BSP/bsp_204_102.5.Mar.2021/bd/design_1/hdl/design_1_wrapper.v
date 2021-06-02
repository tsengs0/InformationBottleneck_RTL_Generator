//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Jan 27 20:14:48 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (pl_fifo_wr_clk,
    result_fifo_in,
    result_fifo_we);
  input pl_fifo_wr_clk;
  input [31:0]result_fifo_in;
  input result_fifo_we;

  wire pl_fifo_wr_clk;
  wire [31:0]result_fifo_in;
  wire result_fifo_we;

  design_1 design_1_i
       (.pl_fifo_wr_clk(pl_fifo_wr_clk),
        .result_fifo_in(result_fifo_in),
        .result_fifo_we(result_fifo_we));
endmodule
