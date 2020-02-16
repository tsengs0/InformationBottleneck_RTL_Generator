#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sun Feb 16 00:43:07 JST 2020
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim cnu_ib_lut_ram_behav -key {Behavioral:sim_1:Functional:cnu_ib_lut_ram} -tclbatch cnu_ib_lut_ram.tcl -protoinst "protoinst_files/IB_RAM.protoinst" -log simulate.log"
xsim cnu_ib_lut_ram_behav -key {Behavioral:sim_1:Functional:cnu_ib_lut_ram} -tclbatch cnu_ib_lut_ram.tcl -protoinst "protoinst_files/IB_RAM.protoinst" -log simulate.log
