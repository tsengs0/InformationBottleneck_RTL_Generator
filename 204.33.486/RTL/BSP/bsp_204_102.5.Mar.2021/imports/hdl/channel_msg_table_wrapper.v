//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Mon Feb 22 16:33:13 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target channel_msg_table_wrapper.bd
//Design      : channel_msg_table_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module channel_msg_table_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_dout);
  input [4:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  output [14:0]BRAM_PORTA_0_dout;

  wire [4:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [14:0]BRAM_PORTA_0_dout;

  channel_msg_table channel_msg_table_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout));
endmodule
