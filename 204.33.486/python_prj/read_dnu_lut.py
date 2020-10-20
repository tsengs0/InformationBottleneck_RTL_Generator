import h5py
import csv
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import gng_out_eval as gng
import sys

q = 4  # 4-bit quantisation
mag_bitwidth = q - 1
VN_DEGREE = 3+1
M = VN_DEGREE - 2
cardinality = pow(2, q)
Iter_max = 50
test_set_num = 2**(q*5)
test_set_unit = VN_DEGREE - 1 + 1
test_sample_num = test_set_unit * test_set_num
snr_eval = 2
mean_eval = 1.0
cas_awgn_filename = 'cascade_cnu_lut_awgn_pattern.txt'
ch_msg_filename = 'cascade_cnu_lut_ch_msg_pattern.txt'
symmetric_ratio = [
    1,  # the symmetric ratio of input y0 (horizontal extent)
    0.5 # the symmetric ratio of input y1 (vertical extent)
]

map_table = [0] * cardinality
for i in range(cardinality):
    if i < (cardinality / 2):
        map_table[i] = int((-cardinality / 2) + (i % (cardinality / 2)))
    else:
        map_table[i] = int((i % (cardinality / 2)) + 1)
modulation_phase = 2 # BPSK

# Parameters for IB-CNU RAMs accesses
depth_ib_func = cardinality * cardinality
depth_ram = 32
interleave_bank_num = depth_ib_func / depth_ram

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
'''-------------------------------------------------------------------------------------------------'''
## The configuration of cascading datapath structure
dnu_f2_dut_filename = 'dnu_f2_baseline_dut' + '.csv'
cascade_lut_num = [2, 3, 1] # the number of decomposed LUTs over each m, where m in {0, 1 ,2, 3}
# the pair of input sources (variable-to-check msg) for each F0 decomposed LUT
# the pair of input sources (variable-to-check msg) for each F1 to F3 decomposed LUT
# Note that any value + 128 accounts for the input source from the outputs of its precedent decomposed LUTs,
# e.g., "0+128" of F1 indicates one input of F1 LUT is fed by the ouput of 0th decomposed LUT
inSrc_offset = 128
llr_id = 256
cascade_lut_f0_inSrc = [[llr_id, 0], [llr_id, 2]]
cascade_lut_f1_inSrc = [[0+inSrc_offset, 1], [0+inSrc_offset, 2], [1+inSrc_offset, 1]]
cascade_lut_f2_inSrc = [[0+inSrc_offset, 2]] # the f2 accounts for the decision node as the last stage of cascading structure
'''-------------------------------------------------------------------------------------------------'''

# There are six members in the Group f['dde_results']
print(dset2.keys())

var_node_lut = dset2['var_node_vector']
print(var_node_lut)
print("\n\n")


# Get pointer of target LUT
def ptr(i, m):
    offset = i * M * cardinality * cardinality + m * cardinality * cardinality
    return offset


# Get result of designated LUT
def lut_out(y0, y1, offset):
    t = var_node_lut[offset + y0 * cardinality + y1]
    return t

# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportVNU_LUT_COE():
    coe_folder_filename = 'COE_BRAM32.VNU'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + coe_folder_filename + '/', shell=True)

        # Generate COE file for each iteration, where one COE file conatains all 1024 entries of f^{Iter}_m. m in {0, 1, 2, 3}
        # Format: Since RAMB36E1 is chosen with 32-bit of read data width, 8 entries per RAM row, i.e., 9-entry x 4-bit = 36-bit.
        # Radix: hexadecimal.
        # Depth of BRAM (RAMB36E1): ceil(4096-bit/32) = 128
        # Write down output value of each corresponding entry
        cnt = 1
        for m in range(M):
            create_coe_filename = file_lut_coe + 'Iter' + str(i) + '_Func'+str(m)+'.coe'
            coe_file = open(create_coe_filename, "w")
            coe_file.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
            t_c = ''
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        coe_file.write(str(hex(int(t))[2:]) + ";")
                    else:
                        if (cnt % interleave_bank_num) == 0:
                            coe_file.write(str(hex(int(t))[2:]) + ", \n")
                        else:
                            coe_file.write(str(hex(int(t))[2:]))
                    cnt = cnt + 1
            subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/Iter_' + str(i) + '/', shell=True)
            coe_file.close()

# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportVNU_LUT_COE_0_2():
    coe_folder_filename = 'COE_BRAM32_0_2.VNU'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + coe_folder_filename + '/', shell=True)

        # Generate COE file for each iteration, where one COE file conatains all 1024 entries of f^{Iter}_m. m in {0, 1, 2, 3}
        # Format: Since RAMB36E1 is chosen with 32-bit of read data width, 8 entries per RAM row, i.e., 9-entry x 4-bit = 36-bit.
        # Radix: hexadecimal.
        # Depth of BRAM (RAMB36E1): ceil(4096-bit/32) = 128
        # Write down output value of each corresponding entry
        create_coe_filename = file_lut_coe + 'Iter' + str(i) + '_Func0_2.coe'
        coe_file = open(create_coe_filename, "w")
        coe_file.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        entry_cnt=1
        for m in range(M):
            t_c = ''
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        if m == M-1:
                            coe_file.write(str(hex(int(t))[2:]) + ";")
                        else:
                            coe_file.write(str(hex(int(t))[2:]) + ",\n")
                    else:
                        if (entry_cnt % interleave_bank_num) == 0:
                            coe_file.write(str(hex(int(t))[2:]) + ",\n")
                        else:
                            coe_file.write(str(hex(int(t))[2:]))
                    entry_cnt = entry_cnt + 1
        subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/Iter_' + str(i) + '/', shell=True)
        coe_file.close()

# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportVNU_LUT_COE_Iter0_25():
    coe_folder_filename = 'COE_BRAM32.VNU'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(2):
        filename = 'Iter_' + str(25 * i) + '_' + str((25 * i) + 25 - 1)
        create_Iter_filename = cmd_mkdir + filename
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + filename + ' ' + coe_folder_filename + '/', shell=True)

        # Generate COE file for each iteration, where one COE file conatains all 1024 entries of f^{Iter}_m. m in {0, 1, 2, 3}
        # Format: Since RAMB36E1 is chosen with 32-bit of read data width, 8 entries per RAM row, i.e., 9-entry x 4-bit = 36-bit.
        # Radix: hexadecimal.
        # Depth of BRAM (RAMB36E1): ceil(4096-bit/32) = 128
        # Write down output value of each corresponding entry
        for m in range(M-1): # The last (M-1)th will be handled by other function which is for decision node
            cnt = 1
            line = 1
            create_coe_filename = file_lut_coe + 'Iter' + str(25*i) + '_' + str((25*i)+25 - 1) + '_Func'+str(m)+'.coe'
            coe_file = open(create_coe_filename, "w")
            coe_file.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")

            for iter in range(25*i, (25*i)+25):
                offset = ptr(iter, m)
                for y0 in range(cardinality):
                    for y1 in range(cardinality):
                        t = lut_out(y0, y1, offset)
                        if y0 == cardinality - 1 and y1 == cardinality - 1 and line == (depth_ib_func/interleave_bank_num)*25:
                            coe_file.write(str(hex(int(t))[2:]) + ";")
                        else:
                            if (cnt % interleave_bank_num) == 0:
                                coe_file.write(str(hex(int(t))[2:]) + ", \n")
                                line = line + 1
                            else:
                                coe_file.write(str(hex(int(t))[2:]))
                        cnt = cnt + 1
            subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/' + filename + '/', shell=True)
            coe_file.close()

def symmetry_eval(y0, y1, t_c):
    fig,ax=plt.subplots(1,1)
    l = [0.0]*modulation_phase
    l[0] = -0.5
    for i in range(modulation_phase):
        l[i] = l[i-1] + 1
    #cp = ax.contourf(y0, y1, t_c, levels=l)
    cp = ax.imshow(t_c, cmap=cm.jet, interpolation='nearest')
    cb = fig.colorbar(cp)
    cb.set_ticks(l)
    cb.set_ticklabels([-1, 1])
    ax.set_title('Symmetry of 2-input LUT for Decision Node')
    ax.set_xlabel('y0 (4-bit)')
    ax.set_ylabel('y1 (4-bit)')
    plt.xticks(y0, map_table)
    plt.yticks(y1, map_table)
    plt.show()

def modulate(t_c):
    return int(map_table[int(t_c)])

def XNOR(InA, InB):
    if InA == 0 and InB == 0:
        return True
    elif InA == 0 and InB == 1:
        return False
    elif InA == 1 and InB == 0:
        return False
    elif InA == 1 and InB == 1:
        return True
    else:
        print("The format of given Input signal(s) might be wrong for XNOR")
        return False


