-makelib xcelium_lib/xpm -sv \
  "/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/s1820419/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../../IB_LUT.srcs/sources_1/bd/IB_RAM/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/IB_RAM/ip/IB_RAM_blk_mem_gen_0_0/sim/IB_RAM_blk_mem_gen_0_0.v" \
  "../../../bd/IB_RAM/sim/IB_RAM.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

