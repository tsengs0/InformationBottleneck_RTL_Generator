// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Mar 29 18:06:35 2021
// Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/BSP/bsp_204_102.5.Mar.2021/bd/ib_memory_system/ip/ib_memory_system_cn_iter25_49_func2_0/ib_memory_system_cn_iter25_49_func2_0_stub.v
// Design      : ib_memory_system_cn_iter25_49_func2_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module ib_memory_system_cn_iter25_49_func2_0(clka, addra, douta, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[7:0],douta[3:0],clkb,addrb[7:0],doutb[3:0]" */;
  input clka;
  input [7:0]addra;
  output [3:0]douta;
  input clkb;
  input [7:0]addrb;
  output [3:0]doutb;
endmodule