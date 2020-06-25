# InformationBottleneck_RTL_Generator


### AXI DMA IP for communication between PL and PS via a BRAM-based FIFO buffer
1. The AXI IP that bridges the communication from PL to PS is placed in the following directory:
	* (Vivado IP package) /home/s1820419/LDPC_MinorResearch/pl_ps_dma/mycores/ip_repo
	* (Vitis SDK workspce) /home/s1820419/Xilinx/Vivado/project/AXI.UART.customIP/sdk/pl_to_ps_xilinx_fifo_system_rev1_system

In the above IP, there is one FIFO buffer in between PL and PS. Once the computation is done in PL side, PL can forward the result to that FIFO buffer and then the FIFO buffer will sequantially send the data to PS DRAM via AXI DMA.
