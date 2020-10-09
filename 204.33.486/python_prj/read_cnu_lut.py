import h5py
import csv
import subprocess
import numpy as np
import sys
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib.colors import ListedColormap
import gng_out_eval as gng

q = 4  # 4-bit quantisation
mag_bitwidth = q - 1
CN_DEGREE = 6
M = CN_DEGREE - 2
cardinality = pow(2, q)
Iter_max = 50
test_set_num = 10#2**(q*5)
test_set_unit = CN_DEGREE - 1
test_sample_num = test_set_unit * test_set_num
snr_eval = 2
mean_eval = 1.0

map_table = [0] * cardinality
for i in range(cardinality):
    if i < (cardinality / 2):
        map_table[i] = int((-cardinality / 2) + (i % (cardinality / 2)))
    else:
        map_table[i] = int((i % (cardinality / 2)) + 1)

# Parameters for IB-CNU RAMs accesses
depth_ib_func = cardinality * cardinality
depth_ram = 32
interleave_bank_num = depth_ib_func / depth_ram

file_204_102 = 'ib_regular_444_1.300_50_ib_123_10_5_first_none_ib_ib.h5'
cmd_mkdir = 'mkdir '
cmd_move = 'mv '
cmd_copy = 'cp -a '
f = h5py.File(file_204_102, 'r')
# Show all keys
list(f.keys())
dset1 = f['config']
dset2 = f['dde_results']
c2v_dut_filename = 'c2v_baseline_dut' + '.csv'
cnu_f0_dut_filename = 'cnu_f0_baseline_dut' + '.csv'
cnu_f1_dut_filename = 'cnu_f1_baseline_dut' + '.csv'
cnu_f2_dut_filename = 'cnu_f2_baseline_dut' + '.csv'
cnu_f3_dut_filename = 'cnu_f3_baseline_dut' + '.csv'
'''-------------------------------------------------------------------------------------------------'''
## The configuration of cascading datapath structure
cascade_lut_num = [2, 2, 4, 6] # the number of decomposed LUTs over each m, where m in {0, 1 ,2, 3}
# the pair of input sources (variable-to-check msg) for each F0 decomposed LUT
# the pair of input sources (variable-to-check msg) for each F1 to F3 decomposed LUT
# Note that any value + 128 accounts for the input source from the outputs of its precedent decomposed LUTs,
# e.g., "0+128" of F1 indicates one input of F1 LUT is fed by the ouput of 0th decomposed LUT
inSrc_offset = 128
cascade_lut_f0_inSrc = [[0, 1], [4, 3]]
cascade_lut_f1_inSrc = [[0+inSrc_offset, 2], [1+inSrc_offset, 5]]
cascade_lut_f2_inSrc = [[0+inSrc_offset, 3], [0+inSrc_offset, 4], [1+inSrc_offset, 0], [1+inSrc_offset, 1]]
cascade_lut_f3_inSrc = [[0+inSrc_offset, 4], [0+inSrc_offset, 5], [1+inSrc_offset, 5], [2+inSrc_offset, 1], [2+inSrc_offset, 2], [3+inSrc_offset, 2]]
'''-------------------------------------------------------------------------------------------------'''


# There are six members in the Group f['dde_results']
print(dset2.keys())

check_node_lut = dset2['check_node_vector']
var_node_lut = dset2['var_node_vector']
print(check_node_lut)
print("\n\n")
print(var_node_lut)

# Get pointer of target LUT
def ptr(i, m):
    offset = i * M * cardinality * cardinality + m * cardinality * cardinality
    return offset


# Get result of designated LUT
def lut_out(y0, y1, offset):
    t = check_node_lut[offset + y0 * cardinality + y1]
    return t


# Export every LUT to individual CSV file
def exportCNU_LUT_CSV():
    csv_folder_filename = 'CSV_LUT'
    subprocess.call(cmd_mkdir + csv_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + csv_folder_filename + '/', shell=True)
        for m in range(M):
            create_csv_filename = file_lut_csv + 'Iter' + str(i) + '_Func' + str(m) + '.csv'
            csv_file = open(create_csv_filename, mode='w')
            csv_writer = csv.writer(csv_file, delimiter=',')
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    csv_writer.writerow([int(y0), int(y1), int(t)])
            subprocess.call(cmd_move + create_csv_filename + ' ' + csv_folder_filename + '/Iter_' + str(i) + '/',
                            shell=True)


# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportCNU_LUT_COE():
    coe_folder_filename = 'COE_LUT'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + coe_folder_filename + '/', shell=True)

        # Generate COE file for each iteration, where one COE file conatains all 1024 entries of f^{Iter}_m. m in {0, 1, 2, 3}
        # Format: Since RAMB36E1 is chosen with 36-bit of read data width, 9 entries per RAM row, i.e., 9-entry x 4-bit = 36-bit.
        # Radix: hexadecimal.
        # Depth of BRAM (RAMB36E1): ceil(4096-bit/36) = 114
        create_coe_filename = file_lut_coe + 'Iter' + str(i) + '_Func0_3.coe'
        coe_file = open(create_coe_filename, "w")
        coe_file.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        # Write down output value of each corresponding entry
        cnt = 1
        for m in range(M):
            t_c = ''
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        if m == M - 1 and y1 == cardinality - 1 and y0 == cardinality - 1:
                            coe_file.write(str(hex(int(t))[2:]) + ";")
                    else:
                        if (cnt % 9) == 0:
                            coe_file.write(str(hex(int(t))[2:]) + ", \n")
                        else:
                            coe_file.write(str(hex(int(t))[2:]))
                    cnt = cnt + 1
        subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/Iter_' + str(i) + '/',
                        shell=True)
        coe_file.close()

# Demonstrate output of all LUTs with given entry address
def showCNU_LUT(iter_id):
    for i in range(iter_id):
        print("\nIn iteration ", i)
        for m in range(4):
            offset = ptr(i, m)
            print("\nf(y0, y1)_", m, ":")
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    print("(y0=", y0, " y1=", y1, ") = ", t)


# Generate the Verilog code of switch case instantiation
def gen_verilog_cnu_lut_entry(fp, y0, y1, t):
    fp.write("{`QUAN_SIZE'd" + str(int(y0)) + ", " + "`QUAN_SIZE'd" + str(
        int(y1)) + "}: " + "t_c[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd" + str(int(t)) + "\n")


# Export every LUT to individual Verilog file
def gen_CNU_LUT_V():
    verilog_folder_filename = 'Verilog_LUT'
    subprocess.call(cmd_mkdir + verilog_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + verilog_folder_filename + '/', shell=True)
        for m in range(M):
            create_verilog_filename = file_lut_rtl + 'Iter' + str(i) + '_Func' + str(m) + '.v'
            rtl_file = open(create_verilog_filename, "w")
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    gen_verilog_cnu_lut_entry(rtl_file, str(int(y0)), str(' ' + int(y1)), str(' ' + int(t)))
            subprocess.call(
                cmd_move + create_verilog_filename + ' ' + verilog_folder_filename + '/Iter_' + str(i) + '/',
                shell=True)
            rtl_file.close()

def symmetry_eval(y0, y1, t_c):
    fig,ax=plt.subplots(1,1)
    l = [0.0]*cardinality
    l[0] = -7.5
    for i in range(1, cardinality, 1):
        l[i] = l[i-1] + 1
    #cp = ax.contourf(y0, y1, t_c, levels=l)
    cp = ax.imshow(t_c, cmap=cm.jet, interpolation='nearest')
    cb = fig.colorbar(cp)
    cb.set_ticks(l)
    cb.set_ticklabels(map_table)
    ax.set_title('Symmetry of 2-input LUT for Check Node')
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
    y0_vec = [0] * cardinality
    y1_vec = [0] * cardinality
    t_c_vec = [[0 for i in range(cardinality)] for j in range(cardinality)]
    max_magnitude = (cardinality / 2) - 1
    for m in range(1):
        offset = ptr(0, m)
        for y0 in range(cardinality):
            for y1 in range(cardinality):
                t_c = lut_out(y0, y1, offset)
                y0_vec[y0] = y0
                y1_vec[y1] = y1
                t_c = modulate(t_c)

                # if t_c > max_magnitude:
                #     t_c = max_magnitude - (t_c - max_magnitude - 1)
                t_c_vec[y0][y1] = t_c
    # symmetry_eval(y0_vec, y1_vec, t_c_vec)

def inv_mag(InA):
    return (2**mag_bitwidth) - 1 - InA

