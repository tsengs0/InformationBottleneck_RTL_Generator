#!/bin/bash

vivado_dir="/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/BSP/DecodingProcessControl/vivado/fsm_communication/fsm_communication.srcs/sources_1/imports/DecodingProcessControl"

update_file="cnu6_wr_fsm.v vnu3_wr_fsm.v dnu3_wr_fsm.v cnu_wr_update_handshake.v vnu_wr_update_handshake.v sys_control_unit.v"

cp $update_file $vivado_dir/
