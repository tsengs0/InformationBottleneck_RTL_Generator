//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Tue Mar 16 18:36:12 2021
//Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target sync_clock_domain_wrapper.bd
//Design      : sync_clock_domain_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module sync_clock_domain_wrapper
   (clk_100MHz,
    clk_150MHz,
    clk_200MHz,
    clk_300MHz,
    clk_50MHz,
    clk_in1_0,
    locked_0,
    reset_0);
  output clk_100MHz;
  output clk_150MHz;
  output clk_200MHz;
  output clk_300MHz;
  output clk_50MHz;
  input clk_in1_0;
  output locked_0;
  input reset_0;

  wire clk_100MHz;
  wire clk_150MHz;
  wire clk_200MHz;
  wire clk_300MHz;
  wire clk_50MHz;
  wire clk_in1_0;
  wire locked_0;
  wire reset_0;

  sync_clock_domain sync_clock_domain_i
       (.clk_100MHz(clk_100MHz),
        .clk_150MHz(clk_150MHz),
        .clk_200MHz(clk_200MHz),
        .clk_300MHz(clk_300MHz),
        .clk_50MHz(clk_50MHz),
        .clk_in1_0(clk_in1_0),
        .locked_0(locked_0),
        .reset_0(reset_0));
endmodule
