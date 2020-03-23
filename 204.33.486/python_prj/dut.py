import subprocess
import math

q=4 # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE-2
cardinality = pow(2, q)
Iter_max = 50
BRAM_READ_WIDTH = 36 # 36-bit
BRAM_DEPTH = math.ceil((cardinality*cardinality*q*M)/BRAM_READ_WIDTH)

file_204_102='ib_regular_444_1.300_50_ib_123_10_5_first_none_ib_ib.h5'
file_lut_csv='lut_' # lut_Iter50_Func3.csv
file_lut_coe='lut_' # lut_Iter50_Func3.csv
file_lut_rtl='lut_cnu_'
file_bram_tb_portA = "bram_readoutPortA.txt"
file_bram_tb_portB = "bram_readoutPortB.txt"
cmd_mkdir='mkdir '
cmd_move='mv '

fragmentation = float((cardinality*cardinality*q*M)%BRAM_READ_WIDTH)
def verify_bram_to_coe(coe_filename, tb_filename):
    coe = open(coe_filename, "r")
    tb  = open(tb_filename, "r")
    coe.readline()
    coe.readline()
    for i in range(BRAM_DEPTH):
        correct = coe.readline()
        act  = tb.readline()
        if correct != act and i != BRAM_DEPTH-1:
            print("The correct result is ", correct, ", but the acutal result is ", act)
            return 1
        elif i == BRAM_DEPTH-1:
            if correct[:fragmentation] != act[:fragmentation]:
                return 1
    return 0


error = verify_bram_to_coe("COE_LUT/Iter_0/"+file_lut_coe+"Iter0_Func0_3.coe", file_bram_tb_portA)
if error == 0:
    print("Passed Verification\n")
else:
    print("Failed Verification\n")
