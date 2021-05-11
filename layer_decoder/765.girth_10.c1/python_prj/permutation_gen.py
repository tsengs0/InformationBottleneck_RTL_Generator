import csv
import subprocess
import numpy as np
import math
import json

'''
    Funtion Summary
A) QSN generator
    Ref.: Chen, Xiaoheng, Shu Lin, and Venkatesh Akella. "QSN—A simple circular-shift network for reconfigurable quasi-cyclic LDPC decoders." IEEE Transactions on Circuits and Systems II: Express Briefs 57.10 (2010): 782-786.
    1) HDL generator constructing Left Shift Network
    2) HDL generator constructing Right Shift Network
    3) HDL generator constructing Merge Network
    4) HDL generator constructing Permutation Controller
    5) HDL generator constructing QSN top module
    6) Test Pattern Generator
    7) DUT readfile for SystemVerilog based TestBench results
'''

def left_shift_hdl_gen(out_bitwidth, in_bitwidth, sel_bitwidth, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'qsn_left_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_left_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in,\n" +
                 "\tinput wire [" + str(sel_bitwidth-1) + ":0] sel\n);\n")

    # Construction of multiplexer stages where the stage depth is ceil(log2(permutation_length))
    for i in reversed(range(sel_bitwidth)):
        # Each stage contains (|permuation|-2^i) multiplexers
        mux_num = permutation_length-2**(i)
        hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
        # Intermediate results of multiplexers in the current stage
        hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")

        if i == (sel_bitwidth-1):
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2**(i)
                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? sw_in[" + str(mux_in_1) + "] : sw_in[" + str(mux_in_0) + "];\n")
        else:
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2**(i)

                # Input source of mux_in_0 is either mux_out of previous stage or sw_in
                if mux_in_0 <= (mux_num_prev-1):
                    mux_in_0 = "mux_stage_" + str(i+1) + "[" + str(mux_in_0) + "]"
                else:
                    mux_in_0 = "sw_in[" + str(mux_in_0) + "]"
                # Input source of mux_in_1 is either mux_out of previous stage or sw_in
                if mux_in_1 <= (mux_num_prev-1):
                    mux_in_1 = "mux_stage_" + str(i+1) + "[" + str(mux_in_1) + "]"
                else:
                    mux_in_1 = "sw_in[" + str(mux_in_1) + "]"

                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")

        # To keep the number of multiplexers for configuration of next stage
        mux_num_prev = mux_num

    hdl_fd.write("\n\tassign sw_out[" + str(out_bitwidth-1) + ":0] = mux_stage_0[" + str(out_bitwidth-1) + ":0];\n")
    hdl_fd.write("endmodule")
    hdl_fd.close()

def right_shift_hdl_gen(out_bitwidth, in_bitwidth, sel_bitwidth, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'qsn_right_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_right_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in,\n" +
                 "\tinput wire [" + str(sel_bitwidth-1) + ":0] sel\n);\n")

    # Construction of multiplexer stages where the stage depth is ceil(log2(permutation_length))
    for i in reversed(range(sel_bitwidth)):
        # Each stage contains (|permuation|-2^i) multiplexers
        mux_num = permutation_length-2**(i)
        hdl_fd.write("\n\t// Multiplexer Stage " + str(i) + "\n")
        # Intermediate results of multiplexers in the current stage
        hdl_fd.write("\twire [" + str(mux_num - 1) + ":0] mux_stage_" + str(i) + ";\n")

        if i == (sel_bitwidth-1):
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_0 = permutation_length-mux_in_0-1 # reverse the order of sw_in
                mux_in_1 = j + 2**(i)
                mux_in_1 = permutation_length-mux_in_1-1 # reverse the oerder of sw_in
                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? sw_in[" + str(mux_in_1) + "] : sw_in[" + str(mux_in_0) + "];\n")
        else:
            for j in range(mux_num):
                mux_in_0 = j
                mux_in_1 = j + 2**(i)

                # Input source of mux_in_0 is either mux_out of previous stage or sw_in
                if mux_in_0 <= (mux_num_prev-1):
                    mux_in_0 = "mux_stage_" + str(i+1) + "[" + str(mux_in_0) + "]"
                else:
                    mux_in_0 = permutation_length - mux_in_0 - 1  # reverse the order of sw_in
                    mux_in_0 = "sw_in[" + str(mux_in_0) + "]"
                # Input source of mux_in_1 is either mux_out of previous stage or sw_in
                if mux_in_1 <= (mux_num_prev-1):
                    mux_in_1 = "mux_stage_" + str(i+1) + "[" + str(mux_in_1) + "]"
                else:
                    mux_in_1 = permutation_length - mux_in_1 - 1  # reverse the oerder of sw_in
                    mux_in_1 = "sw_in[" + str(mux_in_1) + "]"

                hdl_fd.write("\tassign mux_stage_" + str(i) + "[" + str(j) + "] = (sel[" + str(i) + "] == 1'b1) ? " + mux_in_1 + " : " + mux_in_0 + ";\n")

        # To keep the number of multiplexers for configuration of next stage
        mux_num_prev = mux_num

    hdl_fd.write("\n\tassign sw_out[" + str(out_bitwidth-1) + ":0] = {sw_in[0], mux_stage_0[" + str(out_bitwidth-2) + ":0]};\n")
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

