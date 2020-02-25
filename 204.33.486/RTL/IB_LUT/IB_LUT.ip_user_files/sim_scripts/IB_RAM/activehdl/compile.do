vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib
vlib activehdl/blk_mem_gen_v8_4_4

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib
vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4

vlog -work xpm  -sv2k12 \
"/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/IB_RAM/sim/IB_RAM.v" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 \
"../../../../IB_LUT.srcs/sources_1/bd/IB_RAM/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/IB_RAM/ip/IB_RAM_blk_mem_gen_1_0/sim/IB_RAM_blk_mem_gen_1_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

