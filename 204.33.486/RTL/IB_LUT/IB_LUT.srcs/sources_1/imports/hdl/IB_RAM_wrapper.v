//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Mon Feb 17 17:24:20 2020
//Host        : vpcc running 64-bit CentOS Linux release 7.4.1708 (Core)
//Command     : generate_target IB_RAM_wrapper.bd
//Design      : IB_RAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module IB_RAM_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_we,
    BRAM_PORTB_0_addr,
    BRAM_PORTB_0_clk,
    BRAM_PORTB_0_din,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_we);
  input [6:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [35:0]BRAM_PORTA_0_din;
  output [35:0]BRAM_PORTA_0_dout;
  input [0:0]BRAM_PORTA_0_we;
  input [6:0]BRAM_PORTB_0_addr;
  input BRAM_PORTB_0_clk;
  input [35:0]BRAM_PORTB_0_din;
  output [35:0]BRAM_PORTB_0_dout;
  input [0:0]BRAM_PORTB_0_we;

  wire [6:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [35:0]BRAM_PORTA_0_din;
  wire [35:0]BRAM_PORTA_0_dout;
  wire [0:0]BRAM_PORTA_0_we;
  wire [6:0]BRAM_PORTB_0_addr;
  wire BRAM_PORTB_0_clk;
  wire [35:0]BRAM_PORTB_0_din;
  wire [35:0]BRAM_PORTB_0_dout;
  wire [0:0]BRAM_PORTB_0_we;

  IB_RAM IB_RAM_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we),
        .BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
        .BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
        .BRAM_PORTB_0_din(BRAM_PORTB_0_din),
        .BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
        .BRAM_PORTB_0_we(BRAM_PORTB_0_we));
endmodule
