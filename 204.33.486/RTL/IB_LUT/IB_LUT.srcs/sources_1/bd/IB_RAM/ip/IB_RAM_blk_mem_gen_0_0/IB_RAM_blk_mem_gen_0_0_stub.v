// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sat Feb 15 23:07:24 2020
// Host        : vpcc running 64-bit CentOS Linux release 7.4.1708 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_0_0/IB_RAM_blk_mem_gen_0_0_stub.v
// Design      : IB_RAM_blk_mem_gen_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module IB_RAM_blk_mem_gen_0_0(clka, rsta, ena, wea, addra, dina, douta, clkb, rstb, enb, 
  web, addrb, dinb, doutb, rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,ena,wea[127:0],addra[31:0],dina[1023:0],douta[1023:0],clkb,rstb,enb,web[127:0],addrb[31:0],dinb[1023:0],doutb[1023:0],rsta_busy,rstb_busy" */;
  input clka;
  input rsta;
  input ena;
  input [127:0]wea;
  input [31:0]addra;
  input [1023:0]dina;
  output [1023:0]douta;
  input clkb;
  input rstb;
  input enb;
  input [127:0]web;
  input [31:0]addrb;
  input [1023:0]dinb;
  output [1023:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule