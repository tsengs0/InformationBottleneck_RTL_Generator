// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Wed Sep 16 20:55:24 2020
// Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/symmetry_ib_lut_structure/symmetry_ib_lut_structure.srcs/sources_1/bd/memory_system/ip/memory_system_cn_iter0_24_func1_2/memory_system_cn_iter0_24_func1_2_stub.v
// Design      : memory_system_cn_iter0_24_func1_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module memory_system_cn_iter0_24_func1_2(clka, addra, douta, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[9:0],douta[5:0],clkb,addrb[9:0],doutb[5:0]" */;
  input clka;
  input [9:0]addra;
  output [5:0]douta;
  input clkb;
  input [9:0]addrb;
  output [5:0]doutb;
endmodule
