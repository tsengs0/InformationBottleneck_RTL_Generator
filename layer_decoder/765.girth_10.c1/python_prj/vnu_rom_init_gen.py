import h5py
import csv
import subprocess
import numpy as np
import math
import json
import random

q = 4  # 4-bit quantisation
VN_DEGREE = 3+1
M = VN_DEGREE-2
cardinality = pow(2, q) # by exploiting the symmetry of CNU, 3-Gbit input is enough
Iter_max = 10

# Parameters for IB-CNU RAMs accesses
depth_ib_func = (cardinality/2) * cardinality # only half symmetry
interleave_bank_num = 2
depth_ram = depth_ib_func / interleave_bank_num # indicating one iteration dataset only

file_lut_csv = 'lut_'  # lut_Iter50_Func3.csv
file_lut_coe = 'lut_'  # lut_Iter50_Func3.coe
file_lut_rtl = 'lut_cnu_'
cmd_mkdir = 'mkdir '
cmd_move = 'mv '
cmd_copy = 'cp -a '

###########################################################################################################################################
f_lut = open('/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/ib_10_layered_loc_min-lut_2.2_444_123_1000_az.json' , 'r')
data_lut = json.load(f_lut)
# To make sure if the given JSON file match the configuration size
var_node_lut_db =  data_lut['config_system']['config_vn']['mappings']['data']
db_iter_num = len(var_node_lut_db)/(M+1)
if db_iter_num != Iter_max:
    print('The maximum iteration is %d but only %d iterations\' datasets are contained inside the JSON file' % (Iter_max, db_iter_num))
    exit()
###########################################################################################################################################

# Get pointer of target LUT
def ptr(m):
    offset = (cardinality**2)*m
    return offset

# Get result of designated LUT
def lut_out(iter, y0, y1, offset):
    t = var_node_lut_db[iter][offset+(y0 * cardinality + y1)]
    return t

# Get result of designated LUT for Layered decoder only
def layer_lut_out(iter, y0, y1, offset):
    mapped_addr = 2**(2*q-1) - 1 - (y0*cardinality+y1)
    t = var_node_lut_db[iter][mapped_addr+offset]
    return t

# Get result of designated LUT for Layered decoder only with inverstion of all magnitude values
def layer_mag_inv_lut_out(iter, y0, y1, offset):
    mapped_addr = 2**(2*q-1) - 1 - (y0*cardinality+y1)
    t = var_node_lut_db[iter][mapped_addr+offset]
    t = mag_inv(t, 1)
    return t

# Get result of designated LUT with inversion of all magnitude values
def mag_inv_lut_out(iter, y0, y1, offset, mag_ctrl):
    t = var_node_lut_db[iter][offset+(y0 * cardinality + y1)]
    t = mag_inv(t, mag_ctrl)
    return t

def not_gate(bitwidth, val):
    return 2**(bitwidth)-1-val

def layer_app_lut_out(iter, y0, y1, offset):
    mapped_addr = (2**(q-1)-1-y0)*cardinality + y1
    t = var_node_lut_db[iter][mapped_addr+offset]
    return t
###########################################################################################################################################
# The design managed to completely remove all abs() conversion of VNU LUTs' input sources, as well as abs() converstion and signed-value converstion from CNUs
def layer_no_absIn_f0_lut_out(iter, y0, y1, offset):
    mapped_addr_y0 = not_gate(bitwidth=q-1, val=y0)
    mapped_addr_y1 = not_gate(bitwidth=q, val = y1)
    v2c_msg_in = mag_inv(signed_val=mapped_addr_y1, ctrl=0)
    mapped_addr = mapped_addr_y0*cardinality + v2c_msg_in
    t = var_node_lut_db[iter][mapped_addr+offset]
    t = mag_inv(t, 1)
    return t

def layer_no_absIn_lut_out(iter, y0, y1, offset, mag_ctrl):
    v2c_msg_in = mag_inv(signed_val=y1, ctrl=0)
    t = var_node_lut_db[iter][offset+(y0 * cardinality + v2c_msg_in)]
    t = mag_inv(t, mag_ctrl)
    return t

def layer_app_no_absIn_lut_out(iter, y0, y1, offset):
    v2c_msg_in = mag_inv(signed_val=y1, ctrl=0)
    mapped_addr = (2**(q-1)-1-y0)*cardinality + v2c_msg_in
    t = var_node_lut_db[iter][mapped_addr+offset]
    return t
