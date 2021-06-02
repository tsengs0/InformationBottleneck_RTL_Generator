#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Wed Jun 02 17:51:29 JST 2021
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_ram_pageAlign_interface_behav -key {Behavioral:msg_pass_sim:Functional:tb_ram_pageAlign_interface} -tclbatch tb_ram_pageAlign_interface.tcl -protoinst "protoinst_files/mem_subsys.protoinst" -log simulate.log"
xsim tb_ram_pageAlign_interface_behav -key {Behavioral:msg_pass_sim:Functional:tb_ram_pageAlign_interface} -tclbatch tb_ram_pageAlign_interface.tcl -protoinst "protoinst_files/mem_subsys.protoinst" -log simulate.log
