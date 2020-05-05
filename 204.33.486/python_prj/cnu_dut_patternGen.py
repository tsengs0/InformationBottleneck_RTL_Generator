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

def counter_cardinality(msg, cin):
    co = 0
    if cin == 1:
        if msg < (cardinality-1):
            msg = msg + 1
        else:
            msg = 0
            co = 1
    return msg, co

# Get pointer of target LUT
def ptr(i, m):
    offset = i * M * cardinality * cardinality + m * cardinality * cardinality
    return offset

# Get result of designated LUT
def lut_out(y0, y1, offset):
    t = check_node_lut[offset + y0 * cardinality + y1]
    return t

# DUT test patterns generation of IB-CNU RAMs Write
def dut_pattern_gen():
    dut_folder_filename = "DUT_BRAM32"
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
            page = 0
            create_write_data_filename = 'data.iter' + str(i) + '.func' + str(m) + '.csv'
            create_write_addr_filename = 'addr.iter' + str(i) + '.func' + str(m) + '.csv'
            data_pattern_file = open(create_write_data_filename, "w")
            addr_pattern_file = open(create_write_addr_filename, "w")
            offset = ptr(i, m)

            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        if m == M-1:
                            data_pattern_file.write(str(hex(int(t))[2:]))
                        else:
                            data_pattern_file.write(str(hex(int(t))[2:]) + "\n")
                    else:
                        if (cnt % interleave_bank_num) == 0:
                            data_pattern_file.write(str(hex(int(t))[2:]) + "\n")
                            addr_pattern_file.write(str(page) + "\n")
                            page = page + 1
                        else:
                            data_pattern_file.write(str(hex(int(t))[2:]) + ",")
                    cnt = cnt + 1
            subprocess.call(cmd_move + create_write_data_filename + ' ' + ramData_folder_filename + '/Iter_' + str(i) + '/',shell=True)
            subprocess.call(cmd_move + create_write_addr_filename + ' ' + ramAddr_folder_filename + '/Iter_' + str(i) + '/',shell=True)
            data_pattern_file.close()
            addr_pattern_file.close()

# DUT test patterns generation of IB-CNU RAMs Write
def dut_pattern_gen_0_3():
    dut_folder_filename = "DUT_BRAM32_0_3"
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

        create_write_data_filename = 'data.iter' + str(i) + '.func0_3.csv'
        create_write_addr_filename = 'addr.iter' + str(i) + '.func0_3.csv'
        data_pattern_file = open(create_write_data_filename, "w")
        addr_pattern_file = open(create_write_addr_filename, "w")
        # Create M sets of write data and addresses patterns files, where M is the number of 2-LUTs
        cnt = 1
        for m in range(M):
            page = 0
            offset = ptr(i, m)

            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality - 1 and y1 == cardinality - 1:
                        if m == M-1:
                            data_pattern_file.write(str(hex(int(t))[2:]))
                            addr_pattern_file.write(str(page))
                        else:
                            data_pattern_file.write(str(hex(int(t))[2:]) + "\n")
                            addr_pattern_file.write(str(page) + "\n")
                            page = page + 1
                    else:
                        if (cnt % interleave_bank_num) == 0:
                            data_pattern_file.write(str(hex(int(t))[2:]) + "\n")
                            addr_pattern_file.write(str(page) + "\n")
                            page = page + 1
                        else:
                            data_pattern_file.write(str(hex(int(t))[2:]) + ",")
                    cnt = cnt + 1
        subprocess.call(cmd_move + create_write_data_filename + ' ' + ramData_folder_filename + '/Iter_' + str(i) + '/',shell=True)
        subprocess.call(cmd_move + create_write_addr_filename + ' ' + ramAddr_folder_filename + '/Iter_' + str(i) + '/',shell=True)
        data_pattern_file.close()
        addr_pattern_file.close()


# DUT test patterns generation of IB-CNU RAM access pattern of f_3{y0, y1}
def f0_3_pattern_gen():
    dut_folder_filename = "DUT_LUTM"
    pattern_folder_filename = dut_folder_filename + '/IB_CNU_f0_3_PATTERN'
    ramData_folder_filename = pattern_folder_filename + '/ram_write_data'
    subprocess.call(cmd_mkdir + dut_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + pattern_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + ramData_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename = cmd_mkdir + 'Iter_' + str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + 'Iter_' + str(i) + ' ' + ramData_folder_filename + '/', shell=True)

        # Create M sets of write data and addresses patterns files, where M is the number of 2-LUTs
        cnt = 1
        for m in range(M):
            create_write_data_filename = 'data.iter' + str(i) + '.func' + str(m) + '.csv'
            data_pattern_file = open(create_write_data_filename, "w")
            offset = ptr(i, m)

            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality-1 and y1 == cardinality-1:
                        data_pattern_file.write(str(hex(int(y0))[2:])+","+str(hex(int(y1))[2:])+","+str(hex(int(t))[2:]))
                    else:
                        data_pattern_file.write(str(hex(int(y0))[2:]) + "," + str(hex(int(y1))[2:]) + "," + str(hex(int(t))[2:]) + "\n")
            subprocess.call(cmd_move + create_write_data_filename + ' ' + ramData_folder_filename + '/Iter_' + str(i) + '/',shell=True)
            data_pattern_file.close()