def qsn_top_hdl_gen(out_bitwidth, in_bitwidth, shift_sel_bitwidth, merge_sel_bitwidth, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'qsn_top_' + str(permutation_length) + 'b.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module qsn_top_" + str(permutation_length) + "b (\n" +
                 "\toutput wire [" + str(out_bitwidth-1) + ":0] sw_out,\n\n" +
                 "\tinput wire [" + str(in_bitwidth-1) + ":0] sw_in,\n" +
                 "\tinput wire [" + str(shift_sel_bitwidth-1) + ":0] left_sel,\n" +
                 "\tinput wire [" + str(shift_sel_bitwidth-1) + ":0] right_sel,\n" +
                 "\tinput wire [" + str(merge_sel_bitwidth-1) + ":0] merge_sel\n);\n\n")

    left_out_bitwidth = permutation_length-1
    hdl_fd.write("\t// Instantiation of Left Shift Network\n")
    hdl_fd.write("\twire [" + str(left_out_bitwidth-1) + ":0] left_sw_out;\n" +
                 "\tqsn_left_" + str(permutation_length) + "b qsn_left_u0 (\n" +
                 "\t\t.sw_out (left_sw_out[" + str(left_out_bitwidth-1) + ":0]),\n\n"+
                 "\t\t.sw_in (sw_in[" + str(in_bitwidth-1) + ":0]),\n" +
                 "\t\t.sel (left_sel[" + str(shift_sel_bitwidth-1) + ":0])\n"+
                 "\t);\n")

    right_out_bitwidth = permutation_length
    hdl_fd.write("\t// Instantiation of Right Shift Network\n")
    hdl_fd.write("\twire [" + str(right_out_bitwidth) + ":0] right_sw_out;\n" +
                 "\tqsn_right_" + str(permutation_length) + "b qsn_right_u0 (\n" +
                 "\t\t.sw_out (right_sw_out[" + str(right_out_bitwidth-1) + ":0]),\n\n"+
                 "\t\t.sw_in (sw_in[" + str(in_bitwidth-1) + ":0]),\n" +
                 "\t\t.sel (right_sel[" + str(shift_sel_bitwidth-1) + ":0])\n"+
                 "\t);\n")

    hdl_fd.write("\t// Instantiation of Merge Network\n"+
                 "\tqsn_merge_" + str(permutation_length) + "b qsn_merge_u0 (\n" +
                 "\t\t.sw_out (sw_out[" + str(out_bitwidth - 1) + ":0]),\n\n" +
                 "\t\t.left_in (left_sw_out[" + str(left_out_bitwidth - 1) + ":0]),\n" +
                 "\t\t.right_in (right_sw_out[" + str(right_out_bitwidth - 1) + ":0]),\n" +
                 "\t\t.sel (merge_sel[" + str(merge_sel_bitwidth - 1) + ":0])\n" +
                 "\t);\n")

    hdl_fd.write("endmodule")
    hdl_fd.close()

def main():
    Pc = 85
    left_shift_hdl_gen(out_bitwidth=Pc - 1, in_bitwidth=Pc, sel_bitwidth=math.ceil(math.log2(Pc)),
                       permutation_length=Pc)
    right_shift_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, sel_bitwidth=math.ceil(math.log2(Pc)), permutation_length=Pc)
    merge_mux_hdl_gen(out_bitwidth=Pc - 1, left_in_bitwidth=Pc - 1, right_in_bitwidth=Pc, sel_bitwidth=Pc - 1,
                      permutation_length=Pc)


def main():
    Pc=85
    sel_bitwidth = math.ceil(math.log2(Pc))
    left_shift_hdl_gen(out_bitwidth=Pc-1, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc)
    right_shift_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc)
    merge_mux_hdl_gen(out_bitwidth=Pc, left_in_bitwidth=Pc-1, right_in_bitwidth=Pc, sel_bitwidth=Pc-1, permutation_length=Pc)
    qsn_top_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, shift_sel_bitwidth=sel_bitwidth, merge_sel_bitwidth=Pc-1, permutation_length=Pc)

if __name__ == "__main__":
    main()