def inv_mux_out(InA): # only used by final cascaded LUT
    # Convert the y0 and y1 LUTs read addresses
    msb = (InA >> mag_bitwidth) % 2
    addr = InA % (2**mag_bitwidth)
    if msb == 0:
        addr = (2**mag_bitwidth) - 1 - addr  # 1's complement
    elif msb == 1:
        addr = addr
    else:
        print("Wrong input source of inv_mux_out")
        return -1, -1

    return int(addr), int(msb)

def inv_mux(InA):
    # Convert the y0 and y1 LUTs read addresses
    msb = (InA >> mag_bitwidth) % 2
    addr = InA % (2**mag_bitwidth)
    if msb == 1:
        addr = (2**mag_bitwidth) - 1 - addr  # 1's complement
    else:
        addr = addr

    return int(addr), int(msb)

def inv_mux_in2(y0, y1):
    # Convert the y0 and y1 LUTs read addresses
    y0_addr, msb_y0 = inv_mux(y0)
    y1_addr, msb_y1 = inv_mux(y1)
    return int(y0_addr), int(y1_addr), msb_y0, msb_y1

def lut_symmetric_eval(m_range, y0_range, y1_range):
    max_magnitude = (cardinality / 2) - 1
    t_c_vec = [[0 for i in y0_range] for j in y1_range]
    for m in range(m_range, m_range+1):
        offset = ptr(0, m)
        for y0 in y0_range:
            for y1 in y1_range:
                # Convert the y0 and y1 LUTs read addresses
                y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(y0, y1)

                # Determine the sign bit of the final result
                msb_temp = XNOR(msb_y0, msb_y1)
                if msb_temp == True:
                    MSB = 1
                else:
                    MSB = 0

                # Read magnitude from LUT
                t_c = lut_out(y0_addr, y1_addr, offset)
                t_c = int(t_c % (2**mag_bitwidth)) # remove MSB

                # Invert the read magnitude (from LUT)
                t_c = inv_mag(t_c)

                mag, s = inv_mux(t_c + (MSB << mag_bitwidth))
                t_c_vec[y0][y1] = int(mag + (s << mag_bitwidth))
    return t_c_vec

def lut_symmetric_baseline(m_range, y0_range, y1_range):
    max_magnitude = (cardinality / 2) - 1
    t_c_vec = [[0 for i in y0_range] for j in y1_range]
    for m in range(m_range, m_range+1):
        offset = ptr(0, m)
        for y0 in y0_range:
            for y1 in y1_range:
                t_c = lut_out(y0, y1, offset)
                t_c_vec[y0][y1] = int(t_c)
    return t_c_vec

def single_lut_symmetry_eval():
    y0_range = [i for i in range(cardinality)]
    y1_range = [i for i in range(cardinality)]
    print(y0_range, y1_range)

    for m in range(M):
        t0 = lut_symmetric_baseline(m, y0_range, y1_range)
        t1 = lut_symmetric_eval(m, y0_range, y1_range)

        err = 0
        for i in range(cardinality):
            for j in range(cardinality):
                if t0[i][j] == t1[i][j]:
                    #print("t0: %d\tt1: %d" % (t0[i][j], t1[i][j]))
                    err = err + 0
                else:
                    print("Wrong")
                    print("t0: %d\tt1: %d" % (t0[i][j], t1[i][j]))
                    err = err + 1
        print("m: %d\tError: %d" % (m, err))

def lut_symmetric_in(m, y0, y1): # for single LUT structure which is only feasible when cascading structure is not required, e.g., Decision Node Operation
    offset = ptr(0, m)
    # Convert the y0 and y1 LUTs read addresses
    y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(y0, y1)
    # Determine the sign bit of the final result
    msb_temp = XOR(msb_y0, msb_y1)
    if msb_temp == True:
        MSB = 1
    else:
        MSB = 0

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    t_c = int(t_c % (2**mag_bitwidth)) # remove MSB

    t_c = int(t_c + (MSB << mag_bitwidth))
    return t_c