###########################################################################################################################################
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
        # Format: Since RAMB36E1 is chosen with 36-bit of read data width, 12 entries per RAM row, i.e., 12-entry x 3-bit = 36-bit.
        # Radix: binary.
        # Depth of BRAM (RAMB36E1): ceil(64-entry*3-bit*25/36) = 133
        # Write down output value of each corresponding entry
        for m in range(M):
            create_coe_filename = file_lut_coe + 'Iter' + str(25*i) + '_' + str((25*i)+25 - 1) + '_Func'+str(m)+'.coe'
            coe_file = open(create_coe_filename, "w")
            coe_file.write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")

            line = 0
            cnt = 0
            for iter in range(25*i, (25*i)+25):
                offset = ptr(iter, m)
                for y0 in range(int(cardinality/2)): # only half symmetry
                    for y1 in range(int(cardinality)):
                        t = int(lut_out(y0, y1, offset))

                        # Positive Base, e.g., 8 in 4-bit case
                        pos_base = 2**(q-1)
                        invert_sub = pos_base-1
                        if t >= pos_base:
                            print("t:", str(format(t, '04b')))
                            t = (invert_sub-(t-pos_base))+pos_base
                            print("invtT:", str(format(t, '04b')), '\n')

                        if y0 == (cardinality/2) - 1 and y1 == cardinality - 1 and line == (depth_ib_func/interleave_bank_num)*25-1:
                            coe_file.write(str(format(t, '04b')) + ";")
                        else:
                            if (cnt == interleave_bank_num-1):
                                coe_file.write(str(format(t, '04b')) + ", \n")
                                line = line + 1
                                cnt = 0
                            else:
                                coe_file.write(str(format(t, '04b')))
                                cnt = cnt + 1
            subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/' + filename + '/', shell=True)
            coe_file.close()


def inv(bitwidth, val):
    return (2**bitwidth)-1-val

def mag_inv(signed_val, ctrl):
    sign = signed_val >> (q-1)
    mag = signed_val & (cardinality-1-(2**(q-1)))
    if sign == ctrl:
        return ( inv(bitwidth=q-1, val=mag) + (sign << (q-1)) )
    else:
        return signed_val

def sign_mag_inv(signed_val, sel, ctrl):
    if sel == ctrl:
        return (cardinality-1-signed_val)
    else:
        return signed_val

def sign_bit(signed_val):
    return (signed_val >> (q-1))

def mag_bits(signed_val):
    return (signed_val & ~(1 << (q-1)))

def ib_flood_sym_vnu(msg_in):
    sign_ch = msg_in[0] >> (q-1)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0=mag_inv(msg_in[0], 1)
            y0=mag_bits(y0)
            y1=sign_mag_inv(msg_in[1], sign_ch, 1)
            t[i] = lut_out(iter=0, y0=y0, y1=y1, offset=offset)
            rotate_en = sign_ch
        elif i < (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)
            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=0, y0=y0, y1=y1, offset=offset)
            rotate_en = sel
        elif i == (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)

            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=0, y0=y0, y1=y1, offset=offset)
            t[i] = sign_mag_inv(t[i], sel, 1)
            #t[i] = sign_bit(t[i])^sel

            t[i-1] = sign_mag_inv(t[i-1], rotate_en, 1)# v2c
            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

def ib_layer_sym_vnu(msg_in):
    sign_ch = msg_in[0] >> (q-1)
    x_offset=int(cardinality/2)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0 = mag_inv(msg_in[0], 0) # implict converstion by IB-Channel Quantiser
            y0=mag_bits(y0)
            y1=sign_mag_inv(msg_in[1], sign_ch, 1)
            t[i] = layer_lut_out(iter=0, y0=y0, y1=y1, offset=offset) # only F0 is based on special IB-LUT
            rotate_en = sign_ch
        elif i < (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)
            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=0, y0=y0, y1=y1, offset=offset)
            rotate_en = sel
        elif i == (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)

            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=0, y0=y0, y1=y1, offset=offset)
            t[i] = sign_mag_inv(t[i], sel, 1)
            #t[i] = sign_bit(t[i])^sel

            t[i-1] = sign_mag_inv(t[i-1], rotate_en, 1)# v2c
            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

