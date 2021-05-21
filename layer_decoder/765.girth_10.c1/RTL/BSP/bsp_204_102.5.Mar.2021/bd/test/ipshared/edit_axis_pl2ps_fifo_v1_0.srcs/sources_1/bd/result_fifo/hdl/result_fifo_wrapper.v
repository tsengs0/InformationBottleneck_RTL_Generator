//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Mon Sep 14 03:54:52 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target result_fifo_wrapper.bd
//Design      : result_fifo_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module result_fifo_wrapper
   (FIFO_READ_0_empty,
    FIFO_READ_0_rd_data,
    FIFO_READ_0_rd_en,
    FIFO_WRITE_0_full,
    FIFO_WRITE_0_wr_data,
    FIFO_WRITE_0_wr_en,
    rd_clk_0,
    rd_rst_busy_0,
    srst_0,
    valid_0,
    wr_clk_0,
    wr_rst_busy_0);
  output FIFO_READ_0_empty;
  output [31:0]FIFO_READ_0_rd_data;
  input FIFO_READ_0_rd_en;
  output FIFO_WRITE_0_full;
  input [31:0]FIFO_WRITE_0_wr_data;
  input FIFO_WRITE_0_wr_en;
  input rd_clk_0;
  output rd_rst_busy_0;
  input srst_0;
  output valid_0;
  input wr_clk_0;
  output wr_rst_busy_0;

  wire FIFO_READ_0_empty;
  wire [31:0]FIFO_READ_0_rd_data;
  wire FIFO_READ_0_rd_en;
  wire FIFO_WRITE_0_full;
  wire [31:0]FIFO_WRITE_0_wr_data;
  wire FIFO_WRITE_0_wr_en;
  wire rd_clk_0;
  wire rd_rst_busy_0;
  wire srst_0;
  wire valid_0;
  wire wr_clk_0;
  wire wr_rst_busy_0;

  result_fifo result_fifo_i
       (.FIFO_READ_0_empty(FIFO_READ_0_empty),
        .FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
        .FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
        .FIFO_WRITE_0_full(FIFO_WRITE_0_full),
        .FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
        .FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
        .rd_clk_0(rd_clk_0),
        .rd_rst_busy_0(rd_rst_busy_0),
        .srst_0(srst_0),
        .valid_0(valid_0),
        .wr_clk_0(wr_clk_0),
        .wr_rst_busy_0(wr_rst_busy_0));
endmodule