## ======================== Cascading LUT Structure ========================= ##
def lut_symmetric_cascade_in(iter, m, y0, y1):
    offset = ptr(iter, m)
    # Convert the y0 and y1 LUTs read addresses
    y0_addr, y1_addr, msb_y0, msb_y1 = inv_mux_in2(y0, y1)
    # Determine the sign bit of the final result
    msb_temp = XNOR(msb_y0, msb_y1)
    if msb_temp == True:
        MSB = 1
    else:
        MSB = 0

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    t_c = int(t_c % (2**mag_bitwidth)) # remove MSB

    return t_c, MSB

def lut_symmetric_cascade_internal(iter, m, sign_forward, y0_mag, y1):
    offset = ptr(iter, m)
    # Convert the y0 and y1 LUTs read addresses
    y0_addr = inv_mag(y0_mag)
    msb_y0 = sign_forward
    y1_addr, msb_y1 = inv_mux(y1)
    # Determine the sign bit of the final result
    msb_temp = XNOR(msb_y0, msb_y1)
    if msb_temp == True:
        MSB = 1
    else:
        MSB = 0

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    t_c = int(t_c % (2**mag_bitwidth)) # remove MSB

    return t_c, MSB

def lut_symmetric_cascade_out(iter, m, sign_forward, y0_mag, y1):
    offset = ptr(iter, m)
    # Convert the y0 and y1 LUTs read addresses
    #if sign_forward == 1:
    #    y0_addr = inv_mag(y0_mag)
    #else:
    #    y0_addr = int(7)
    y0_addr = inv_mag(y0_mag)
    msb_y0 = sign_forward
    y1_addr, msb_y1 = inv_mux(y1)
    # Determine the sign bit of the final result
    msb_temp = XNOR(msb_y0, msb_y1)
    if msb_temp == True:
        MSB = 1
    else:
        MSB = 0

    # Read magnitude from LUT
    t_c = lut_out(y0_addr, y1_addr, offset)
    t_c = int(t_c % (2**mag_bitwidth)) # remove MSB

    # 2's complement formating
    mag, s = inv_mux_out(t_c + (MSB << mag_bitwidth))
    t_c = int(mag + (s << mag_bitwidth))
    return t_c

def symmetric_cascade_lut(iter, v2c_vec):
    t_c = [0] * M
    sign_forward = [0] * (M - 1)
    for m in range(M):
        if m == 0 and M != 1:
            t_c[0], sign_forward[0] = lut_symmetric_cascade_in(iter, 0, v2c_vec[0], v2c_vec[1])
        elif m < (M - 1) and m > 0:
            t_c[m], sign_forward[m] = lut_symmetric_cascade_internal(iter, m, sign_forward[m - 1], t_c[m - 1], v2c_vec[m + 1])
        elif m == (M - 1):
            t_c[m] = lut_symmetric_cascade_out(iter, m, sign_forward[m - 1], t_c[m - 1], v2c_vec[m + 1])
        else:
            print("Wrong configuration on Symmetric Cascading LUT due to a mismatch of M")
            return -1

    return int(t_c[M - 1])

def lut_baseline(iter, m, y0, y1):
    offset = ptr(iter, m)
    t_c = lut_out(y0, y1, offset)
    return int(t_c)

## Datapath of only one check-to-variable message
def cascade_lut_baseline(v2c_vec):
    for m in range(M):
        if m == 0:
            t_c = lut_baseline(0, 0, v2c_vec[0], v2c_vec[1])
        else:
            t_c = lut_baseline(0, m, t_c, v2c_vec[m + 1])

    return t_c

