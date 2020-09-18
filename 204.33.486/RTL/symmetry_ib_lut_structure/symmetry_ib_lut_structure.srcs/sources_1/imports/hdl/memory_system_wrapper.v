//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Thu Sep 17 14:42:35 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target memory_system_wrapper.bd
//Design      : memory_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module memory_system_wrapper
   (cn_iter0_m0_portA_addr,
    cn_iter0_m0_portA_clk,
    cn_iter0_m0_portA_dout,
    cn_iter0_m0_portB_addr,
    cn_iter0_m0_portB_clk,
    cn_iter0_m0_portB_dout,
    cn_iter0_m1_portA_addr,
    cn_iter0_m1_portA_clk,
    cn_iter0_m1_portA_dout,
    cn_iter0_m1_portB_addr,
    cn_iter0_m1_portB_clk,
    cn_iter0_m1_portB_dout,
    cn_iter0_m2_portA_addr,
    cn_iter0_m2_portA_clk,
    cn_iter0_m2_portA_dout,
    cn_iter0_m2_portB_addr,
    cn_iter0_m2_portB_clk,
    cn_iter0_m2_portB_dout,
    cn_iter0_m3_portA_addr,
    cn_iter0_m3_portA_clk,
    cn_iter0_m3_portA_dout,
    cn_iter0_m3_portB_addr,
    cn_iter0_m3_portB_clk,
    cn_iter0_m3_portB_dout,
    cn_iter1_m0_portA_addr,
    cn_iter1_m0_portA_clk,
    cn_iter1_m0_portA_dout,
    cn_iter1_m0_portB_addr,
    cn_iter1_m0_portB_clk,
    cn_iter1_m0_portB_dout,
    cn_iter1_m1_portA_addr,
    cn_iter1_m1_portA_clk,
    cn_iter1_m1_portA_dout,
    cn_iter1_m1_portB_addr,
    cn_iter1_m1_portB_clk,
    cn_iter1_m1_portB_dout,
    cn_iter1_m2_portA_addr,
    cn_iter1_m2_portA_clk,
    cn_iter1_m2_portA_dout,
    cn_iter1_m2_portB_addr,
    cn_iter1_m2_portB_clk,
    cn_iter1_m2_portB_dout,
    cn_iter1_m3_portA_addr,
    cn_iter1_m3_portA_clk,
    cn_iter1_m3_portA_dout,
    cn_iter1_m3_portB_addr,
    cn_iter1_m3_portB_clk,
    cn_iter1_m3_portB_dout,
    dn_iter0_portA_addr,
    dn_iter0_portA_clk,
    dn_iter0_portA_dout,
    dn_iter0_portB_addr,
    dn_iter0_portB_clk,
    dn_iter0_portB_dout,
    dn_iter1_portA_addr,
    dn_iter1_portA_clk,
    dn_iter1_portA_dout,
    dn_iter1_portB_addr,
    dn_iter1_portB_clk,
    dn_iter1_portB_dout,
    vn_iter0_m0_portA_addr,
    vn_iter0_m0_portA_clk,
    vn_iter0_m0_portA_dout,
    vn_iter0_m0_portB_addr,
    vn_iter0_m0_portB_clk,
    vn_iter0_m0_portB_dout,
    vn_iter0_m1_portA_addr,
    vn_iter0_m1_portA_clk,
    vn_iter0_m1_portA_dout,
    vn_iter0_m1_portB_addr,
    vn_iter0_m1_portB_clk,
    vn_iter0_m1_portB_dout,
    vn_iter1_m0_portA_addr,
    vn_iter1_m0_portA_clk,
    vn_iter1_m0_portA_dout,
    vn_iter1_m0_portB_addr,
    vn_iter1_m0_portB_clk,
    vn_iter1_m0_portB_dout,
    vn_iter1_m1_portA_addr,
    vn_iter1_m1_portA_clk,
    vn_iter1_m1_portA_dout,
    vn_iter1_m1_portB_addr,
    vn_iter1_m1_portB_clk,
    vn_iter1_m1_portB_dout);
  input [9:0]cn_iter0_m0_portA_addr;
  input cn_iter0_m0_portA_clk;
  output [5:0]cn_iter0_m0_portA_dout;
  input [9:0]cn_iter0_m0_portB_addr;
  input cn_iter0_m0_portB_clk;
  output [5:0]cn_iter0_m0_portB_dout;
  input [9:0]cn_iter0_m1_portA_addr;
  input cn_iter0_m1_portA_clk;
  output [5:0]cn_iter0_m1_portA_dout;
  input [9:0]cn_iter0_m1_portB_addr;
  input cn_iter0_m1_portB_clk;
  output [5:0]cn_iter0_m1_portB_dout;
  input [9:0]cn_iter0_m2_portA_addr;
  input cn_iter0_m2_portA_clk;
  output [5:0]cn_iter0_m2_portA_dout;
  input [9:0]cn_iter0_m2_portB_addr;
  input cn_iter0_m2_portB_clk;
  output [5:0]cn_iter0_m2_portB_dout;
  input [9:0]cn_iter0_m3_portA_addr;
  input cn_iter0_m3_portA_clk;
  output [5:0]cn_iter0_m3_portA_dout;
  input [9:0]cn_iter0_m3_portB_addr;
  input cn_iter0_m3_portB_clk;
  output [5:0]cn_iter0_m3_portB_dout;
  input [9:0]cn_iter1_m0_portA_addr;
  input cn_iter1_m0_portA_clk;
  output [5:0]cn_iter1_m0_portA_dout;
  input [9:0]cn_iter1_m0_portB_addr;
  input cn_iter1_m0_portB_clk;
  output [5:0]cn_iter1_m0_portB_dout;
  input [9:0]cn_iter1_m1_portA_addr;
  input cn_iter1_m1_portA_clk;
  output [5:0]cn_iter1_m1_portA_dout;
  input [9:0]cn_iter1_m1_portB_addr;
  input cn_iter1_m1_portB_clk;
  output [5:0]cn_iter1_m1_portB_dout;
  input [9:0]cn_iter1_m2_portA_addr;
  input cn_iter1_m2_portA_clk;
  output [5:0]cn_iter1_m2_portA_dout;
  input [9:0]cn_iter1_m2_portB_addr;
  input cn_iter1_m2_portB_clk;
  output [5:0]cn_iter1_m2_portB_dout;
  input [9:0]cn_iter1_m3_portA_addr;
  input cn_iter1_m3_portA_clk;
  output [5:0]cn_iter1_m3_portA_dout;
  input [9:0]cn_iter1_m3_portB_addr;
  input cn_iter1_m3_portB_clk;
  output [5:0]cn_iter1_m3_portB_dout;
  input [10:0]dn_iter0_portA_addr;
  input dn_iter0_portA_clk;
  output [1:0]dn_iter0_portA_dout;
  input [10:0]dn_iter0_portB_addr;
  input dn_iter0_portB_clk;
  output [1:0]dn_iter0_portB_dout;
  input [10:0]dn_iter1_portA_addr;
  input dn_iter1_portA_clk;
  output [1:0]dn_iter1_portA_dout;
  input [10:0]dn_iter1_portB_addr;
  input dn_iter1_portB_clk;
  output [1:0]dn_iter1_portB_dout;
  input [10:0]vn_iter0_m0_portA_addr;
  input vn_iter0_m0_portA_clk;
  output [7:0]vn_iter0_m0_portA_dout;
  input [10:0]vn_iter0_m0_portB_addr;
  input vn_iter0_m0_portB_clk;
  output [7:0]vn_iter0_m0_portB_dout;
  input [10:0]vn_iter0_m1_portA_addr;
  input vn_iter0_m1_portA_clk;
  output [7:0]vn_iter0_m1_portA_dout;
  input [10:0]vn_iter0_m1_portB_addr;
  input vn_iter0_m1_portB_clk;
  output [7:0]vn_iter0_m1_portB_dout;
  input [10:0]vn_iter1_m0_portA_addr;
  input vn_iter1_m0_portA_clk;
  output [7:0]vn_iter1_m0_portA_dout;
  input [10:0]vn_iter1_m0_portB_addr;
  input vn_iter1_m0_portB_clk;
  output [7:0]vn_iter1_m0_portB_dout;
  input [10:0]vn_iter1_m1_portA_addr;
  input vn_iter1_m1_portA_clk;
  output [7:0]vn_iter1_m1_portA_dout;
  input [10:0]vn_iter1_m1_portB_addr;
  input vn_iter1_m1_portB_clk;
  output [7:0]vn_iter1_m1_portB_dout;

  wire [9:0]cn_iter0_m0_portA_addr;
  wire cn_iter0_m0_portA_clk;
  wire [5:0]cn_iter0_m0_portA_dout;
  wire [9:0]cn_iter0_m0_portB_addr;
  wire cn_iter0_m0_portB_clk;
  wire [5:0]cn_iter0_m0_portB_dout;
  wire [9:0]cn_iter0_m1_portA_addr;
  wire cn_iter0_m1_portA_clk;
  wire [5:0]cn_iter0_m1_portA_dout;
  wire [9:0]cn_iter0_m1_portB_addr;
  wire cn_iter0_m1_portB_clk;
  wire [5:0]cn_iter0_m1_portB_dout;
  wire [9:0]cn_iter0_m2_portA_addr;
  wire cn_iter0_m2_portA_clk;
  wire [5:0]cn_iter0_m2_portA_dout;
  wire [9:0]cn_iter0_m2_portB_addr;
  wire cn_iter0_m2_portB_clk;
  wire [5:0]cn_iter0_m2_portB_dout;
  wire [9:0]cn_iter0_m3_portA_addr;
  wire cn_iter0_m3_portA_clk;
  wire [5:0]cn_iter0_m3_portA_dout;
  wire [9:0]cn_iter0_m3_portB_addr;
  wire cn_iter0_m3_portB_clk;
  wire [5:0]cn_iter0_m3_portB_dout;
  wire [9:0]cn_iter1_m0_portA_addr;
  wire cn_iter1_m0_portA_clk;
  wire [5:0]cn_iter1_m0_portA_dout;
  wire [9:0]cn_iter1_m0_portB_addr;
  wire cn_iter1_m0_portB_clk;
  wire [5:0]cn_iter1_m0_portB_dout;
  wire [9:0]cn_iter1_m1_portA_addr;
  wire cn_iter1_m1_portA_clk;
  wire [5:0]cn_iter1_m1_portA_dout;
  wire [9:0]cn_iter1_m1_portB_addr;
  wire cn_iter1_m1_portB_clk;
  wire [5:0]cn_iter1_m1_portB_dout;
  wire [9:0]cn_iter1_m2_portA_addr;
  wire cn_iter1_m2_portA_clk;
  wire [5:0]cn_iter1_m2_portA_dout;
  wire [9:0]cn_iter1_m2_portB_addr;
  wire cn_iter1_m2_portB_clk;
  wire [5:0]cn_iter1_m2_portB_dout;
  wire [9:0]cn_iter1_m3_portA_addr;
  wire cn_iter1_m3_portA_clk;
  wire [5:0]cn_iter1_m3_portA_dout;
  wire [9:0]cn_iter1_m3_portB_addr;
  wire cn_iter1_m3_portB_clk;
  wire [5:0]cn_iter1_m3_portB_dout;
  wire [10:0]dn_iter0_portA_addr;
  wire dn_iter0_portA_clk;
  wire [1:0]dn_iter0_portA_dout;
  wire [10:0]dn_iter0_portB_addr;
  wire dn_iter0_portB_clk;
  wire [1:0]dn_iter0_portB_dout;
  wire [10:0]dn_iter1_portA_addr;
  wire dn_iter1_portA_clk;
  wire [1:0]dn_iter1_portA_dout;
  wire [10:0]dn_iter1_portB_addr;
  wire dn_iter1_portB_clk;
  wire [1:0]dn_iter1_portB_dout;
  wire [10:0]vn_iter0_m0_portA_addr;
  wire vn_iter0_m0_portA_clk;
  wire [7:0]vn_iter0_m0_portA_dout;
  wire [10:0]vn_iter0_m0_portB_addr;
  wire vn_iter0_m0_portB_clk;
  wire [7:0]vn_iter0_m0_portB_dout;
  wire [10:0]vn_iter0_m1_portA_addr;
  wire vn_iter0_m1_portA_clk;
  wire [7:0]vn_iter0_m1_portA_dout;
  wire [10:0]vn_iter0_m1_portB_addr;
  wire vn_iter0_m1_portB_clk;
  wire [7:0]vn_iter0_m1_portB_dout;
  wire [10:0]vn_iter1_m0_portA_addr;
  wire vn_iter1_m0_portA_clk;
  wire [7:0]vn_iter1_m0_portA_dout;
  wire [10:0]vn_iter1_m0_portB_addr;
  wire vn_iter1_m0_portB_clk;
  wire [7:0]vn_iter1_m0_portB_dout;
  wire [10:0]vn_iter1_m1_portA_addr;
  wire vn_iter1_m1_portA_clk;
  wire [7:0]vn_iter1_m1_portA_dout;
  wire [10:0]vn_iter1_m1_portB_addr;
  wire vn_iter1_m1_portB_clk;
  wire [7:0]vn_iter1_m1_portB_dout;

  memory_system memory_system_i
       (.cn_iter0_m0_portA_addr(cn_iter0_m0_portA_addr),
        .cn_iter0_m0_portA_clk(cn_iter0_m0_portA_clk),
        .cn_iter0_m0_portA_dout(cn_iter0_m0_portA_dout),
        .cn_iter0_m0_portB_addr(cn_iter0_m0_portB_addr),
        .cn_iter0_m0_portB_clk(cn_iter0_m0_portB_clk),
        .cn_iter0_m0_portB_dout(cn_iter0_m0_portB_dout),
        .cn_iter0_m1_portA_addr(cn_iter0_m1_portA_addr),
        .cn_iter0_m1_portA_clk(cn_iter0_m1_portA_clk),
        .cn_iter0_m1_portA_dout(cn_iter0_m1_portA_dout),
        .cn_iter0_m1_portB_addr(cn_iter0_m1_portB_addr),
        .cn_iter0_m1_portB_clk(cn_iter0_m1_portB_clk),
        .cn_iter0_m1_portB_dout(cn_iter0_m1_portB_dout),
        .cn_iter0_m2_portA_addr(cn_iter0_m2_portA_addr),
        .cn_iter0_m2_portA_clk(cn_iter0_m2_portA_clk),
        .cn_iter0_m2_portA_dout(cn_iter0_m2_portA_dout),
        .cn_iter0_m2_portB_addr(cn_iter0_m2_portB_addr),
        .cn_iter0_m2_portB_clk(cn_iter0_m2_portB_clk),
        .cn_iter0_m2_portB_dout(cn_iter0_m2_portB_dout),
        .cn_iter0_m3_portA_addr(cn_iter0_m3_portA_addr),
        .cn_iter0_m3_portA_clk(cn_iter0_m3_portA_clk),
        .cn_iter0_m3_portA_dout(cn_iter0_m3_portA_dout),
        .cn_iter0_m3_portB_addr(cn_iter0_m3_portB_addr),
        .cn_iter0_m3_portB_clk(cn_iter0_m3_portB_clk),
        .cn_iter0_m3_portB_dout(cn_iter0_m3_portB_dout),
        .cn_iter1_m0_portA_addr(cn_iter1_m0_portA_addr),
        .cn_iter1_m0_portA_clk(cn_iter1_m0_portA_clk),
        .cn_iter1_m0_portA_dout(cn_iter1_m0_portA_dout),
        .cn_iter1_m0_portB_addr(cn_iter1_m0_portB_addr),
        .cn_iter1_m0_portB_clk(cn_iter1_m0_portB_clk),
        .cn_iter1_m0_portB_dout(cn_iter1_m0_portB_dout),
        .cn_iter1_m1_portA_addr(cn_iter1_m1_portA_addr),
        .cn_iter1_m1_portA_clk(cn_iter1_m1_portA_clk),
        .cn_iter1_m1_portA_dout(cn_iter1_m1_portA_dout),
        .cn_iter1_m1_portB_addr(cn_iter1_m1_portB_addr),
        .cn_iter1_m1_portB_clk(cn_iter1_m1_portB_clk),
        .cn_iter1_m1_portB_dout(cn_iter1_m1_portB_dout),
        .cn_iter1_m2_portA_addr(cn_iter1_m2_portA_addr),
        .cn_iter1_m2_portA_clk(cn_iter1_m2_portA_clk),
        .cn_iter1_m2_portA_dout(cn_iter1_m2_portA_dout),
        .cn_iter1_m2_portB_addr(cn_iter1_m2_portB_addr),
        .cn_iter1_m2_portB_clk(cn_iter1_m2_portB_clk),
        .cn_iter1_m2_portB_dout(cn_iter1_m2_portB_dout),
        .cn_iter1_m3_portA_addr(cn_iter1_m3_portA_addr),
        .cn_iter1_m3_portA_clk(cn_iter1_m3_portA_clk),
        .cn_iter1_m3_portA_dout(cn_iter1_m3_portA_dout),
        .cn_iter1_m3_portB_addr(cn_iter1_m3_portB_addr),
        .cn_iter1_m3_portB_clk(cn_iter1_m3_portB_clk),
        .cn_iter1_m3_portB_dout(cn_iter1_m3_portB_dout),
        .dn_iter0_portA_addr(dn_iter0_portA_addr),
        .dn_iter0_portA_clk(dn_iter0_portA_clk),
        .dn_iter0_portA_dout(dn_iter0_portA_dout),
        .dn_iter0_portB_addr(dn_iter0_portB_addr),
        .dn_iter0_portB_clk(dn_iter0_portB_clk),
        .dn_iter0_portB_dout(dn_iter0_portB_dout),
        .dn_iter1_portA_addr(dn_iter1_portA_addr),
        .dn_iter1_portA_clk(dn_iter1_portA_clk),
        .dn_iter1_portA_dout(dn_iter1_portA_dout),
        .dn_iter1_portB_addr(dn_iter1_portB_addr),
        .dn_iter1_portB_clk(dn_iter1_portB_clk),
        .dn_iter1_portB_dout(dn_iter1_portB_dout),
        .vn_iter0_m0_portA_addr(vn_iter0_m0_portA_addr),
        .vn_iter0_m0_portA_clk(vn_iter0_m0_portA_clk),
        .vn_iter0_m0_portA_dout(vn_iter0_m0_portA_dout),
        .vn_iter0_m0_portB_addr(vn_iter0_m0_portB_addr),
        .vn_iter0_m0_portB_clk(vn_iter0_m0_portB_clk),
        .vn_iter0_m0_portB_dout(vn_iter0_m0_portB_dout),
        .vn_iter0_m1_portA_addr(vn_iter0_m1_portA_addr),
        .vn_iter0_m1_portA_clk(vn_iter0_m1_portA_clk),
        .vn_iter0_m1_portA_dout(vn_iter0_m1_portA_dout),
        .vn_iter0_m1_portB_addr(vn_iter0_m1_portB_addr),
        .vn_iter0_m1_portB_clk(vn_iter0_m1_portB_clk),
        .vn_iter0_m1_portB_dout(vn_iter0_m1_portB_dout),
        .vn_iter1_m0_portA_addr(vn_iter1_m0_portA_addr),
        .vn_iter1_m0_portA_clk(vn_iter1_m0_portA_clk),
        .vn_iter1_m0_portA_dout(vn_iter1_m0_portA_dout),
        .vn_iter1_m0_portB_addr(vn_iter1_m0_portB_addr),
        .vn_iter1_m0_portB_clk(vn_iter1_m0_portB_clk),
        .vn_iter1_m0_portB_dout(vn_iter1_m0_portB_dout),
        .vn_iter1_m1_portA_addr(vn_iter1_m1_portA_addr),
        .vn_iter1_m1_portA_clk(vn_iter1_m1_portA_clk),
        .vn_iter1_m1_portA_dout(vn_iter1_m1_portA_dout),
        .vn_iter1_m1_portB_addr(vn_iter1_m1_portB_addr),
        .vn_iter1_m1_portB_clk(vn_iter1_m1_portB_clk),
        .vn_iter1_m1_portB_dout(vn_iter1_m1_portB_dout));
endmodule
