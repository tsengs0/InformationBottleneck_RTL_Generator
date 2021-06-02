//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Fri Feb 19 22:14:13 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target clock_domain_wrapper.bd
//Design      : clock_domain_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_domain_wrapper
   (clk_100MHz,
    clk_150MHz,
    clk_200MHz,
    clk_300MHz,
    clk_300mhz_clk_n,
    clk_300mhz_clk_p,
    clk_50MHz,
    locked,
    reset_0);
  output clk_100MHz;
  output clk_150MHz;
  output clk_200MHz;
  output clk_300MHz;
  input clk_300mhz_clk_n;
  input clk_300mhz_clk_p;
  output clk_50MHz;
  output locked;
  input reset_0;

  wire clk_100MHz;
  wire clk_150MHz;
  wire clk_200MHz;
  wire clk_300MHz;
  wire clk_300mhz_clk_n;
  wire clk_300mhz_clk_p;
  wire clk_50MHz;
  wire locked;
  wire reset_0;

  clock_domain clock_domain_i
       (.clk_100MHz(clk_100MHz),
        .clk_150MHz(clk_150MHz),
        .clk_200MHz(clk_200MHz),
        .clk_300MHz(clk_300MHz),
        .clk_300mhz_clk_n(clk_300mhz_clk_n),
        .clk_300mhz_clk_p(clk_300mhz_clk_p),
        .clk_50MHz(clk_50MHz),
        .locked(locked),
        .reset_0(reset_0));
endmodule