## Generate output patterns of f0 LUTs
def cnu6_f03_dut_sample_gen(v2c_vec, tc_vec, m):
    tc_num = len(tc_vec)
    if m == 0:
        cnu_f0_dut_file.write(
            str(hex(int(v2c_vec[0]))[2]) + "," +
            str(hex(int(v2c_vec[1]))[2]) + "," +
            str(hex(int(v2c_vec[2]))[2]) + "," +
            str(hex(int(v2c_vec[3]))[2]) + "," +
            str(hex(int(v2c_vec[4]))[2]) + "," +
            str(hex(int(v2c_vec[5]))[2]) + ","
        )

        for f_m in range(tc_num-1):
            cnu_f0_dut_file.write(str(hex(int(tc_vec[f_m]))[2]) + ",")
        cnu_f0_dut_file.write(str(hex(int(tc_vec[tc_num-1]))[2]) + "\n")

    elif m == 1:
        cnu_f1_dut_file.write(
            str(hex(int(v2c_vec[0]))[2]) + "," +
            str(hex(int(v2c_vec[1]))[2]) + "," +
            str(hex(int(v2c_vec[2]))[2]) + "," +
            str(hex(int(v2c_vec[3]))[2]) + "," +
            str(hex(int(v2c_vec[4]))[2]) + "," +
            str(hex(int(v2c_vec[5]))[2]) + ","
        )

        for f_m in range(tc_num-1):
            cnu_f1_dut_file.write(str(hex(int(tc_vec[f_m]))[2]) + ",")
        cnu_f1_dut_file.write(str(hex(int(tc_vec[tc_num-1]))[2]) + "\n")

    elif m == 2:
        cnu_f2_dut_file.write(
            str(hex(int(v2c_vec[0]))[2]) + "," +
            str(hex(int(v2c_vec[1]))[2]) + "," +
            str(hex(int(v2c_vec[2]))[2]) + "," +
            str(hex(int(v2c_vec[3]))[2]) + "," +
            str(hex(int(v2c_vec[4]))[2]) + "," +
            str(hex(int(v2c_vec[5]))[2]) + ","
        )

        for f_m in range(tc_num-1):
            cnu_f2_dut_file.write(str(hex(int(tc_vec[f_m]))[2]) + ",")
        cnu_f2_dut_file.write(str(hex(int(tc_vec[tc_num-1]))[2]) + "\n")

    elif m == 3:
        cnu_f3_dut_file.write(
            str(hex(int(v2c_vec[0]))[2]) + "," +
            str(hex(int(v2c_vec[1]))[2]) + "," +
            str(hex(int(v2c_vec[2]))[2]) + "," +
            str(hex(int(v2c_vec[3]))[2]) + "," +
            str(hex(int(v2c_vec[4]))[2]) + "," +
            str(hex(int(v2c_vec[5]))[2]) + ","
        )

        for f_m in range(tc_num-1):
            cnu_f3_dut_file.write(str(hex(int(tc_vec[f_m]))[2]) + ",")
        cnu_f3_dut_file.write(str(hex(int(tc_vec[tc_num-1]))[2]) + "\n")

    else:
        print("Wrong parameter is passed, the M is only until %d but the actual passed M is %d" % (M - 2, m))
        sys.exit()

