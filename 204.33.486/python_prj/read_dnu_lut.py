import h5py
import csv
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import math

q = 4  # 4-bit quantisation
VN_DEGREE = 3+1
M = (VN_DEGREE - 2)+1
cardinality = pow(2, q)
Iter_max = 50
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
    #colors = ['red', 'yellow']
    cp = ax.contourf(y0, y1, t_c, levels=int(math.log2(modulation_phase)))
    fig.colorbar(cp)
    ax.set_title('Symmetry of 2-input LUT for Decision Node')
    ax.set_xlabel('y0 (4-bit)')
    ax.set_ylabel('y1 (4-bit)')
    plt.show()

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
# exportCNU_LUT_COE()
# exportCNU_LUT_CSV()
# gen_CNU_LUT_V()
#dut_pattern_gen()
#showCNU_LUT(1)
y0_vec = [int(0)]*cardinality
y1_vec = [int(0)]*cardinality
t_c_vec = [[int(0) for i in range(cardinality)] for j in range(cardinality)]
max_magnitude = (cardinality/2) - 1
m = 2
offset = ptr(0, m)
for y0 in range(cardinality):
    for y1 in range(cardinality):
        t_c = lut_out(y0, y1, offset)
        y0_vec[y0] = y0
        y1_vec[y1] = y1
        if t_c > max_magnitude:
            t_c = int(1)
        else:
            t_c = int(-1)
        t_c_vec[y0][y1] = t_c
symmetry_eval(y0_vec, y1_vec, t_c_vec)
