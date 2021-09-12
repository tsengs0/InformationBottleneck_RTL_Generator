import csv
import subprocess
import numpy as np
import math
import json

cmd_mkdir = 'mkdir '
cmd_move = 'mv '
cmd_copy = 'cp -a '
template_copy_dir = '/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/RTL/BSP/permutation_network'

'''
    Funtion Summary
A) QSN generator
    Reference: Chen, Xiaoheng, Shu Lin, and Venkatesh Akella. "QSN—A simple circular-shift network for reconfigurable quasi-cyclic LDPC decoders." IEEE Transactions on Circuits and Systems II: Express Briefs 57.10 (2010): 782-786.
    1) HDL generator constructing Left Shift Network
    2) HDL generator constructing Right Shift Network
    3) HDL generator constructing Merge Network
    4) HDL generator constructing Permutation Controller
    5) HDL generator constructing QSN top module
    6) Test Pattern Generator
    7) DUT readfile for SystemVerilog based TestBench results
'''

def left_shift_hdl_gen(out_bitwidth, in_bitwidth, sel_bitwidth, permutation_length, bs_pipeline_stage):
    ## To determine the location of pipeline stage
    pipe_loc = np.zeros(sel_bitwidth, dtype=np.bool)
    pipe_reg_num = bs_pipeline_stage-1 # N pipeline stages require insertion of (N-1) pipeline registers
    critical_path = math.ceil(sel_bitwidth/bs_pipeline_stage)
    propagate_cnt = 1
    pipe_insert_cnt = 0;
    for mux_id in reversed(range(sel_bitwidth)):
        if(propagate_cnt == critical_path and pipe_insert_cnt < pipe_reg_num):
            pipe_loc[mux_id] = True
            propagate_cnt = 1
            pipe_insert_cnt = pipe_insert_cnt+1
        else:
            pipe_loc[mux_id] = False
            propagate_cnt = propagate_cnt+1


    # To create the Verilog module file
    hdl_filename = 'qsn_left_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_left_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in,\n" +
                 "\tinput wire [" + str(sel_bitwidth-1) + ":0] sel,\n"+
                 "\tinput wire " + "sys_clk,\n" +
                 "\tinput wire " + "rstn\n);\n"
                 )

    # Construction of multiplexer stages where the stage depth is ceil(log2(permutation_length))
    pipe_insert_cnt = 0
    propagate_cnt = 0
    for i in reversed(range(sel_bitwidth)):
        # Each stage contains (|permuation|-2^i) multiplexers
        mux_num = permutation_length-2**(i)

        if i == (sel_bitwidth-1):
            hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
            # Intermediate results of multiplexers in the current stage
            hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2 ** (i)
                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? sw_in[" + str(mux_in_1) + "] : sw_in[" + str(mux_in_0) + "];\n")
        else:
            # The selector signals ought to be pipelined as well, if it precedent mux stage was pipelined
            if (pipe_insert_cnt > 0):
                if (pipe_insert_cnt == 1):
                    hdl_fd.write("\n")
                    # To insert pipeline registers on sw_in data for input sources of some multiplexers in the upcoming mux stage
                    if(propagate_cnt == 0):
                        for swIn_reg_id in range(mux_num+(2**i)):
                            if(swIn_reg_id > (mux_num_prev-1)):
                                swIn_regLoc_str = "sw_in_" + str(swIn_reg_id) + "_reg"+str(pipe_insert_cnt-1)
                                hdl_fd.write("\treg "+swIn_regLoc_str+"; ")
                                hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) "+swIn_regLoc_str+" <= 0; else "+swIn_regLoc_str+" <= sw_in["+str(swIn_reg_id)+"]; end\n")
                    hdl_fd.write("\n\treg sel_" + str(i) + "_reg" + str(pipe_insert_cnt - 1) + ";\n")
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(pipe_insert_cnt-1) + " <= 0; else sel_" + str(i) + "_reg" + str(pipe_insert_cnt-1) + " <= sel[" + str(i) + "]; end\t")

                else:
                    hdl_fd.write("\n")
                    # To insert pipeline registers on sw_in data for input sources of some multiplexers in the upcoming mux stage
                    if(propagate_cnt == 0):
                        for swIn_reg_id in range(mux_num+(2**i)):
                            if (swIn_reg_id > (mux_num_prev - 1)):
                                swIn_regLoc_str = "sw_in_" + str(swIn_reg_id) + "_reg" + str(pipe_insert_cnt - 1)
                                hdl_fd.write("\treg " + swIn_regLoc_str + "; ")
                                hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) " + swIn_regLoc_str + " <= 0; else " + swIn_regLoc_str + " <= sw_in_" + str(swIn_reg_id) + "_reg"+str(pipe_insert_cnt-2)+"; end\n")
                    # To insert pipeline registers on selector signals of the corresponding mux stage
                    for sel_pipe_id in range(pipe_insert_cnt):
                        hdl_fd.write("\n\treg sel_" + str(i) + "_reg" + str(sel_pipe_id) + "; ")
                        if(sel_pipe_id == 0):
                            hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= 0; else sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= sel[" + str(i) + "]; end\t")
                        else:
                            hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= 0; else sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= sel_" + str(i) + "_reg" + str(sel_pipe_id-1) + "; end\t")

                hdl_fd.write("\n")

            # Intermediate results of multiplexers in the current stage
            hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
            if (pipe_loc[i] == True):
                hdl_fd.write("\treg [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")
            else:
                hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")

            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2**(i)

                # Input source of mux_in_0 is either mux_out of previous stage or sw_in
                if mux_in_0 <= (mux_num_prev-1):
                    mux_in_0 = "mux_stage_" + str(i+1) + "[" + str(mux_in_0) + "]"
                else:
                    if(pipe_insert_cnt == 0):
                        mux_in_0 = "sw_in[" + str(mux_in_0) + "]"
                    else:
                        mux_in_0 = "sw_in_" + str(mux_in_0) + "_reg"+str(pipe_insert_cnt-1)

                # Input source of mux_in_1 is either mux_out of previous stage or sw_in
                if mux_in_1 <= (mux_num_prev-1):
                    mux_in_1 = "mux_stage_" + str(i+1) + "[" + str(mux_in_1) + "]"
                else:
                    if(pipe_insert_cnt == 0):
                        mux_in_1 = "sw_in[" + str(mux_in_1) + "]"
                    else:
                        mux_in_1 = "sw_in_" + str(mux_in_1) + "_reg"+str(pipe_insert_cnt-1)

                # Insertin of pipeline registers at this multiplexer stage
                if (pipe_loc[i] == True and pipe_insert_cnt > 0):
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) mux_stage_" + str(i) + "[" + str(j) + "] <= 0; " +
                                 "else if(sel_" + str(i) + "_reg"+str(pipe_insert_cnt-1)+" == 1'b1) mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_1 + "; " +
                                 "else mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_0 + "; end\n")
                elif (pipe_loc[i] == True and pipe_insert_cnt == 0):
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) mux_stage_" + str(i) + "[" + str(j) + "] <= 0; " +
                                 "else if(sel[" + str(i) + "] == 1'b1) mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_1 + "; " +
                                 "else mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_0 + "; end\n")
                else:
                    if(pipe_insert_cnt > 0):
                        hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel_" + str(i) + "_reg"+str(pipe_insert_cnt-1)+" == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")
                    else:
                        hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")


            if (pipe_loc[i] == True):
                pipe_insert_cnt = pipe_insert_cnt+1
                propagate_cnt = 0
            else:
                propagate_cnt = propagate_cnt+1

        # To keep the number of multiplexers for configuration of next stage
        mux_num_prev = mux_num

    hdl_fd.write("\n\tassign sw_out[" + str(out_bitwidth-1) + ":0] = mux_stage_0[" + str(out_bitwidth-1) + ":0];\n")
    hdl_fd.write("endmodule")
    hdl_fd.close()