## Datapath of one check node unit in d_c=6
def cascaded_cnu6_sym_sw(iter, v2c_vec):
    # Declare the number of decomposed LUTs output sources
    f0_tc = np.empty(cascade_lut_num[0], dtype=np.int8)
    f1_tc = np.empty(cascade_lut_num[1], dtype=np.int8)
    f2_tc = np.empty(cascade_lut_num[2], dtype=np.int8)
    f3_tc = np.empty(cascade_lut_num[3], dtype=np.int8)
    f0_sign_forward = np.empty(cascade_lut_num[0], dtype=np.int8)
    f1_sign_forward = np.empty(cascade_lut_num[1], dtype=np.int8)
    f2_sign_forward = np.empty(cascade_lut_num[2], dtype=np.int8)

    for m in range(M):
        if m == 0:
            for f0_m in range(cascade_lut_num[m]):
                in_id_0 = cascade_lut_f0_inSrc[f0_m][0]
                in_id_1 = cascade_lut_f0_inSrc[f0_m][1]
                f0_tc[f0_m], f0_sign_forward[f0_m] = lut_symmetric_cascade_in(iter, 0, v2c_vec[in_id_0], v2c_vec[in_id_1])
                f0_tc[f0_m] = f0_tc[f0_m] + (f0_sign_forward[f0_m] << (q-1)) # to concatenate the magnitude with sign bit
            cnu6_f03_dut_sample_gen(v2c_vec, f0_tc, m) # write the input-output log file for RTL DUTs

        elif m == 1:
            for f1_m in range(cascade_lut_num[m]):
                # To assign the input source 0
                if(cascade_lut_f1_inSrc[f1_m][0] >= inSrc_offset):
                    in_id_0 = cascade_lut_f1_inSrc[f1_m][0] - inSrc_offset
                    inSrc_0 = f0_tc[in_id_0] % (2**(q-1))
                    inSign_0 = f0_sign_forward[in_id_0]
                else:
                    in_id_0 = cascade_lut_f1_inSrc[f1_m][0]
                    inSrc_0 = v2c_vec[in_id_0]

                # TO assign the input source 1
                if(cascade_lut_f1_inSrc[f1_m][1] >= inSrc_offset):
                    in_id_1 = cascade_lut_f1_inSrc[f1_m][1] - inSrc_offset
                    inSrc_1 = f0_tc[in_id_1]
                else:
                    in_id_1 = cascade_lut_f1_inSrc[f1_m][1]
                    inSrc_1 = v2c_vec[in_id_1]

                f1_tc[f1_m], f1_sign_forward[f1_m] = lut_symmetric_cascade_internal(iter, m, inSign_0, inSrc_0, inSrc_1)
                f1_tc[f1_m] = f1_tc[f1_m] + (f1_sign_forward[f1_m] << (q-1)) # to concatenate the magnitude with sign bit
            cnu6_f03_dut_sample_gen(v2c_vec, f1_tc, m) # write the input-output log file for RTL DUTs

        elif m == 2:
            for f2_m in range(cascade_lut_num[m]):
                # To assign the input source 0
                if(cascade_lut_f2_inSrc[f2_m][0] >= inSrc_offset):
                    in_id_0 = cascade_lut_f2_inSrc[f2_m][0] - inSrc_offset
                    inSrc_0 = f1_tc[in_id_0] % (2**(q-1))
                    inSign_0 = f1_sign_forward[in_id_0]
                else:
                    in_id_0 = cascade_lut_f2_inSrc[f2_m][0]
                    inSrc_0 = v2c_vec[in_id_0]

                # TO assign the input source 1
                if(cascade_lut_f2_inSrc[f2_m][1] >= inSrc_offset):
                    in_id_1 = cascade_lut_f2_inSrc[f2_m][1] - inSrc_offset
                    inSrc_1 = f1_tc[in_id_1]
                else:
                    in_id_1 = cascade_lut_f2_inSrc[f2_m][1]
                    inSrc_1 = v2c_vec[in_id_1]

                f2_tc[f2_m], f2_sign_forward[f2_m] = lut_symmetric_cascade_internal(iter, m, inSign_0, inSrc_0, inSrc_1)
                f2_tc[f2_m] = f2_tc[f2_m] + (f2_sign_forward[f2_m] << (q-1)) # to concatenate the magnitude with sign bit
            cnu6_f03_dut_sample_gen(v2c_vec, f2_tc, m) # write the input-output log file for RTL DUTs

        elif m == 3:
            for f3_m in range(cascade_lut_num[m]):
                # To assign the input source 0
                if(cascade_lut_f3_inSrc[f3_m][0] >= inSrc_offset):
                    in_id_0 = cascade_lut_f3_inSrc[f3_m][0] - inSrc_offset
                    inSrc_0 = f2_tc[in_id_0] % (2**(q-1))
                    inSign_0 = f2_sign_forward[in_id_0]
                else:
                    in_id_0 = cascade_lut_f3_inSrc[f3_m][0]
                    inSrc_0 = v2c_vec[in_id_0]

                # TO assign the input source 1
                if(cascade_lut_f3_inSrc[f3_m][1] >= inSrc_offset):
                    in_id_1 = cascade_lut_f3_inSrc[f3_m][1] - inSrc_offset
                    inSrc_1 = f2_tc[in_id_1]
                else:
                    in_id_1 = cascade_lut_f3_inSrc[f3_m][1]
                    inSrc_1 = v2c_vec[in_id_1]

                f3_tc[f3_m] = lut_symmetric_cascade_out(iter, m, inSign_0, inSrc_0, inSrc_1)
            cnu6_f03_dut_sample_gen(v2c_vec, f3_tc, m) # write the input-output log file for RTL DUTs

        else:
            print("Wrong parameter is passed, the M is only until %d but the actual passed M is %d" % (M-2, m))
            sys.exit()

        #c2v_dut_sample_gen(v2c_vec, f3_tc)

    return f3_tc

