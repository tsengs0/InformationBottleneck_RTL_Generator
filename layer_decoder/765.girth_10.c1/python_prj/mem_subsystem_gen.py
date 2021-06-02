import csv
import subprocess
import numpy as np
import math
import json

'''
    Funtion Summary
    1) HDL generator constructing column-ram module
'''

def column_ram_hdl_gen(quant, permutation_length):
    # To create the Verilog module file
    hdl_filename = 'column_ram.v'
    hdl_fd = open(hdl_filename, "w")
    hdl_fd.write("module column_ram_z" + str(permutation_length) + " #(\n" +
                 "\tparameter QUAN_SIZE = " + str(quant) + ",\n" +
                 "\tparameter CHECK_PARALLELISM = " + str(permutation_length) + ",\n" +
                 "\t")



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

'''
% Output Port
RAM_UNIT_MSG_NUM = 17;
RAM_PORTA_RANGE = 9;
fprintf(".Dout_b ({");
temp=1;
for j=(i+1)*RAM_UNIT_MSG_NUM-1 : -1 : (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE
fprintf("dout_reg[(i+1)*RAM_UNIT_MSG_NUM-%d], ", temp);
temp=temp+1;
end
fprintf("}),\n");

fprintf(".Dout_a ({");
temp=1;
for j=(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1 : -1 : i*RAM_UNIT_MSG_NUM
fprintf("dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-%d], ", temp);
temp=temp+1;
end
fprintf("}),\n");

fprintf("\n")
% Input Port
RAM_UNIT_MSG_NUM = 17;
RAM_PORTA_RANGE = 9;
fprintf(".Din_b ({");
temp=1;
for j=(i+1)*RAM_UNIT_MSG_NUM-1 : -1 : (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE
fprintf("din_reg[(i+1)*RAM_UNIT_MSG_NUM-%d], ", temp);
temp=temp+1;
end
fprintf("}),\n");

fprintf(".Din_a ({");
temp=1;
for j=(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1 : -1 : i*RAM_UNIT_MSG_NUM
fprintf("din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-%d], ", temp);
temp=temp+1;
end
fprintf("}),\n");
'''

def main():
    q = 4  # 4-bit quantisation
    Pc=85
    sel_bitwidth = math.ceil(math.log2(Pc))
    left_shift_hdl_gen(out_bitwidth=Pc-1, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc)
    right_shift_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, sel_bitwidth=sel_bitwidth, permutation_length=Pc)
    merge_mux_hdl_gen(out_bitwidth=Pc, left_in_bitwidth=Pc-1, right_in_bitwidth=Pc, sel_bitwidth=Pc-1, permutation_length=Pc)
    qsn_top_hdl_gen(out_bitwidth=Pc, in_bitwidth=Pc, shift_sel_bitwidth=sel_bitwidth, merge_sel_bitwidth=Pc-1, permutation_length=Pc, quant=q)
    qsn_controller_hdl_gen(left_sel_bitwidth=sel_bitwidth, right_sel_bitwidth=sel_bitwidth, merge_sel_bitwidth=Pc-1, shift_factor_bitwidth=math.ceil(math.log2(Pc-1)), permutation_length=Pc)

if __name__ == "__main__":
    main()
