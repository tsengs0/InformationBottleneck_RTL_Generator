vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/blk_mem_gen_v8_4_4

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_4 questa_lib/msim/blk_mem_gen_v8_4_4

vlog -work xpm -64 -sv \
"/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../bd/IB_RAM/sim/IB_RAM.v" \

vlog -work blk_mem_gen_v8_4_4 -64 \
"../../../../IB_LUT.srcs/sources_1/bd/IB_RAM/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 \
"../../../bd/IB_RAM/ip/IB_RAM_blk_mem_gen_1_0/sim/IB_RAM_blk_mem_gen_1_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