def ib_layer_eliminated_sym_vnu(msg_in):
    sign_ch = msg_in[0] >> (q-1)
    x_offset=int(cardinality/2)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0 = mag_inv(msg_in[0], 0) # implict converstion by IB-Channel Quantiser
            y0=mag_bits(y0)
            y1=sign_mag_inv(msg_in[1], sign_ch, 1)
            t[i] = layer_mag_inv_lut_out(iter=0, y0=y0, y1=y1, offset=offset) # only F0 is based on special IB-LUT
            rotate_en = sign_ch
        elif i < (decomp_num-2):
            y0=mag_bits(t[i-1])
            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = mag_inv_lut_out(iter=0, y0=y0, y1=y1, offset=offset, mag_ctrl=1)
            rotate_en = sel
        elif i == (decomp_num - 2): # to output the variable-to-check message
            y0 = mag_bits(t[i - 1])
            sel = rotate_en ^ sign_bit(t[i - 1])
            y1 = sign_mag_inv(msg_in[i + 1], sel, 1)

            t[i] = mag_inv_lut_out(iter=0, y0=y0, y1=y1, offset=offset, mag_ctrl=0)
            rotate_en = sel
        elif i == (decomp_num-1):
            y0=mag_bits(t[i-1])
            #y0=not_gate(bitwidth=q-1, val=y0)
            y0_sign = sign_bit(t[i-1])

            sel = rotate_en^y0_sign
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = layer_app_lut_out(iter=0, y0=y0, y1=y1, offset=offset)

            t[i] = sign_mag_inv(t[i], sel, 1)
            #t[i] = sign_bit(t[i])^sel

            v2c_sign = rotate_en^y0_sign
            t[i-1] = mag_bits(t[i-1]) + (v2c_sign << (q-1)) # v2c
            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

def ib_layer_no_absIn_sym_vnu(msg_in):
    sign_ch = msg_in[0] >> (q-1)
    x_offset=int(cardinality/2)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0 = mag_inv(msg_in[0], 0) # implict converstion by IB-Channel Quantiser
            y0=mag_bits(y0)

            in_src_1 = mag_inv(signed_val=msg_in[1], ctrl=0) # to mimic the removal of signed-value conversion from output of CNU
            y1_sign = sign_bit(in_src_1)^sign_bit(msg_in[0])
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_no_absIn_f0_lut_out(iter=0, y0=y0, y1=y1, offset=offset) # only F0 is based on special IB-LUT
            rotate_en = sign_ch
        elif i < (decomp_num-2):
            y0=mag_bits(t[i-1])
            sel = rotate_en^sign_bit(t[i-1])

            in_src_1 = mag_inv(signed_val=msg_in[i+1], ctrl=0) # to mimic the removal of signed~value conversion from output of CNU
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_no_absIn_lut_out(iter=0, y0=y0, y1=y1, offset=offset, mag_ctrl=1)
            rotate_en = sel
        elif i == (decomp_num - 2): # to output the variable-to-check message
            y0 = mag_bits(t[i - 1])
            sel = rotate_en ^ sign_bit(t[i - 1])

            in_src_1 = mag_inv(signed_val=msg_in[i+1], ctrl=0) # to mimic the removal of signed~value conversion from output of CNU
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            t[i] = layer_no_absIn_lut_out(iter=0, y0=y0, y1=y1, offset=offset, mag_ctrl=0)
            rotate_en = sel
        elif i == (decomp_num-1):
            y0=mag_bits(t[i-1])
            #y0=not_gate(bitwidth=q-1, val=y0)
            y0_sign = sign_bit(t[i-1])

            sel = rotate_en^y0_sign

            in_src_1 = mag_inv(signed_val=msg_in[i+1], ctrl=0) # to mimic the removal of signed~value conversion from output of CNU
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_app_no_absIn_lut_out(iter=0, y0=y0, y1=y1, offset=offset)

            t[i] = sign_mag_inv(t[i], sel, 1)
            #t[i] = sign_bit(t[i])^sel

            v2c_sign = rotate_en^y0_sign
            t[i-1] = mag_bits(t[i-1]) + (v2c_sign << (q-1)) # v2c
            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

def main():
    #exportVNU_LUT_COE_Iter0_25()

    iter = 0
    m = 0
    y0 = [x for x in range(0,8)]
    y1 = [x for x in range(0,16)]
    t = [[0 for x in range(16)] for y in range(8)]
    offset = ptr(m)
    for i in range(8):
        for j in range(16):
            temp=int(lut_out(iter=iter, y0=y0[i], y1=y1[j], offset=offset))
            t[i][j] = format(temp, '04b')
    print(t)

