// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Fri Feb 19 22:52:28 2021
// Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/Xilinx/Vivado/project/AXI.UART.customIP/AXI.UART.customIP.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_0/clock_domain_clk_wiz_0_0_stub.v
// Design      : clock_domain_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_domain_clk_wiz_0_0(clk_out1, clk_out2, clk_out3, clk_out4, clk_out5, 
  reset, locked, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,reset,locked,clk_in1_p,clk_in1_n" */;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
  output clk_out5;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
endmodule
