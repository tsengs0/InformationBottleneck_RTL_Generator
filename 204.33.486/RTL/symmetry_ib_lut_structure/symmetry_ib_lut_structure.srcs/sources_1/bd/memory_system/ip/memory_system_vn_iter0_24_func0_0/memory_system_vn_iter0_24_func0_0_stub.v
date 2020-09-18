// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Thu Sep 17 15:20:40 2020
// Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub -rename_top memory_system_vn_iter0_24_func0_0 -prefix
//               memory_system_vn_iter0_24_func0_0_ memory_system_vn_iter0_24_func0_0_stub.v
// Design      : memory_system_vn_iter0_24_func0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module memory_system_vn_iter0_24_func0_0(clka, addra, douta, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[10:0],douta[1:0],clkb,enb,addrb[10:0],doutb[1:0]" */;
  input clka;
  input [10:0]addra;
  output [1:0]douta;
  input clkb;
  input enb;
  input [10:0]addrb;
  output [1:0]doutb;
endmodule
