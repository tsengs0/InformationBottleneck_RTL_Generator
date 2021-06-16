#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Fri Jun 11 23:43:33 JST 2021
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_mem_subsystem_top_submatrix_1_behav -key {Behavioral:msg_pass_with_memWr_sim:Functional:tb_mem_subsystem_top_submatrix_1} -tclbatch tb_mem_subsystem_top_submatrix_1.tcl -protoinst "protoinst_files/mem_subsys.protoinst" -protoinst "protoinst_files/mem_subsys_frag.protoinst" -view /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/tb_mem_subsystem_top_submatrix_1_behav.wcfg -log simulate.log"
xsim tb_mem_subsystem_top_submatrix_1_behav -key {Behavioral:msg_pass_with_memWr_sim:Functional:tb_mem_subsystem_top_submatrix_1} -tclbatch tb_mem_subsystem_top_submatrix_1.tcl -protoinst "protoinst_files/mem_subsys.protoinst" -protoinst "protoinst_files/mem_subsys_frag.protoinst" -view /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/tb_mem_subsystem_top_submatrix_1_behav.wcfg -log simulate.log

