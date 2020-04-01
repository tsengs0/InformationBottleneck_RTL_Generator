//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Apr  1 16:23:07 2020
//Host        : uv running 64-bit SUSE Linux Enterprise Server 12 SP1
//Command     : generate_target clock_domain_wrapper.bd
//Design      : clock_domain_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_domain_wrapper
   (clk_300mhz_clk_n,
    clk_300mhz_clk_p,
    clk_out1_0,
    clk_out2_0,
    locked_0,
    reset);
  input clk_300mhz_clk_n;
  input clk_300mhz_clk_p;
  output clk_out1_0;
  output clk_out2_0;
  output locked_0;
  input reset;

  wire clk_300mhz_clk_n;
  wire clk_300mhz_clk_p;
  wire clk_out1_0;
  wire clk_out2_0;
  wire locked_0;
  wire reset;

  clock_domain clock_domain_i
       (.clk_300mhz_clk_n(clk_300mhz_clk_n),
        .clk_300mhz_clk_p(clk_300mhz_clk_p),
        .clk_out1_0(clk_out1_0),
        .clk_out2_0(clk_out2_0),
        .locked_0(locked_0),
        .reset(reset));
endmodule
