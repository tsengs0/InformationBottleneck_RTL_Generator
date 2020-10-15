// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Oct 12 01:01:58 2020
// Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/symmetry_ib_lut_structure/symmetry_ib_lut_structure.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_0/clock_domain_clk_wiz_0_0_stub.v
// Design      : clock_domain_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_domain_clk_wiz_0_0(write_clk, read_clk, reset, locked, clk_in1_p, 
  clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="write_clk,read_clk,reset,locked,clk_in1_p,clk_in1_n" */;
  output write_clk;
  output read_clk;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
endmodule