def right_shift_hdl_gen(out_bitwidth, in_bitwidth, sel_bitwidth, permutation_length, bs_pipeline_stage):
    ## To determine the location of pipeline stage
    pipe_loc = np.zeros(sel_bitwidth, dtype=np.bool)
    pipe_reg_num = bs_pipeline_stage-1 # N pipeline stages require insertion of (N-1) pipeline registers
    critical_path = math.floor(sel_bitwidth/bs_pipeline_stage)
    propagate_cnt = 1
    pipe_insert_cnt = 0;
    for mux_id in reversed(range(sel_bitwidth)):
        if(propagate_cnt == critical_path and pipe_insert_cnt < pipe_reg_num):
            pipe_loc[mux_id] = True
            propagate_cnt = 1
            pipe_insert_cnt = pipe_insert_cnt+1
        else:
            pipe_loc[mux_id] = False
            propagate_cnt = propagate_cnt+1


    # To create the Verilog module file
    hdl_filename = 'qsn_right_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_right_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in,\n" +
                 "\tinput wire [" + str(sel_bitwidth-1) + ":0] sel,\n"+
                 "\tinput wire " + "sys_clk,\n" +
                 "\tinput wire " + "rstn\n);\n"
                 )

    # Construction of multiplexer stages where the stage depth is ceil(log2(permutation_length))
    pipe_insert_cnt = 0
    propagate_cnt = 0
    for i in reversed(range(sel_bitwidth)):
        # Each stage contains (|permuation|-2^i) multiplexers
        mux_num = permutation_length-2**(i)

        if i == (sel_bitwidth-1):
            hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
            # Intermediate results of multiplexers in the current stage
            hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_0 = permutation_length-mux_in_0-1 # reverse the order of sw_in
                mux_in_1 = j + 2**(i)
                mux_in_1 = permutation_length-mux_in_1-1 # reverse the oerder of sw_in
                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? sw_in[" + str(mux_in_1) + "] : sw_in[" + str(mux_in_0) + "];\n")
        else:
            # The selector signals ought to be pipelined as well, if it precedent mux stage was pipelined
            if (pipe_insert_cnt > 0):
                if (pipe_insert_cnt == 1):
                    hdl_fd.write("\n")
                    # To insert pipeline registers on sw_in data for input sources of some multiplexers in the upcoming mux stage
                    if(propagate_cnt == 0):
                        for swIn_reg_id in range(mux_num+(2**i)):
                            if(swIn_reg_id > (mux_num_prev-1)):
                                temp = permutation_length - swIn_reg_id - 1  # reverse the order of sw_in
                                swIn_regLoc_str = "sw_in_" + str(temp) + "_reg"+str(pipe_insert_cnt-1)
                                hdl_fd.write("\treg "+swIn_regLoc_str+"; ")
                                hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) "+swIn_regLoc_str+" <= 0; else "+swIn_regLoc_str+" <= sw_in["+str(temp)+"]; end\n")
                    hdl_fd.write("\n\treg sel_" + str(i) + "_reg" + str(pipe_insert_cnt - 1) + ";\n")
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(pipe_insert_cnt-1) + " <= 0; else sel_" + str(i) + "_reg" + str(pipe_insert_cnt-1) + " <= sel[" + str(i) + "]; end\t")

                else:
                    hdl_fd.write("\n")
                    # To insert pipeline registers on sw_in data for input sources of some multiplexers in the upcoming mux stage
                    if(propagate_cnt == 0):
                        for swIn_reg_id in range(mux_num+(2**i)):
                            if (swIn_reg_id > (mux_num_prev - 1)):
                                temp = permutation_length - swIn_reg_id - 1  # reverse the order of sw_in
                                swIn_regLoc_str = "sw_in_" + str(temp) + "_reg" + str(pipe_insert_cnt - 1)
                                hdl_fd.write("\treg " + swIn_regLoc_str + "; ")
                                hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) " + swIn_regLoc_str + " <= 0; else " + swIn_regLoc_str + " <= sw_in_" + str(temp) + "_reg"+str(pipe_insert_cnt-2)+"; end\n")
                    # To insert pipeline registers on selector signals of the corresponding mux stage
                    for sel_pipe_id in range(pipe_insert_cnt):
                        hdl_fd.write("\n\treg sel_" + str(i) + "_reg" + str(sel_pipe_id) + "; ")
                        if(sel_pipe_id == 0):
                            hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= 0; else sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= sel[" + str(i) + "]; end\t")
                        else:
                            hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= 0; else sel_" + str(i) + "_reg" + str(sel_pipe_id) + " <= sel_" + str(i) + "_reg" + str(sel_pipe_id-1) + "; end\t")

                hdl_fd.write("\n")

            # Intermediate results of multiplexers in the current stage
            hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
            if (pipe_loc[i] == True):
                hdl_fd.write("\treg [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")
            else:
                hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")

            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2**(i)

                # Input source of mux_in_0 is either mux_out of previous stage or sw_in
                if mux_in_0 <= (mux_num_prev-1):
                    mux_in_0 = "mux_stage_" + str(i+1) + "[" + str(mux_in_0) + "]"
                else:
                    if(pipe_insert_cnt == 0):
                        mux_in_0 = permutation_length - mux_in_0 - 1  # reverse the order of sw_in
                        mux_in_0 = "sw_in[" + str(mux_in_0) + "]"
                    else:
                        mux_in_0 = permutation_length - mux_in_0 - 1  # reverse the order of sw_in
                        mux_in_0 = "sw_in_" + str(mux_in_0) + "_reg"+str(pipe_insert_cnt-1)

                # Input source of mux_in_1 is either mux_out of previous stage or sw_in
                if mux_in_1 <= (mux_num_prev-1):
                    mux_in_1 = "mux_stage_" + str(i+1) + "[" + str(mux_in_1) + "]"
                else:
                    if(pipe_insert_cnt == 0):
                        mux_in_1 = permutation_length - mux_in_1 - 1  # reverse the oerder of sw_in
                        mux_in_1 = "sw_in[" + str(mux_in_1) + "]"
                    else:
                        mux_in_1 = permutation_length - mux_in_1 - 1  # reverse the oerder of sw_in
                        mux_in_1 = "sw_in_" + str(mux_in_1) + "_reg"+str(pipe_insert_cnt-1)

                # Insertin of pipeline registers at this multiplexer stage
                if (pipe_loc[i] == True and pipe_insert_cnt > 0):
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) mux_stage_" + str(i) + "[" + str(j) + "] <= 0; " +
                                 "else if(sel_" + str(i) + "_reg"+str(pipe_insert_cnt-1)+" == 1'b1) mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_1 + "; " +
                                 "else mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_0 + "; end\n")
                elif (pipe_loc[i] == True and pipe_insert_cnt == 0):
                    hdl_fd.write("\talways @(posedge sys_clk) begin if(!rstn) mux_stage_" + str(i) + "[" + str(j) + "] <= 0; " +
                                 "else if(sel[" + str(i) + "] == 1'b1) mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_1 + "; " +
                                 "else mux_stage_" + str(i) + "[" + str(j) + "] <= " + mux_in_0 + "; end\n")
                else:
                    if(pipe_insert_cnt > 0):
                        hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel_" + str(i) + "_reg"+str(pipe_insert_cnt-1)+" == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")
                    else:
                        hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")


            if (pipe_loc[i] == True):
                pipe_insert_cnt = pipe_insert_cnt+1
                propagate_cnt = 0
            else:
                propagate_cnt = propagate_cnt+1

        # To keep the number of multiplexers for configuration of next stage
        mux_num_prev = mux_num

    hdl_fd.write("\n\tassign sw_out[" + str(out_bitwidth-1) + ":0] = {sw_in_0_reg"+str(pipe_reg_num-1)+", mux_stage_0[" + str(out_bitwidth-2) + ":0]};\n")
    hdl_fd.write("endmodule")
    hdl_fd.close()

