# InformationBottleneck_RTL_Generator


### AXI DMA IP for communication between PL and PS via a BRAM-based FIFO buffer
1. The AXI IP that bridges the communication from PL to PS is placed in the following directory:
	* (Vivado IP package) /home/s1820419/LDPC_MinorResearch/pl_ps_dma/mycores/ip_repo
	* (Vitis SDK workspce) /home/s1820419/Xilinx/Vivado/project/AXI.UART.customIP/sdk/pl_to_ps_xilinx_fifo_system_rev1_system

In the above IP, there is one FIFO buffer in between PL and PS. Once the computation is done in PL side, PL can forward the result to that FIFO buffer and then the FIFO buffer will sequantially send the data to PS DRAM via AXI DMA.

### Utilisation (14.AUG.2020)
(N=204)
Module | LUTRAM (origin) | LUT Logic (origin) 
------ | ------ | ---------
vnu3   | 16,320 (16,320)	| 9680
vnu3+dnu | 17,136 (17,952) | 11,584
cnu6   | 8,568 (22,848)	| 5206 (14,792)
symbol_generator(x100) | 4400 | 28500
------ | ------ | ---------
total (without DNUs) | 29,288  | 43,329
total (with DNUs) | 30,104 | 43,605
utilisation (without decision nodes) | 28.781% | 33.612%
utilisation (with DNUs) | 29.5833% | 33.8969%
utilisation of LUT (without DNUs) | 31.478% ||
utilisation of LUT (with DNUs) | 31.9918% ||

(N=204*3=612)	
Module | LUTRAM | LUT Logic
------ | ------ | ---------
total (without DNUs)  | 79,064	| 72,714
total (with DNUs)  | 81,512	| 73,815
utilisation (without DNUs) | 77.697% | 56.525%
utilisation (with DNUs) | 80.1022% | 57.3811%
utilisation of LUT (without DNUs) | 65.876% ||
utilisation of LUT (with DNUs) | 67.4162% ||


Module | LUTRAM (origin) | LUT Logic (origin) 
------ | ------ | ---------
vnu3+dnu | 17,136 (17,952) | 11,584 (12,238)
cnu6   | 8,568 (22,848)	| 5206 (14,792)
symbol_generator(x100) | 4400 | 28500
------ | ------ | ---------
total (with DNUs) | 30,104 (45,200) | 43,605 (55,530)
utilisation (with DNUs) | 29.5833% (44.418%) | 33.8969% (43.167%)
utilisation of LUT (with DNUs) | 31.936% (43.644%) ||

