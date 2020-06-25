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

# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportCNU_LUT_COE():
    coe_folder_filename = 'COE_BRAM32'
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
def exportCNU_LUT_COE_0_3():
    coe_folder_filename = 'COE_BRAM32_0_3'
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
        create_coe_filename = file_lut_coe + 'Iter' + str(i) + '_Func0_3.coe'
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

#expotCNU_LUT_COE()
#exportCNU_LUT_COE_0_3()
y = [1, 1, 1, 1, 1]
t = [0, 0, 0, 0]
m=[0, 1, 2, 3]
offset=ptr(0, m[0])
t[0]=lut_out(y[0], y[1], offset)

offset=ptr(0, m[1])
t[1]=lut_out(t[0], y[2], offset)

offset=ptr(0, m[2])
t[2]=lut_out(t[1], y[3], offset)

offset=ptr(0, m[3])
t[3]=lut_out(t[2], y[4], offset)
print(t)

