#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/s1820419/Xilinx/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/s1820419/Xilinx/Vivado/2019.2/bin
else
  PATH=/home/s1820419/Xilinx/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/s1820419/Xilinx/Vivado/2019.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.runs/impl_1'
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

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log ib_lut_in2.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source ib_lut_in2.tcl -notrace