def XOR(InA, InB):
    if InA == 0 and InB == 0:
        return False
    elif InA == 0 and InB == 1:
        return True
    elif InA == 1 and InB == 0:
        return True
    elif InA == 1 and InB == 1:
        return False
    else:
        print("The format of given Input signal(s) might be wrong for XOR")
        return False


def OR(InA, InB):
    if InA == 0 and InB == 0:
        return False
    elif InA == 0 and InB == 1:
        return True
    elif InA == 1 and InB == 0:
        return True
    elif InA == 1 and InB == 1:
        return True
    else:
        print("The format of given Input signal(s) might be wrong for OR")
        return False

def lut_symmetric_vis():
    y0_vec = [int(0)] * cardinality
    y1_vec = [int(0)] * cardinality
    t_c_vec = [[int(0) for i in range(cardinality)] for j in range(cardinality)]
    max_magnitude = (cardinality / 2) - 1
    m = VN_DEGREE - 2
    offset = ptr(0, m)
    for y0 in range(cardinality):
        for y1 in range(cardinality):
            t_c = lut_out(y0, y1, offset)
            y0_vec[y0] = y0
            y1_vec[y1] = y1
            t_c = int(t_c / (2**mag_bitwidth))
            if t_c  == 1:
                t_c = int(1)
            else:
                t_c = int(-1)
            t_c_vec[y0][y1] = t_c
    symmetry_eval(y0_vec, y1_vec, t_c_vec)

def inv_mag(InA):
    return (2 ** mag_bitwidth) - 1 - InA

def inv_mux_out(InA):  # only used by final cascaded LUT
    # Convert the y0 and y1 LUTs read addresses
    msb = (InA >> mag_bitwidth) % 2
    addr = InA % (2 ** mag_bitwidth)
    if msb == 0:
        addr = (2 ** mag_bitwidth) - 1 - addr  # 1's complement
    elif msb == 1:
        addr = addr
    else:
        print("Wrong input source of inv_mux_out")
        return -1, -1

    return int(addr), int(msb)

def sign_mag_extract(bitwidth, InA):
    sign = np.uint8(InA / (2**(bitwidth-1))) % 2
    mag = np.uint8(InA % (2**(bitwidth-1)))
    return sign, mag

def inv_mux(in_index, InA):
    if in_index == 0:
        shift_cnt = mag_bitwidth
    elif in_index == 1:
        shift_cnt = mag_bitwidth + 1
    else:
        print("The in_index should be either 0 or 1, but %d is passed" % (in_index))
        sys.exit()

    # Convert the y0 and y1 LUTs read addresses
    msb = int(InA / (2**shift_cnt)) % 2
    addr = InA % (2 ** shift_cnt)
    if msb == 1:
        addr = (2 ** shift_cnt) - 1 - addr  # 1's complement
    else:
        addr = addr

    return int(addr), int(msb)


def inv_mux_in2(y0, y1):
    # Convert the y0 and y1 LUTs read addresses
    y0_addr, msb_y0 = inv_mux(0, y0)
    y1_addr, msb_y1 = inv_mux(1, (2**mag_bitwidth)*2*msb_y0 + y1)
    return int(y0_addr), int(y1_addr), msb_y0, msb_y1

def burst_xor(bitwidth, vec_in, operand_com):
    result = [0]*bitwidth
    result_concate = 0
    for i in range(bitwidth):
        temp = int(vec_in / (2**i))
        temp = temp % 2
        logic = XOR(temp, operand_com)
        if logic == True:
            result[i] = 1
        elif logic == False:
            result[i] = 0
        else:
            print("The returned boolean result must be either True or False, but the actual result is %d" % (logic))
            sys.exit()
        result_concate = result_concate + (result[i]*(2**i))

    return result_concate

def lut_symmetric_eval(iter, m_range, y0_range, y1_range):
    max_magnitude = (cardinality / 2) - 1
    t_c_vec = [[0 for i in y1_range] for j in y0_range]
    for m in range(m_range, m_range + 1):
        offset = ptr(iter, m)
        for y0 in y0_range:
            for y1 in y1_range:
                # Convert the y0 and y1 LUTs read addresses
                y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(y0, y1)

                # Read magnitude from LUT
                t_c = lut_out(y0_addr, y1_addr, offset)

                mag, s = inv_mux(1, (2**mag_bitwidth)*2*msb_y0 + t_c)
                t_c_vec[y0][y1] = int(mag)
    return t_c_vec

