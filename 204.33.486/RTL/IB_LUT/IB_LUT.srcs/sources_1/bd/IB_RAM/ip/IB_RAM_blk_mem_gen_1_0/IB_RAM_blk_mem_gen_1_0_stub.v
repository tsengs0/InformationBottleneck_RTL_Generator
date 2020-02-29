// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sat Feb 29 02:34:31 2020
// Host        : vpcc running 64-bit CentOS Linux release 7.4.1708 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_1_0/IB_RAM_blk_mem_gen_1_0_stub.v
// Design      : IB_RAM_blk_mem_gen_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module IB_RAM_blk_mem_gen_1_0(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[6:0],dina[35:0],douta[35:0],clkb,web[0:0],addrb[6:0],dinb[35:0],doutb[35:0]" */;
  input clka;
  input [0:0]wea;
  input [6:0]addra;
  input [35:0]dina;
  output [35:0]douta;
  input clkb;
  input [0:0]web;
  input [6:0]addrb;
  input [35:0]dinb;
  output [35:0]doutb;
endmodule