def merge_mux_hdl_gen(out_bitwidth, left_in_bitwidth, right_in_bitwidth, sel_bitwidth, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'qsn_merge_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_merge_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(left_in_bitwidth-1) + ":0] left_in,\n" +
                 "\tinput wire [" + str(right_in_bitwidth-1) + ":0] right_in,\n" +
                 "\tinput wire [" + str(sel_bitwidth-1) + ":0] sel\n);\n\n")

    for i in range(permutation_length-1):
        right_in = "right_in[" + str(permutation_length-i-1) + "]"
        left_in = "left_in[" + str(i) + "]"
        hdl_fd.write("\tassign sw_out[" + str(i) + "] = (sel[" + str(i) + "] == 1'b0) ? " + right_in + " : " + left_in + ";\n")

    hdl_fd.write("\tassign sw_out[" + str(permutation_length-1) + "] = right_in[0];\n" +
                 "endmodule")

    hdl_fd.close()

def qsn_controller_hdl_gen(left_sel_bitwidth, right_sel_bitwidth, merge_sel_bitwidth, shift_factor_bitwidth, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'qsn_controller_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_controller_" + str(permutation_length) + "b #(\n" +
                 "\tparameter [$clog2(" + str(permutation_length) + ")-1:0] PERMUTATION_LENGTH = " + str(permutation_length) +"\n) (\n"+
                 "\toutput reg [" + str(left_sel_bitwidth-1) + ":0] left_sel,\n" +
                 "\toutput reg [" + str(right_sel_bitwidth-1) + ":0] right_sel,\n" +
                 "\toutput reg [" + str(merge_sel_bitwidth-1) + ":0] merge_sel,\n" +
                 "\tinput wire [" + str(shift_factor_bitwidth-1) + ":0] shift_factor,\n" +
                 "\tinput wire rstn,\n" +
                 "\tinput wire sys_clk\n);\n\n")

    hdl_fd.write("\twire shifter_nonzero;\n" +
                 "\tassign shifter_nonzero = (|shift_factor[" + str(shift_factor_bitwidth-1) + ":0]);\n\n")

    ## To write control signals of Left Shift Network
    hdl_fd.write("\talways @(posedge sys_clk) begin\n" +
                 "\t\tif(!rstn) left_sel <= 0;\n" +
                 "\t\telse if(shifter_nonzero == 1'b1) begin\n" +
                 "\t\t\tleft_sel  <= shift_factor;\n" +
                 "\t\tend\n"
                 "\t\telse begin\n" +
                 "\t\t\tleft_sel  <= 0;\n" +
                 "\t\tend\n" +
                 "\tend\n")
    ## To write control signals of Right Shift Network
    hdl_fd.write("\talways @(posedge sys_clk) begin\n" +
                 "\t\tif(!rstn) right_sel <= 0;\n" +
                 "\t\telse if(shifter_nonzero == 1'b1) begin\n" +
                 "\t\t\tright_sel <=  "+ str(permutation_length) + "-shift_factor;\n" +
                 "\t\tend\n"
                 "\t\telse begin\n" +
                 "\t\t\tright_sel <= 0;\n" +
                 "\t\tend\n" +
                 "\tend\n")
    ## To write control signals of Merge Network
    hdl_fd.write("\talways @(posedge sys_clk) begin\n" +
                 "\t\tif(!rstn) merge_sel <= 0;\n" +
                 "\t\telse if(shifter_nonzero == 1'b1) begin\n" +
                 "\t\t\tcase(shift_factor[" + str(shift_factor_bitwidth-1) + ":0])\n")

    merge_sel_bitwidth = permutation_length-1
    format_argument = "0"+str(merge_sel_bitwidth)+"b"
    for i in range(1, permutation_length):
        merge_sel_temp = format(2**(permutation_length-i) - 1, format_argument)
        lut_case = str(i) + "\t:\t merge_sel[" + str(merge_sel_bitwidth-1) + ":0] = "+str(merge_sel_bitwidth)+"'b" + merge_sel_temp + ";\n";
        hdl_fd.write("\t\t\t\t" + lut_case)

    hdl_fd.write("\t\t\t\tdefault\t:\tmerge_sel[" + str(merge_sel_bitwidth-1) + ":0] = 0;\n" +
                 "\t\t\tendcase // shift_factor\n" +
                 "\t\tend\n"
                 "\t\telse begin\n" +
                 "\t\t\tmerge_sel[" + str(merge_sel_bitwidth-1) + ":0] <= {" + str(merge_sel_bitwidth) + "{1'b1}};\n" +
                 "\t\tend\n" +
                 "\tend\n")

    hdl_fd.write("endmodule")
    hdl_fd.close()

