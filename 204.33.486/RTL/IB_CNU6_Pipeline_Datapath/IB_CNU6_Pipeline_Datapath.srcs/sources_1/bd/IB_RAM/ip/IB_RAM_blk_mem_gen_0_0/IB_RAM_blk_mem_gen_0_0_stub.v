// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Fri Apr  3 12:42:40 2020
// Host        : uv running 64-bit SUSE Linux Enterprise Server 12 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU6_Pipeline_Datapath/IB_CNU6_Pipeline_Datapath.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_0_0/IB_RAM_blk_mem_gen_0_0_stub.v
// Design      : IB_RAM_blk_mem_gen_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module IB_RAM_blk_mem_gen_0_0(clka, addra, douta, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[6:0],douta[31:0],clkb,addrb[6:0],doutb[31:0]" */;
  input clka;
  input [6:0]addra;
  output [31:0]douta;
  input clkb;
  input [6:0]addrb;
  output [31:0]doutb;
endmodule
