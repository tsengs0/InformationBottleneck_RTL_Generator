import math
import h5py
import csv
import subprocess

q = 4  # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE - 2
cardinality = pow(2, q)
Iter_max = 50

# Parameters for IB-CNU RAMs accesses
depth_ib_func = cardinality * cardinality
depth_ram = 32
interleave_bank_num = depth_ib_func / depth_ram
BRAM_READ_WIDTH = 36 # 36-bit
BRAM_DEPTH = math.ceil((cardinality*cardinality*q*M)/BRAM_READ_WIDTH)

file_204_102 = 'ib_regular_444_1.300_50_ib_123_10_5_first_none_ib_ib.h5'
file_lut_csv = 'lut_'  # lut_Iter50_Func3.csv
file_lut_coe = 'lut_'  # lut_Iter50_Func3.coe
file_lut_rtl = 'lut_cnu_'
cmd_mkdir = 'mkdir '
cmd_move = 'mv '
cmd_copy = 'cp -a '
f = h5py.File(file_204_102, 'r')
# Show all keys
list(f.keys())
dset1 = f['config']
dset2 = f['dde_results']

# There are six members in the Group f['dde_results']
print(dset2.keys())

check_node_lut = dset2['check_node_vector']
print(check_node_lut)
print("\n\n")

# Get pointer of target LUT
def ptr(i, m):
    offset = i * M * cardinality * cardinality + m * cardinality * cardinality
    return offset

# Get result of designated LUT
def lut_out(y0, y1, offset):
    t = check_node_lut[offset + y0 * cardinality + y1]
    return t

fragmentation = float((cardinality*cardinality*q*M)%BRAM_READ_WIDTH)
def verify_bram_to_coe(coe_filename, tb_filename):
    coe = open(coe_filename, "r")
    tb  = open(tb_filename, "r")
    error = 0
    for i in range(BRAM_DEPTH):
        correct = coe.readline()
        act  = tb.readline()
        if correct != act:
            print("The line ", str(i)+" is wrong")
            print("The correct result is ", correct, ", but the acutal result is ", act)
            error = error + 1
    return error

def verify_f3_output(correct_filename, f3_tb_filename):
    error = 0
    ans = open(correct_filename, "r")
    tb  = open(f3_tb_filename, "r")
    for i in range(depth_ib_func):
        correct = ans.readline()
        actual = tb.readline()
        if correct != actual:
            print("The correct result is ", correct, ", but the acutal result is ", actual)
            error = error + 1
    return error

#error = verify_bram_to_coe("COE_LUT/Iter_0/"+file_lut_coe+"Iter0_Func0_3.coe", file_bram_tb_portA)
#if error == 0:
#    print("Passed Verification\n")
#else:
#    print("Failed Verification\n")
ans_dir=[
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/python_prj/DUT_LUTM/IB_CNU_f0_3_PATTERN/ram_write_data/Iter_0/data.iter0.func0.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/python_prj/DUT_LUTM/IB_CNU_f0_3_PATTERN/ram_write_data/Iter_0/data.iter0.func1.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/python_prj/DUT_LUTM/IB_CNU_f0_3_PATTERN/ram_write_data/Iter_0/data.iter0.func2.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/python_prj/DUT_LUTM/IB_CNU_f0_3_PATTERN/ram_write_data/Iter_0/data.iter0.func3.csv",
]
act_dir=[
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.sim/sim_1/behav/xsim/f0.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.sim/sim_1/behav/xsim/f1.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.sim/sim_1/behav/xsim/f2.csv",
    "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.sim/sim_1/behav/xsim/f3.csv"
]
for m in range(M):
    print("------------------------------------")
    print("Verifying f"+str(m))
    error = verify_f3_output(ans_dir[m], act_dir[m])
    if error == 0:
        print("Verification of "+str(m)+" is passed")
    else:
        print("There are "+str(error)+" errors")

coe_act_dir="/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.sim/sim_1/behav/xsim/cnu_ram_dataIn.csv"
coe_ans_dir="/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/python_prj/DUT_BRAM32_0_3/IB_CNU_RAM_PATTERN/ram_write_data/Iter_0/data.iter0.func0_3.csv"
error = verify_bram_to_coe(coe_ans_dir, coe_act_dir)
if error == 0:
    print("Verification of RAMs Update is passed")