# DUT test patterns generation of IB-CNU RAM access pattern of f_3{y0, y1}
def c2v_cnu6_pattern_gen():
    dut_folder_filename = "DUT_C2V"
    pattern_folder_filename = dut_folder_filename + '/IB_CNU6_PATTERN'
    ramData_folder_filename = pattern_folder_filename + '/ram_read_data'
    subprocess.call(cmd_mkdir + dut_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + pattern_folder_filename, shell=True)
    subprocess.call(cmd_mkdir + ramData_folder_filename, shell=True)

    create_write_data_filename = 'Iter_0_C2V' + '.csv'
    data_pattern_file = open(create_write_data_filename, "w")
    test(data_pattern_file)
    subprocess.call(cmd_move + create_write_data_filename + ' ' + ramData_folder_filename + '/',shell=True)
    data_pattern_file.close()

#dut_pattern_gen()
#dut_pattern_gen_0_3()
#f0_3_pattern_gen()

def test(data_pattern_file):
    iter = 0
    v2c_msg = [0, 0, 0, 0, 0, 0]
    c2v_msg = [0, 0, 0, 0, 0, 0]
    offset = [0, 1, 2, 3]
    permutation_id = [0, 1, 2, 3, 4]  # d_c -1 number of incoming messages
    permutation = [[0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4], [0, 1, 2, 3, 4]]
    Cin = 1
    Co = [0, 0, 0, 0, 0, 0]
    for m in range(M):
        offset[m] = ptr(iter, m)  # iter=0, only evaluate 0th iteration
    for msg in range(CN_DEGREE):
        if msg != CN_DEGREE - 1:
            for i in range(CN_DEGREE - 1):
                if i >= permutation_id[msg]:
                    permutation[msg][i] = permutation[msg][i] + 1
    # Generate the  2^{d_c*q} number of sets of d_c number of check-to-variable messages
    for i in range(pow(cardinality, CN_DEGREE)):
        for msg in range(CN_DEGREE):
            t_c = [0] * M
            for m in range(M):
                if m == 0:
                    t_c[0] = lut_out(v2c_msg[permutation[msg][0]], v2c_msg[permutation[msg][1]], offset[0])
                else:
                    t_c[m] = lut_out(t_c[m - 1], v2c_msg[permutation[msg][m + 1]], offset[m])
            c2v_msg[msg] = t_c[M - 1]
        #print(v2c_msg, c2v_msg)
        #print(str(v2c_msg[0])+","+str(v2c_msg[1])+","+str(v2c_msg[2])+","+str(v2c_msg[3])+","+str(v2c_msg[4])+","+str(v2c_msg[5])+","+str(c2v_msg[0])+","+str(c2v_msg[1])+","+str(c2v_msg[2])+","+str(c2v_msg[3])+","+str(c2v_msg[4])+","+str(c2v_msg[5]))
        data_pattern_file.write(
            str(hex(int(v2c_msg[0]))[2:]) + ","+
            str(hex(int(v2c_msg[1]))[2:]) + ","+
            str(hex(int(v2c_msg[2]))[2:]) + ","+
            str(hex(int(v2c_msg[3]))[2:]) + ","+
            str(hex(int(v2c_msg[4]))[2:]) + ","+
            str(hex(int(v2c_msg[5]))[2:]) + ","+
            str(hex(int(c2v_msg[0]))[2:]) + "," +
            str(hex(int(c2v_msg[1]))[2:]) + "," +
            str(hex(int(c2v_msg[2]))[2:]) + "," +
            str(hex(int(c2v_msg[3]))[2:]) + "," +
            str(hex(int(c2v_msg[4]))[2:]) + "," +
            str(hex(int(c2v_msg[5]))[2:]) + "\n"
        )
        for j in range(CN_DEGREE):
            if j == 0:
                v2c_msg[0], Co[0] = counter_cardinality(v2c_msg[0], Cin)
            else:
                v2c_msg[j], Co[j] = counter_cardinality(v2c_msg[j], Co[j - 1])

#test()

#offset = [0]*M
#t_c = [0]*M
#permutation = [0,0,0,3, 0]
#for m in range(M):
#    offset[m] = ptr(0, m)
#    if m == 0:
#        t_c[m] = lut_out(permutation[0],permutation[1], offset[m])
#        print("F_" + str(m) + "(" + str(hex(int(permutation[0]))[2:]) + "," +  str(hex(int(permutation[1]))[2:])+ ")= " + str(hex(int(t_c[m]))[2:]))
#    else:
#        t_c[m] = lut_out(t_c[m-1], permutation[m+1], offset[m])
#        print("F_" + str(m) + "(" + str(hex(int(t_c[m-1]))[2:]) + "," + str(hex(int(permutation[m+1]))[2:]) + ")= " + str(hex(int(t_c[m]))[2:]))
#print("E1: "+str(t_c[M-1]))

c2v_cnu6_pattern_gen()
