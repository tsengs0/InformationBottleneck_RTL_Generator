//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Tue Mar 16 18:35:13 2021
//Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target design_2_wrapper.bd
//Design      : design_2_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_2_wrapper
   (axi_wr_end,
    axi_wr_first_shift,
    axi_wr_next_shift,
    m00_axi_aclk,
    m00_axi_init_axi_txn,
    m00_axi_wr_intr_en,
    m_axi_arestn,
    pl_ps_ext_intr,
    result_packet_in);
  output axi_wr_end;
  output axi_wr_first_shift;
  output axi_wr_next_shift;
  output m00_axi_aclk;
  input m00_axi_init_axi_txn;
  output m00_axi_wr_intr_en;
  output [0:0]m_axi_arestn;
  input pl_ps_ext_intr;
  input [31:0]result_packet_in;

  wire axi_wr_end;
  wire axi_wr_first_shift;
  wire axi_wr_next_shift;
  wire m00_axi_aclk;
  wire m00_axi_init_axi_txn;
  wire m00_axi_wr_intr_en;
  wire [0:0]m_axi_arestn;
  wire pl_ps_ext_intr;
  wire [31:0]result_packet_in;

  design_2 design_2_i
       (.axi_wr_end(axi_wr_end),
        .axi_wr_first_shift(axi_wr_first_shift),
        .axi_wr_next_shift(axi_wr_next_shift),
        .m00_axi_aclk(m00_axi_aclk),
        .m00_axi_init_axi_txn(m00_axi_init_axi_txn),
        .m00_axi_wr_intr_en(m00_axi_wr_intr_en),
        .m_axi_arestn(m_axi_arestn),
        .pl_ps_ext_intr(pl_ps_ext_intr),
        .result_packet_in(result_packet_in));
endmodule