def qsn_top_hdl_gen(out_bitwidth, in_bitwidth, shift_sel_bitwidth, merge_sel_bitwidth, permutation_length, quant):
    # To create the Verilog module file
    hdl_filename = 'qsn_top_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_top_" + str(permutation_length) + "b (\n")

    for q in range(quant):
        hdl_fd.write("\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out_bit" + str(q) + ",\n")
        if q == quant-1:
            hdl_fd.write("\n")

    for q in range(quant):
        hdl_fd.write("\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in_bit" + str(q) + ",\n")

    hdl_fd.write("\tinput wire [" + str(shift_sel_bitwidth-1) + ":0] left_sel,\n" +
                 "\tinput wire [" + str(shift_sel_bitwidth-1) + ":0] right_sel,\n" +
                 "\tinput wire [" + str(merge_sel_bitwidth-1) + ":0] merge_sel\n);\n\n")

    hdl_fd.write("\twire [" + str(permutation_length - 1) + ":0] sw_in_reg[0:" + str(quant - 1) + "];\n" +
                 "\twire [" + str(permutation_length - 1) + ":0] sw_out_reg[0:" + str(quant - 1) + "];\n")

    # Generate for-loop block in order to instatiate QSN of q-bit bitwidth
    hdl_fd.write("\tgenvar i;\n"+
                 "\tgenerate\n" +
                 "\t\tfor(i=0;i<" + str(quant) + ";i=i+1) begin : bs_bitwidth_inst\n")

    left_out_bitwidth = permutation_length-1
    hdl_fd.write("\t\t// Instantiation of Left Shift Network\n")
    hdl_fd.write("\t\twire [" + str(left_out_bitwidth-1) + ":0] left_sw_out;\n" +
                 "\t\tqsn_left_" + str(permutation_length) + "b qsn_left_u0 (\n" +
                 "\t\t\t.sw_out (left_sw_out[" + str(left_out_bitwidth-1) + ":0]),\n\n"+
                 "\t\t\t.sw_in (sw_in_reg[i]),\n" +
                 "\t\t\t.sel (left_sel[" + str(shift_sel_bitwidth-1) + ":0])\n"+
                 "\t\t);\n")

    right_out_bitwidth = permutation_length
    hdl_fd.write("\t\t// Instantiation of Right Shift Network\n")
    hdl_fd.write("\t\twire [" + str(right_out_bitwidth) + ":0] right_sw_out;\n" +
                 "\t\tqsn_right_" + str(permutation_length) + "b qsn_right_u0 (\n" +
                 "\t\t\t.sw_out (right_sw_out[" + str(right_out_bitwidth-1) + ":0]),\n\n"+
                 "\t\t\t.sw_in (sw_in_reg[i]),\n" +
                 "\t\t\t.sel (right_sel[" + str(shift_sel_bitwidth-1) + ":0])\n"+
                 "\t\t);\n")

    hdl_fd.write("\t\t// Instantiation of Merge Network\n"+
                 "\t\tqsn_merge_" + str(permutation_length) + "b qsn_merge_u0 (\n" +
                 "\t\t\t.sw_out (sw_out_reg[i]),\n\n" +
                 "\t\t\t.left_in (left_sw_out[" + str(left_out_bitwidth - 1) + ":0]),\n" +
                 "\t\t\t.right_in (right_sw_out[" + str(right_out_bitwidth - 1) + ":0]),\n" +
                 "\t\t\t.sel (merge_sel[" + str(merge_sel_bitwidth - 1) + ":0])\n" +
                 "\t\t);\n")
    hdl_fd.write("\t\tend\n"+
                 "\tendgenerate\n\n")

    for q in range(quant):
        hdl_fd.write("\tassign sw_in_reg[" + str(q) + "] = sw_in_bit" + str(q) + "[" + str(permutation_length-1) + ":0];\n")
    for q in range(quant):
        hdl_fd.write("\tassign sw_out_bit" + str(q) + "[" + str(permutation_length-1) + ":0] = sw_out_reg[" + str(q) + "];\n")

    hdl_fd.write("endmodule")
    hdl_fd.close()

def main():
    q = 4  # 4-bit quantisation
    Pc=255
    bs_pipeline_stage = 3
    sel_bitwidth = math.ceil(math.log2(Pc))
    left_shift_hdl_gen(out_bitwidth=Pc-1, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc, bs_pipeline_stage=bs_pipeline_stage)
    right_shift_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc, bs_pipeline_stage=bs_pipeline_stage)
    merge_mux_hdl_gen(out_bitwidth=Pc, left_in_bitwidth=Pc-1, right_in_bitwidth=Pc, sel_bitwidth=Pc-1, permutation_length=Pc)
    qsn_top_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, shift_sel_bitwidth=sel_bitwidth, merge_sel_bitwidth=Pc-1, permutation_length=Pc, quant=q)
    qsn_controller_hdl_gen(left_sel_bitwidth=sel_bitwidth, right_sel_bitwidth=sel_bitwidth, merge_sel_bitwidth=Pc-1, shift_factor_bitwidth=math.ceil(math.log2(Pc-1)), permutation_length=Pc)

    #subprocess.call(cmd_move + "./*.v " + template_copy_dir + "/", shell=True)

if __name__ == "__main__":
    main()
