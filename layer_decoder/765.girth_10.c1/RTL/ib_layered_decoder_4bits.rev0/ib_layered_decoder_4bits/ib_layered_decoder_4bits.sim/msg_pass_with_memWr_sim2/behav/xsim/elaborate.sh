#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Thu Jun 17 00:15:07 JST 2021
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 3ca43f8b0a264e418cfc5572977c96c6 --incr --debug typical --relax --mt 8 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L util_vector_logic_v2_0_1 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_mem_subsystem_top_submatrix_1_rev1_behav xil_defaultlib.tb_mem_subsystem_top_submatrix_1_rev1 xil_defaultlib.glbl -log elaborate.log"
xelab -wto 3ca43f8b0a264e418cfc5572977c96c6 --incr --debug typical --relax --mt 8 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L util_vector_logic_v2_0_1 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_mem_subsystem_top_submatrix_1_rev1_behav xil_defaultlib.tb_mem_subsystem_top_submatrix_1_rev1 xil_defaultlib.glbl -log elaborate.log