def lut_symmetric_baseline(iter, m_range, y0_range, y1_range):
    max_magnitude = (cardinality / 2) - 1
    t_c_vec = [[0 for i in y0_range] for j in y1_range]
    for m in range(m_range, m_range + 1):
        offset = ptr(iter, m)
        for y0 in y0_range:
            for y1 in y1_range:
                t_c = lut_out(y0, y1, offset)
                t_c_vec[y0][y1] = int(t_c)
    return t_c_vec


def single_lut_symmetry_eval(iter):
    y0_range = [i for i in range(cardinality)]
    y1_range = [i for i in range(cardinality)]
    print(y0_range, y1_range)
    max_magnitude = (cardinality / 2) - 1

    for m in range(M+1):
        t0 = lut_symmetric_baseline(iter, m, y0_range, y1_range)
        t1 = lut_symmetric_eval(iter, m, y0_range, y1_range)

        err = 0
        for i in range(cardinality):
            for j in range(cardinality):
                if t0[i][j] == t1[i][j]:
                    #print("t0: %d\tt1: %d" % (t0[i][j], t1[i][j]))
                    err = err + 0
                else:
                    print("Wrong")
                    print("(y0:%d, y1:%d) => t0: %d\tt1: %d" % (i, j, t0[i][j], t1[i][j]))
                    err = err + 1
        print("m: %d\tError: %d" % (m, err))

## ======================== Cascading LUT Structure ========================= ##
def lut_symmetric_cascade_in(iter, m, y0, y1):
    offset = ptr(iter, m)

    # Convert the y0 and y1 LUTs read addresses
    y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(y0, y1)

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    #MSB, t_c = sign_mag_extract(q, t_c)
    #return t_c, MSB
    return t_c, msb_y0

def lut_symmetric_cascade_internal(iter, m, forward_sign, y0, y1):
    offset = ptr(iter, m)

    # Convert the y0 and y1 LUTs read addresses
    operand_com = int(y0 / (2**mag_bitwidth)) % 2
    vec_in = (y0 % (2**mag_bitwidth)) + (forward_sign*(2**mag_bitwidth))
    formed_y0 = burst_xor(q, vec_in, operand_com)
    msb_y0, y0_addr = sign_mag_extract(q, formed_y0)
    y1_addr, msb_y1 = inv_mux(1, (2**mag_bitwidth)*2*msb_y0 + y1)
    #y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(formed_y0, y1)

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)

    return t_c, msb_y0

def lut_symmetric_cascade_out(iter, m, forward_sign, y0, y1):
    offset = ptr(iter, m)

    # Convert the y0 and y1 LUTs read addresses
    operand_com = int(y0 >> mag_bitwidth)
    vec_in = (y0 % (2**mag_bitwidth)) + (forward_sign << mag_bitwidth)
    formed_y0 = burst_xor(q, vec_in, operand_com)
    msb_y0, y0_addr = sign_mag_extract(q, formed_y0)
    y1_addr, msb_y1 = inv_mux(1, (2**mag_bitwidth)*2*msb_y0 + y1)
    #y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(formed_y0, y1)

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    dnu_in = t_c

    mag, s = inv_mux(1, (2 ** mag_bitwidth) * 2 * msb_y0 + t_c)
    t_c = int(mag)

    return t_c, msb_y0, dnu_in # the returned value "msb_y0" is for the decision node at next step

def lut_symmetric_cascade_hardDecision(iter, m, forward_sign, y0, y1):
    offset = ptr(iter, m)

    # Convert the y0 and y1 LUTs read addresses
    operand_com = int(y0 / (2**mag_bitwidth)) % 2
    vec_in = (y0 % (2**mag_bitwidth)) + (forward_sign*(2**mag_bitwidth))
    formed_y0 = burst_xor(q, vec_in, operand_com)
    msb_y0, y0_addr = sign_mag_extract(q, formed_y0)
    y1_addr, msb_y1 = inv_mux(1, (2**mag_bitwidth)*2*msb_y0 + y1)
    #y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(formed_y0, y1)

    # Read magnitude from LUT
    t_c = int(lut_out(y0_addr, y1_addr, offset))
    t_c = int(t_c >> mag_bitwidth)
    t_c = XOR(t_c, msb_y0)
    if t_c == True:
        return int(1)
    else: # t_c == False
        return int(0)

