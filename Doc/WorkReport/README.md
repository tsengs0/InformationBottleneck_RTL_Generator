*Working Progress*  

## Current Focus (9 - 13 Nov., 2020)

The target is this week is to complete the communication context between SYS.FSM and WRITE.FSM, and then make inital decoder start working.
Work Space: s1610106@tlab21:/mnt/fs800/home/s1610105/Documents/research/Doctor/LDPC_MinorResearch/DecodingProcessControl


## Work to be done (latest update: 10 Novemember, 2020)
- [x] valid-ready handshaking communication between SYS.FSM and WRITE.FSM within <span style="color: red">Init-Load Operation</span> and to correctly control all cn-/vn-/dn-ram_write_en signals (outpu ports of WRITE.FSMs) by cn_/vn_/dn_wr signals (output ports of SYS.FSM)
- [] valid-ready handshaking communication between SYS.FSM and WRITE.FSM within <span style="color: red">PIPE-Load OperationI</span> and to correctly control all cn-/vn-/dn-ram_write_en signals (outpu ports of WRITE.FSMs) by cn_/vn_/dn_wr signals (output ports of SYS.FSM)
- [] the rest of control signals of WRITE.FSMs correctly controlled by SYS.FSM including the address-latch counter
- [] the IB-RAMs refresh addresses in a ping-pong manner spatially where SYS.FSM controls them
