import h5py
import csv
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib.colors import ListedColormap

q = 4  # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE - 2
cardinality = pow(2, q)
Iter_max = 50

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


# DUT test patterns generation of IB-CNU RAMs Write
def dut_pattern_gen():
    dut_folder_filename = "DUT"
    pattern_folder_filename = dut_folder_filename + '/IB_CNU_RAM_PATTERN'
    ramData_folder_filename = pattern_folder_filename + '/ram_write_data'
    ramAddr_folder_filename = pattern_folder_filename + '/ram_write_addr'
    subprocess.call(cmd_mkdir + dut_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + pattern_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + ramData_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + ramAddr_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_copy + 'Iter_' + str(i) + ' ' + ramData_folder_filename + '/', shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + ramAddr_folder_filename + '/', shell=True)

        # Create M sets of write data and addresses patterns files, where M is the number of 2-LUTs
        cnt = 1
        for m in range(M):
            create_write_data_filename = 'data.iter' + str(i) + '.func' + str(m) + '.csv'
            create_write_addr_filename = 'addr.iter' + str(i) + '.func' + str(m) + '.csv'
            data_pattern_file = open(create_write_data_filename, "w")
            addr_pattern_file = open(create_write_addr_filename, "w")
            offset = ptr(i, m)
            page = 0
            page_range = 3
            page_cnt = 1
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        data_pattern_file.write(str(hex(int(t))[2:]))
                    else:
                        if (cnt % interleave_bank_num) == 0:
                            data_pattern_file.write(str(hex(int(t))[2:]) + "\n")
                            if page in range(page_range):
                                addr_pattern_file.write(str(page) + "\n")
                                page = page + 1
                            else:
                                page = page - 1
                                page_range = page_range + 2
                                addr_pattern_file.write(str(page) + "\n")
                                page = page+1
                        else:
                            data_pattern_file.write(str(hex(int(t))[2:]) + ",")
                    cnt = cnt + 1
                    page_cnt = page_cnt+1
            subprocess.call(cmd_move + create_write_data_filename + ' ' + ramData_folder_filename + '/Iter_' + str(i) + '/',shell=True)
            subprocess.call(cmd_move + create_write_addr_filename + ' ' + ramAddr_folder_filename + '/Iter_' + str(i) + '/',shell=True)
            data_pattern_file.close()
            addr_pattern_file.close()


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

# exportCNU_LUT_COE()
# exportCNU_LUT_CSV()
# gen_CNU_LUT_V()
#dut_pattern_gen()
#showCNU_LUT(1)
y0_vec = [0]*cardinality
y1_vec = [0]*cardinality
t_c_vec = [[0 for i in range(cardinality)] for j in range(cardinality)]
max_magnitude = (cardinality/2)-1
for m in range(1):
    offset = ptr(0, m)
    for y0 in range(cardinality):
        for y1 in range(cardinality):
            t_c = lut_out(y0, y1, offset)
            y0_vec[y0] = y0
            y1_vec[y1] = y1
            t_c = modulate(t_c)
            #if t_c > max_magnitude:
            #    t_c = max_magnitude - (t_c - max_magnitude - 1)
            t_c_vec[y0][y1] = t_c
symmetry_eval(y0_vec, y1_vec, t_c_vec)
