#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/s1820419/Xilinx/Vitis/2019.2/bin:/home/s1820419/Xilinx/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/s1820419/Xilinx/Vivado/2019.2/bin
else
  PATH=/home/s1820419/Xilinx/Vitis/2019.2/bin:/home/s1820419/Xilinx/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/s1820419/Xilinx/Vivado/2019.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.runs/mem_subsys_blk_mem_gen_0_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log mem_subsys_blk_mem_gen_0_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source mem_subsys_blk_mem_gen_0_0.tcl