def symmetric_cascade_lut(iter, c2v_vec):
    t_c = [0] * (M + 1) # the M^th data outcome is hard decision
    sign_forward = [0] * M
    for m in range(M + 1): # the last iteration is decision node process
        if m == 0 and M != 1:
            t_c[0], sign_forward[0] = lut_symmetric_cascade_in(iter, 0, c2v_vec[0], c2v_vec[1])
        elif m < (M - 1) and m > 0:
            t_c[m], sign_forward[m] = lut_symmetric_cascade_internal(iter, m, sign_forward[m-1], t_c[m - 1], c2v_vec[m + 1])
        elif m == (M - 1):
            t_c[m], sign_forward[m], dnu_in = lut_symmetric_cascade_out(iter, m, sign_forward[m-1], t_c[m - 1], c2v_vec[m + 1])
        elif m == M: # decision node unit for obtaining the corresponding variable node's Hard Decision
            t_c[m] = lut_symmetric_cascade_hardDecision(iter, m, sign_forward[m-1], dnu_in, c2v_vec[m + 1])
        else:
            print("Wrong configuration on Symmetric Cascading LUT due to a mismatch of M")
            return -1

    return int(t_c[M]) # return the hard decision


def lut_baseline(iter, m, y0, y1):
    offset = ptr(iter, m)
    t_c = lut_out(y0, y1, offset)
    return t_c


def cascade_lut_baseline(iter, c2v_vec):
    for m in range(M + 1): # the last iteratin if for decision node process
        if m == 0:
            t_c = lut_baseline(iter, 0, c2v_vec[0], c2v_vec[1])
        elif m == M:
            t_c = lut_baseline(iter, 0, c2v_vec[0], c2v_vec[1])
            t_c = int(t_c / (2**mag_bitwidth))
        else:
            t_c = lut_baseline(iter, m, t_c, c2v_vec[m + 1])

    return int(t_c)


def cascade_lut_pattern_gen():
    awgn_test_pattern = gng.sw_gauss_sample_gen(export_filename=cas_awgn_filename, mean=mean_eval,
                                                std_dev=gng.std_dev_cal(snr_eval), num=test_sample_num)
    ch_msg_test_pattern = gng.ib_mapping(awgn_test_pattern, ch_msg_filename)
    return ch_msg_test_pattern

## Generate output patterns of f0 LUTs
def dnu3_f2_dut_sample_gen(c2v_vec, ch_msg_in, hard_val):
    dnu_f2_dut_file.write(
        str(hex(int(ch_msg_in))[2]) + ","  +
        str(hex(int(c2v_vec[0]))[2]) + "," +
        str(hex(int(c2v_vec[1]))[2]) + "," +
        str(hex(int(c2v_vec[2]))[2]) + "," +
        str(hex(int(hard_val))[2]) + "\n"
    )

## Datapath of one check node unit in d_c=6
def cascaded_dnu3_sym_sw(iter, c2v_vec, ch_msg_in):
    # Declare the number of decomposed LUTs output sources
    f0_tc = np.empty(cascade_lut_num[0], dtype=np.int8)
    f1_tc = np.empty(cascade_lut_num[1], dtype=np.int8)
    dnu_in = np.empty(cascade_lut_num[1], dtype=np.int8)
    f0_sign_forward = np.empty(cascade_lut_num[0], dtype=np.int8)
    f1_sign_forward = np.empty(cascade_lut_num[1], dtype=np.int8)

    for m in range(M+1):
        if m == 0:
            for f0_m in range(cascade_lut_num[m]):
                in_id_1 = cascade_lut_f0_inSrc[f0_m][1]
                f0_tc[f0_m], f0_sign_forward[f0_m] = lut_symmetric_cascade_in(iter, 0, ch_msg_in, c2v_vec[in_id_1])

        elif m == 1:
            for f1_m in range(cascade_lut_num[m]):
                # To assign the input source 0
                if(cascade_lut_f1_inSrc[f1_m][0] >= inSrc_offset):
                    in_id_0 = cascade_lut_f1_inSrc[f1_m][0] - inSrc_offset
                    inSrc_0 = f0_tc[in_id_0]# % (2**(q-1))
                    inSign_0 = f0_sign_forward[in_id_0]
                else:
                    in_id_0 = cascade_lut_f1_inSrc[f1_m][0]
                    inSrc_0 = c2v_vec[in_id_0]

                # TO assign the input source 1
                if(cascade_lut_f1_inSrc[f1_m][1] >= inSrc_offset):
                    in_id_1 = cascade_lut_f1_inSrc[f1_m][1] - inSrc_offset
                    inSrc_1 = f0_tc[in_id_1]
                else:
                    in_id_1 = cascade_lut_f1_inSrc[f1_m][1]
                    inSrc_1 = c2v_vec[in_id_1]

                f1_tc[f1_m], f1_sign_forward[f1_m], dnu_in[f1_m] = lut_symmetric_cascade_out(iter, m, inSign_0, inSrc_0, inSrc_1)

        elif m == 2:
            # First input source of DNU
            in_id_0 = cascade_lut_f2_inSrc[0][0] - inSrc_offset
            inSrc_0 = dnu_in[in_id_0]
            inSign_0 = f1_sign_forward[in_id_0]

            # Second input source of DNU
            in_id_1 = cascade_lut_f2_inSrc[0][1]
            inSrc_1 = c2v_vec[in_id_1]

            hard_val = lut_symmetric_cascade_hardDecision(iter, 2, inSign_0, inSrc_0, inSrc_1)
            dnu3_f2_dut_sample_gen(c2v_vec, ch_msg_in, hard_val)

        else:
            print("Wrong parameter is passed, the M is only until %d but the actual passed M is %d" % (M-2, m))
            sys.exit()

