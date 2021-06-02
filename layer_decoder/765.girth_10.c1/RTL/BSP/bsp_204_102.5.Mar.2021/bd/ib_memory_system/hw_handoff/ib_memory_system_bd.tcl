
################################################################
# This is a generated script based on design: ib_memory_system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ib_memory_system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-ffvc1156-2-e
   set_property BOARD_PART xilinx.com:zcu104:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name ib_memory_system

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/BSP/bsp_204_102.5.Mar.2021/bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set cn_iter0_m0_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m0_portA ]

  set cn_iter0_m0_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m0_portB ]

  set cn_iter0_m1_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m1_portA ]

  set cn_iter0_m1_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m1_portB ]

  set cn_iter0_m2_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m2_portA ]

  set cn_iter0_m2_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m2_portB ]

  set cn_iter0_m3_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m3_portA ]

  set cn_iter0_m3_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter0_m3_portB ]

  set cn_iter1_m0_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m0_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m0_portA

  set cn_iter1_m0_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m0_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m0_portB

  set cn_iter1_m1_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m1_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m1_portA

  set cn_iter1_m1_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m1_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m1_portB

  set cn_iter1_m2_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m2_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m2_portA

  set cn_iter1_m2_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m2_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m2_portB

  set cn_iter1_m3_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m3_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m3_portA

  set cn_iter1_m3_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 cn_iter1_m3_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $cn_iter1_m3_portB

  set dn_iter0_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 dn_iter0_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $dn_iter0_portA

  set dn_iter0_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 dn_iter0_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $dn_iter0_portB

  set dn_iter1_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 dn_iter1_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $dn_iter1_portA

  set dn_iter1_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 dn_iter1_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $dn_iter1_portB

  set vn_iter0_m0_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter0_m0_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter0_m0_portA

  set vn_iter0_m0_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter0_m0_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter0_m0_portB

  set vn_iter0_m1_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter0_m1_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter0_m1_portA

  set vn_iter0_m1_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter0_m1_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter0_m1_portB

  set vn_iter1_m0_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter1_m0_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter1_m0_portA

  set vn_iter1_m0_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter1_m0_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter1_m0_portB

  set vn_iter1_m1_portA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter1_m1_portA ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter1_m1_portA

  set vn_iter1_m1_portB [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 vn_iter1_m1_portB ]
  set_property -dict [ list \
   CONFIG.READ_WRITE_MODE {READ_ONLY} \
   ] $vn_iter1_m1_portB


  # Create ports

  # Create instance: cn_iter0_24_func0, and set properties
  set cn_iter0_24_func0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter0_24_func0 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_0_24/lut_Iter0_24_Func0.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter0_24_func0

  # Create instance: cn_iter0_24_func1, and set properties
  set cn_iter0_24_func1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter0_24_func1 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_0_24/lut_Iter0_24_Func1.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter0_24_func1

  # Create instance: cn_iter0_24_func2, and set properties
  set cn_iter0_24_func2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter0_24_func2 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_0_24/lut_Iter0_24_Func2.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter0_24_func2

  # Create instance: cn_iter0_24_func3, and set properties
  set cn_iter0_24_func3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter0_24_func3 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_0_24/lut_Iter0_24_Func3.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter0_24_func3

  # Create instance: cn_iter25_49_func0, and set properties
  set cn_iter25_49_func0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter25_49_func0 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_25_49/lut_Iter25_49_Func0.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter25_49_func0

  # Create instance: cn_iter25_49_func1, and set properties
  set cn_iter25_49_func1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter25_49_func1 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_25_49/lut_Iter25_49_Func1.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter25_49_func1

  # Create instance: cn_iter25_49_func2, and set properties
  set cn_iter25_49_func2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter25_49_func2 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_25_49/lut_Iter25_49_Func2.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter25_49_func2

  # Create instance: cn_iter25_49_func3, and set properties
  set cn_iter25_49_func3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 cn_iter25_49_func3 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.CNU.3bit/Iter_25_49/lut_Iter25_49_Func3.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {4} \
   CONFIG.Read_Width_B {4} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {200} \
   CONFIG.Write_Width_A {4} \
   CONFIG.Write_Width_B {4} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $cn_iter25_49_func3

  # Create instance: dn_iter0_24, and set properties
  set dn_iter0_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 dn_iter0_24 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.DNU.3bit/Iter_0_24/lut_Iter0_24_Func2.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {2} \
   CONFIG.Read_Width_B {2} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {2} \
   CONFIG.Write_Width_B {2} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $dn_iter0_24

  # Create instance: dn_iter25_49, and set properties
  set dn_iter25_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 dn_iter25_49 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.DNU.3bit/Iter_25_49/lut_Iter25_49_Func2.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {2} \
   CONFIG.Read_Width_B {2} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {2} \
   CONFIG.Write_Width_B {2} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $dn_iter25_49

  # Create instance: vn_iter0_24_func0, and set properties
  set vn_iter0_24_func0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 vn_iter0_24_func0 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.VNU.3bit/Iter_0_24/lut_Iter0_24_Func0.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {6} \
   CONFIG.Read_Width_B {6} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {6} \
   CONFIG.Write_Width_B {6} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $vn_iter0_24_func0

  # Create instance: vn_iter0_24_func1, and set properties
  set vn_iter0_24_func1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 vn_iter0_24_func1 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.VNU.3bit/Iter_0_24/lut_Iter0_24_Func1.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {6} \
   CONFIG.Read_Width_B {6} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {6} \
   CONFIG.Write_Width_B {6} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $vn_iter0_24_func1

  # Create instance: vn_iter25_49_func0, and set properties
  set vn_iter25_49_func0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 vn_iter25_49_func0 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.VNU.3bit/Iter_25_49/lut_Iter25_49_Func0.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {6} \
   CONFIG.Read_Width_B {6} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {6} \
   CONFIG.Write_Width_B {6} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $vn_iter25_49_func0

  # Create instance: vn_iter25_49_func1, and set properties
  set vn_iter25_49_func1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 vn_iter25_49_func1 ]
  set_property -dict [ list \
   CONFIG.Algorithm {Minimum_Area} \
   CONFIG.Assume_Synchronous_Clk {true} \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../python_prj/COE_BRAM32.VNU.3bit/Iter_25_49/lut_Iter25_49_Func1.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Enable_B {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Dual_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.RD_ADDR_CHNG_A {false} \
   CONFIG.RD_ADDR_CHNG_B {false} \
   CONFIG.Read_Width_A {6} \
   CONFIG.Read_Width_B {6} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {400} \
   CONFIG.Write_Width_A {6} \
   CONFIG.Write_Width_B {6} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $vn_iter25_49_func1

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTA_0_1 [get_bd_intf_ports cn_iter0_m0_portA] [get_bd_intf_pins cn_iter0_24_func0/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_0_2 [get_bd_intf_ports dn_iter0_portA] [get_bd_intf_pins dn_iter0_24/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_1_1 [get_bd_intf_ports cn_iter0_m1_portA] [get_bd_intf_pins cn_iter0_24_func1/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_1_2 [get_bd_intf_ports dn_iter1_portA] [get_bd_intf_pins dn_iter25_49/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_2_1 [get_bd_intf_ports cn_iter0_m2_portA] [get_bd_intf_pins cn_iter0_24_func2/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_2_2 [get_bd_intf_ports vn_iter0_m0_portA] [get_bd_intf_pins vn_iter0_24_func0/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_3_1 [get_bd_intf_ports cn_iter0_m3_portA] [get_bd_intf_pins cn_iter0_24_func3/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_3_2 [get_bd_intf_ports vn_iter0_m1_portA] [get_bd_intf_pins vn_iter0_24_func1/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_4_1 [get_bd_intf_ports cn_iter1_m0_portA] [get_bd_intf_pins cn_iter25_49_func0/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_4_2 [get_bd_intf_ports vn_iter1_m0_portA] [get_bd_intf_pins vn_iter25_49_func0/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_5_1 [get_bd_intf_ports cn_iter1_m1_portA] [get_bd_intf_pins cn_iter25_49_func1/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_5_2 [get_bd_intf_ports vn_iter1_m1_portA] [get_bd_intf_pins vn_iter25_49_func1/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_6_1 [get_bd_intf_ports cn_iter1_m2_portA] [get_bd_intf_pins cn_iter25_49_func2/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTA_7_1 [get_bd_intf_ports cn_iter1_m3_portA] [get_bd_intf_pins cn_iter25_49_func3/BRAM_PORTA]
  connect_bd_intf_net -intf_net BRAM_PORTB_0_1 [get_bd_intf_ports cn_iter0_m0_portB] [get_bd_intf_pins cn_iter0_24_func0/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_0_2 [get_bd_intf_ports dn_iter0_portB] [get_bd_intf_pins dn_iter0_24/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_1_1 [get_bd_intf_ports cn_iter0_m1_portB] [get_bd_intf_pins cn_iter0_24_func1/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_1_2 [get_bd_intf_ports dn_iter1_portB] [get_bd_intf_pins dn_iter25_49/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_2_1 [get_bd_intf_ports cn_iter0_m2_portB] [get_bd_intf_pins cn_iter0_24_func2/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_2_2 [get_bd_intf_ports vn_iter0_m0_portB] [get_bd_intf_pins vn_iter0_24_func0/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_3_1 [get_bd_intf_ports cn_iter0_m3_portB] [get_bd_intf_pins cn_iter0_24_func3/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_3_2 [get_bd_intf_ports vn_iter0_m1_portB] [get_bd_intf_pins vn_iter0_24_func1/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_4_1 [get_bd_intf_ports cn_iter1_m0_portB] [get_bd_intf_pins cn_iter25_49_func0/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_4_2 [get_bd_intf_ports vn_iter1_m0_portB] [get_bd_intf_pins vn_iter25_49_func0/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_5_1 [get_bd_intf_ports cn_iter1_m1_portB] [get_bd_intf_pins cn_iter25_49_func1/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_5_2 [get_bd_intf_ports vn_iter1_m1_portB] [get_bd_intf_pins vn_iter25_49_func1/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_6_1 [get_bd_intf_ports cn_iter1_m2_portB] [get_bd_intf_pins cn_iter25_49_func2/BRAM_PORTB]
  connect_bd_intf_net -intf_net BRAM_PORTB_7_1 [get_bd_intf_ports cn_iter1_m3_portB] [get_bd_intf_pins cn_iter25_49_func3/BRAM_PORTB]

  # Create port connections

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


