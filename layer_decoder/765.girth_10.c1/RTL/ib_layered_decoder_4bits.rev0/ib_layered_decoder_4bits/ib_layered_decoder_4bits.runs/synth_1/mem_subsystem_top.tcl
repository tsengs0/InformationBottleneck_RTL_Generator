# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param power.BramSDPPropagationFix 1
set_param power.enableUnconnectedCarry8PinPower 1
set_param power.enableCarry8RouteBelPower 1
set_param power.enableLutRouteBelPower 1
set_param ced.repoPaths /home/s1820419/.Xilinx/Vivado/2019.2/xhub/ced_store
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xczu7ev-ffvc1156-2-e

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.cache/wt [current_project]
set_property parent.project_path /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part_repo_paths {/home/s1820419/.Xilinx/Vivado/2019.2/xhub/board_store} [current_project]
set_property board_part xilinx.com:zcu104:part0:1.1 [current_project]
set_property ip_output_repo /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/BSP/memory_subsystem/column_ram.v
  /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/sources_1/bd/mem_subsys/hdl/mem_subsys_wrapper.v
  /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/BSP/memory_subsystem/page_align_lib.v
  /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/BSP/memory_subsystem/mem_subsystem_lib.v
}
add_files /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/sources_1/bd/mem_subsys/mem_subsys.bd
set_property used_in_implementation false [get_files -all /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/sources_1/bd/mem_subsys/ip/mem_subsys_blk_mem_gen_0_0/mem_subsys_blk_mem_gen_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/sources_1/bd/mem_subsys/mem_subsys_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/constrs_1/imports/zcu104_kit/zcu104_Rev1.0_U1_01302018.xdc
set_property used_in_implementation false [get_files /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/ib_layered_decoder_4bits.rev0/ib_layered_decoder_4bits/ib_layered_decoder_4bits.srcs/constrs_1/imports/zcu104_kit/zcu104_Rev1.0_U1_01302018.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top mem_subsystem_top -part xczu7ev-ffvc1156-2-e


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef mem_subsystem_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file mem_subsystem_top_utilization_synth.rpt -pb mem_subsystem_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
