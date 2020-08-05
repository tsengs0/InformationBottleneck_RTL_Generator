//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Fri Jul 17 18:06:26 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target clock_domain_wrapper.bd
//Design      : clock_domain_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_domain_wrapper
   (clk_300mhz_clk_n,
    clk_300mhz_clk_p,
    locked_0,
    read_clk_0,
    reset,
    write_clk_0);
  input clk_300mhz_clk_n;
  input clk_300mhz_clk_p;
  output locked_0;
  output read_clk_0;
  input reset;
  output write_clk_0;

  wire clk_300mhz_clk_n;
  wire clk_300mhz_clk_p;
  wire locked_0;
  wire read_clk_0;
  wire reset;
  wire write_clk_0;

  clock_domain clock_domain_i
       (.clk_300mhz_clk_n(clk_300mhz_clk_n),
        .clk_300mhz_clk_p(clk_300mhz_clk_p),
        .locked_0(locked_0),
        .read_clk_0(read_clk_0),
        .reset(reset),
        .write_clk_0(write_clk_0));
endmodule