def main():
    # exportVNU_LUT_COE()
    # exportVNU_LUT_CSV()
    # gen_VNU_LUT_V()
    # dut_pattern_gen()
    # showVNU_LUT(1)

    #lut_symmetric_vis() # visualise the symmetry of LUT for ease of observation

    '''
    single_lut_symmetry_eval(iter=0) # evaluate 2-input LUT solely

    t0 = [0] * test_set_num
    t1 = [0] * test_set_num
    ch_msg_vec = [0] * test_sample_num
    ch_msg_vec = cascade_lut_pattern_gen()

    for iter in range(1):#range(Iter_max):
        for i in range(test_set_num):
            #for i in range(4):
            t0[i] = cascade_lut_baseline(iter, ch_msg_vec[test_set_unit * i:test_set_unit * i + test_set_unit])
            # print("Channel Message: ", ch_msg_vec, "\nCascadded LUTs (baseline): ", t0[i])

            t1[i] = symmetric_cascade_lut(iter, ch_msg_vec[test_set_unit * i:test_set_unit * i + test_set_unit])
            # print("\nChannel Message: ", ch_msg_vec, "\nCascadded LUTs (symmetry): ", t1[i])

    err = 0
    for i in range(test_set_num):
        if int(t0[i]) != int(t1[i]):
            err = err + 1
            for j in range(test_set_unit * i, test_set_unit * i + test_set_unit):
                print(format(ch_msg_vec[j], '04b'))
            print("TestSet_%d: expect->%d, actual->%d\n" % (i, t0[i], t1[i]))

    if err == 0:
        print("Verification is passed")
    else:
        print("Err: %d" % (err))
    '''
    c2v_sample = np.zeros(VN_DEGREE-1, dtype=np.int8)
    v2c_sample = np.zeros(VN_DEGREE-1, dtype=np.int8)
    for iter in range(1): # only do the DUT of 0th iteration
        for c2v_aggregate in range(2**16 - 1):
            for i in range(VN_DEGREE):
                right_shift = c2v_aggregate >> (i*q)
                if i == 0:
                    ch_msg_in = right_shift % (2**q)
                else:
                    c2v_sample[i-1] = right_shift % (2**q)

            cascaded_dnu3_sym_sw(iter, c2v_sample, ch_msg_in)

if __name__ == "__main__":
    dnu_f2_dut_file = open(dnu_f2_dut_filename, "w")
    main()
    dnu_f2_dut_file.close()

    error = 0
    vec = [0, 0, 0, 0]
    for c2v_aggregate in range(2**16 - 1):
        for i in range(VN_DEGREE):
            right_shift = c2v_aggregate >> (i*q)
            if i == 0:
                vec[0] = right_shift % (2**q)
            else:
                vec[i] = right_shift % (2**q)

        t_c = lut_baseline(0, 0, vec[0], vec[1])
        t_c1 = lut_baseline(0, 1, t_c, vec[2])
        t_c2 = int(lut_baseline(0, 2, t_c1, vec[3]))

        t, s = lut_symmetric_cascade_in(0, 0, int(vec[0]), int(vec[1]))
        t1, s1, dnu_in = lut_symmetric_cascade_out(0, 1, int(s), int(t), int(vec[2]))
        hard_val = lut_symmetric_cascade_hardDecision(0, 2, int(s1), dnu_in, int(vec[3]))

        if hard_val != t_c2 >> mag_bitwidth:
            error = error + 1
        print(t_c2, '(', t_c2 >> mag_bitwidth, ') -->', hard_val, 'Error: ', error)