if __name__ == "__main__":
    #main()

    for i in range(10000):
        msg_in=[random.randint(0, 15), random.randint(0, 15), random.randint(0, 15), random.randint(0, 15)]
        flood_temp = ib_flood_sym_vnu(msg_in=msg_in)
        layer_temp = ib_layer_sym_vnu(msg_in=msg_in)
        layer_temp_cnuIn = ib_layer_eliminated_sym_vnu(msg_in=msg_in)
        layer_no_absIn_temp = ib_layer_no_absIn_sym_vnu(msg_in=msg_in)
        flood_v2c = flood_temp[1]
        layer_v2c = layer_temp[1]

        t=np.zeros(3, dtype=np.int32)
        offset=ptr(0)
        t[0] = lut_out(iter=0, y0=msg_in[0], y1=msg_in[1], offset=offset)
        #print("Without Symmetry: %d" %(t[0]))
        offset=ptr(1)
        t[1] = lut_out(iter=0, y0=t[0], y1=msg_in[2], offset=offset)
        #print("Without Symmetry: %d" %(t[1]))
        offset=ptr(2)
        t[2] = lut_out(iter=0, y0=t[1], y1=msg_in[3], offset=offset)
        #print("Without Symmetry: %d" %(t[2]))

        #print("actual_v2c:%d(\t%d\t)\tflood_v2c:%d(\t%d\t)\tlayer_v2c:%d(\t%d\t)" %(t[1], t[2], flood_v2c, flood_temp[2], layer_v2c, layer_temp[2]))
        if flood_v2c != t[1]:
            print("-----Sample_%d: V2Cs are not identical, i.e., %d != %d" %(i, flood_v2c, t[1]))
        #else:
            #print("V2Cs: %d == %d" %(flood_v2c, t[1]))

        if flood_temp[2] != t[2]:
            print("-----Sample_%d: APPs are not identical, i.e., %d != %d" %(i, flood_temp[2], t[2]))
        #else:
            #print("APPs: %d == %d" %(flood_temp[2], t[2]))

        if layer_v2c != t[1]:
            print("----------------------------(Layer)\tSample_%d: V2Cs are not identical, i.e., %d != %d" %(i, layer_v2c, t[1]))
        #else:
            #print("(Layer)\tV2Cs: %d == %d" %(layer_v2c, t[1]))

        if layer_temp[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" %(i, layer_temp[2], t[2]))
        #else:
            #print("(Layer)\tAPPs: %d == %d" %(layer_temp[2], t[2]))

        if layer_temp_cnuIn[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" %(i, layer_temp_cnuIn[2], t[2]))
        #else:
            #print("(Layer)\tAPPs: %d == %d" %(layer_temp_cnuIn[2], t[2]))

        if layer_no_absIn_temp[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" %(i, layer_no_absIn_temp[2], t[2]))
        #else:
            #print("(Layer)\tAPPs: %d == %d" %(layer_no_absIn_temp[2], t[2]))
        '''-----------------------------------------------------------------------------------------'''
        # Other verification
        flood_v2c_cnuIn = mag_inv(flood_temp[1], 0)
        layer_v2c_cnuIn = mag_inv(layer_temp[1], 0)
        layer_temp_v2c_cnuIn = layer_temp_cnuIn[1]

        if ~(flood_v2c_cnuIn == layer_v2c_cnuIn == layer_temp_v2c_cnuIn):
            print("------------------------(Wrong)\tcnuIn:(%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))
        #else:
            #print("cnuIn:(%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))
        '''-----------------------------------------------------------------------------------------'''
        # verification (19.June.2021) where all converstion at I/O of both CNUs and VNUs are aimed to be removed
        layer_no_absIn_v2c = layer_no_absIn_temp[1]

        if ~(flood_v2c_cnuIn == layer_v2c_cnuIn == layer_temp_v2c_cnuIn == layer_no_absIn_v2c):
            print("--(Wrong)\tV2C:(%d\t%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn, layer_no_absIn_v2c))
        #else:
        #print("cnuIn:(%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))

'''
    print(var_node_lut_db)
    for j in range(Iter_max):
        for i in range(VN_DEGREE-1):
            offset=ptr(i)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t=lut_out(iter=j, y0=y0, y1=y1, offset=offset)

                    if t != var_node_lut_db[j][(cardinality**2)*i+((y0 << q)+y1)]:
                        print('y0_%d, y1_%d at F%d of Iter_%d doest not match\n' %(y0, y1, i, j))
                    else:
                        print("%d, " %(t), end="")
        print("\n")
'''


#        delta5 = np.zeros((8, 16), dtype=np.int32)
# bash -> ./ls > $(date "+%Y.%m.%d-%H.%M.%S").ver