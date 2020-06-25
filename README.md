# InformationBottleneck_RTL_Generator

The AXI IP that bridges the communication from PL to PS is placed in the following directory:
	# /home/s1820419/LDPC_MinorResearch/pl_ps_dma/mycores/ip_repo
In the above IP, there is one FIFO buffer in between PL and PS. Once the computation is done in PL side, PL can forward the result to that FIFO buffer and then the FIFO buffer will sequantially send the data to PS DRAM via AXI DMA.