## Generate check-to-variable message samples for DUT
def c2v_dut_sample_gen(v2c_vec, c2v_vec):
    c2v_dut_file.write(
        str(hex(int(v2c_vec[0]))[2]) + "," +
        str(hex(int(v2c_vec[1]))[2]) + "," +
        str(hex(int(v2c_vec[2]))[2]) + "," +
        str(hex(int(v2c_vec[3]))[2]) + "," +
        str(hex(int(v2c_vec[4]))[2]) + "," +
        str(hex(int(v2c_vec[5]))[2]) + "," +

        str(hex(int(c2v_vec[0]))[2]) + "," +
        str(hex(int(c2v_vec[1]))[2]) + "," +
        str(hex(int(c2v_vec[2]))[2]) + "," +
        str(hex(int(c2v_vec[3]))[2]) + "," +
        str(hex(int(c2v_vec[4]))[2]) + "," +
        str(hex(int(c2v_vec[5]))[2]) + "\n"
    )

def cascade_lut_pattern_gen():
    awgn_test_pattern = gng.sw_gauss_sample_gen(export_filename=cas_awgn_filename, mean=mean_eval, std_dev=gng.std_dev_cal(snr_eval), num=test_sample_num)
    ch_msg_test_pattern = gng.ib_mapping(awgn_test_pattern, ch_msg_filename)
    return ch_msg_test_pattern

def main():
    # exportCNU_LUT_COE()
    # exportCNU_LUT_CSV()
    # gen_CNU_LUT_V()
    # dut_pattern_gen()
    # showCNU_LUT(1)

    #lut_symmetric_vis() # visualise the symmetry of LUT for ease of observation
    #single_lut_symmetry_eval() # evaluate 2-input LUT solely
    '''
    t0 = [0] * test_set_num
    t1 = [0] * test_set_num
    ch_msg_vec = [0] * test_sample_num
    ch_msg_vec = cascade_lut_pattern_gen()

    for i in range(test_set_num):
        t0[i] = cascade_lut_baseline(ch_msg_vec[test_set_unit*i:test_set_unit*i+test_set_unit])
        #print("Channel Message: ", ch_msg_vec, "\nCascadded LUTs (baseline): ", t0[i])

        t1[i] = symmetric_cascade_lut(0, ch_msg_vec[test_set_unit*i:test_set_unit*i+test_set_unit])
        #print("\nChannel Message: ", ch_msg_vec, "\nCascadded LUTs (symmetry): ", t1[i])


    # Verification
    single_lut_symmetry_eval()

    err = 0
    for i in range(test_set_num):
        if int(t0[i]) != int(t1[i]):
            err = err + 1
            for j in range(test_set_unit*i, test_set_unit*i+test_set_unit):
                print(format(ch_msg_vec[j], '04b'))
            print("TestSet_%d: expect->%d, actual->%d\n" % (i, t0[i], t1[i]))

    if err == 0:
        print("Verification is passed")
    else:
        print("Err: %d" % (err))

    for m in range(M):
        print("=============== M: %d ===================" % (m))
        for y0 in range(cardinality):
            for y1 in range(cardinality):
                t = lut_baseline(m, y0, y1)
                print("(%d, %d) = %d" % (y0, y1, t))
    '''

    v2c_sample = np.zeros(CN_DEGREE, dtype=np.int8)
    c2v_sample = np.zeros(CN_DEGREE, dtype=np.int8)
    for iter in range(1): # only do the DUT of 0th iteration
        for v2c_aggregate in range(2**24 - 1):
            for i in range(CN_DEGREE):
                right_shift = v2c_aggregate >> (i*q)
                v2c_sample[i] = right_shift % (2**q)

            c2v_sample = cascaded_cnu6_sym_sw(iter, v2c_sample)
        #print("Iter_", iter, "  v2c: ", v2c_sample, " --> c2v: ", c2v_sample)

if __name__ == "__main__":
    '''
    c2v_dut_file = open(c2v_dut_filename, "w")
    cnu_f0_dut_file = open(cnu_f0_dut_filename, "w")
    cnu_f1_dut_file = open(cnu_f1_dut_filename, "w")
    cnu_f2_dut_file = open(cnu_f2_dut_filename, "w")
    cnu_f3_dut_file = open(cnu_f3_dut_filename, "w")
    main()
    c2v_dut_file.close()
    cnu_f0_dut_file.close()
    cnu_f1_dut_file.close()
    cnu_f2_dut_file.close()
    cnu_f3_dut_file.close()
    '''
    for i in range(8):
        for j in range(8):
            t = lut_baseline(0, 0, i, j) % 8
            t = format(t, '03b')
            print((i % 8), ',', (j % 8), ',',t)
