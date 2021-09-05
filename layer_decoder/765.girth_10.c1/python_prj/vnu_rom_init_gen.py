import h5py
import csv
import subprocess
import numpy as np
import math
import json
import random
import ib_lut_bd_compression as bdi

q = 4  # 4-bit quantisation
VN_DEGREE = 3+1
M = VN_DEGREE-2
cardinality = pow(2, q) # by exploiting the symmetry of CNU, 3-Gbit input is enough
Iter_max = 10
layer_num = VN_DEGREE-1
IB_ROM_MAX_ITER = 10

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

    y1_sign = sign_bit(y1)
    if y1_sign == 1:
        mapped_addr_y1 = mag_bits(y1)
    else:
        mapped_addr_y1 = not_gate(bitwidth=q-1, val=mag_bits(y1))

    mapped_addr_y1 = (y1_sign << (q-1)) + mapped_addr_y1
    mapped_addr = (mapped_addr_y0 << q) + mapped_addr_y1
    t = var_node_lut_db[iter][mapped_addr+offset]
    t = mag_inv(t, 1)
    return t

def layer_no_absIn_lut_out(iter, y0, y1, offset, mag_ctrl):
    y1_sign = sign_bit(y1)
    if y1_sign == 1:
        mapped_addr_y1 = mag_bits(y1)
    else:
        mapped_addr_y1 = not_gate(bitwidth=q - 1, val=mag_bits(y1))

    mapped_addr_y1 = (y1_sign << (q - 1)) + mapped_addr_y1
    mapped_addr = (y0 << q) + mapped_addr_y1
    t = var_node_lut_db[iter][offset+mapped_addr]
    t = mag_inv(t, mag_ctrl)
    return t

def layer_app_no_absIn_lut_out(iter, y0, y1, offset):
    y1_sign = sign_bit(y1)
    if y1_sign == 1:
        mapped_addr_y1 = mag_bits(y1)
    else:
        mapped_addr_y1 = not_gate(bitwidth=q - 1, val=mag_bits(y1))

    mapped_addr_y1 = (y1_sign << (q - 1)) + mapped_addr_y1
    mapped_addr = (y0 << q) + mapped_addr_y1
    t = var_node_lut_db[iter][offset+mapped_addr]

    return t
###########################################################################################################################################
# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportVNU_LUT_COE_Iter0_9():
    coe_folder_filename = 'COE_BRAM32.VNU'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(1):
        filename = 'Iter_' + str(IB_ROM_MAX_ITER * i) + '_' + str(( IB_ROM_MAX_ITER * i) + 10 - 1)
        create_Iter_filename = cmd_mkdir + filename
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + filename + ' ' + coe_folder_filename + '/', shell=True)

        for m in range(M):
            create_coe_filename = file_lut_coe + 'Iter' + str(IB_ROM_MAX_ITER*i) + '_' + str((IB_ROM_MAX_ITER*i)+10 - 1) + '_Func'+str(m)+'.coe'
            coe_file = open(create_coe_filename, "w")
            coe_file.write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")

            line = 0
            cnt = 0
            offset = ptr(m)
            for iter in range(10*i, (IB_ROM_MAX_ITER*i)+10):
                for y0 in range(int(cardinality/2)): # only half symmetry
                    for y1 in range(int(cardinality)):
                        if m == 0:
                            t = int(layer_no_absIn_f0_lut_out(iter=iter, y0=y0, y1=y1, offset=offset))  # only F0 is based on special IB-LUT
                        elif m < (M-1) and i > 0:
                            t = int(layer_no_absIn_lut_out(iter=iter, y0=y0, y1=y1, offset=offset, mag_ctrl=1))
                        elif m == (M-1):  # to output the variable-to-check message
                            t = int(layer_no_absIn_lut_out(iter=iter, y0=y0, y1=y1, offset=offset, mag_ctrl=0))
                        elif m == (decomp_num - 1):
                            t = int(layer_app_no_absIn_lut_out(iter=iter, y0=y0, y1=y1, offset=offset))

                        if y0 == (cardinality/2) - 1 and y1 == cardinality - 1 and line == (depth_ib_func/interleave_bank_num)*IB_ROM_MAX_ITER-1:
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

def lutram_addr_decode(y0, y1):
    page_addr = (mag_bits(y0) << (q - 1)) + (y1 >> 1)
    bank_addr = y1 % 2

    return page_addr, bank_addr

def VNU_LUT_construct():
    # ib_lut[Dc-2][IterNum][LayerNum][Page_Depth][BankNum][]
    ib_lut = np.zeros((M+1, Iter_max, layer_num, int(int(cardinality**2)/4), 2), dtype=np.int32)
    decomp_num = VN_DEGREE-1

    for m in range(M+1):
        line = 0
        cnt = 0
        offset = ptr(m)
        for iter in range(Iter_max):
            for layer_id in range(layer_num):
                iter_layer = (iter*layer_num)+layer_id
                for y0 in range(int(cardinality / 2)):  # only half symmetry
                    for y1 in range(int(cardinality)):
                        if m == 0:
                            t = int(layer_no_absIn_f0_lut_out(iter=iter_layer, y0=y0, y1=y1, offset=offset))  # only F0 is based on special IB-LUT
                        elif m < (M - 1) and i > 0:
                            t = int(layer_no_absIn_lut_out(iter=iter_layer, y0=y0, y1=y1, offset=offset, mag_ctrl=1))
                        elif m == (M - 1):  # to output the variable-to-check message
                            t = int(layer_no_absIn_lut_out(iter=iter_layer, y0=y0, y1=y1, offset=offset, mag_ctrl=0))
                        elif m == (decomp_num - 1):
                            t = int(layer_app_no_absIn_lut_out(iter=iter_layer, y0=y0, y1=y1, offset=offset))

                        page_addr, bank_addr = lutram_addr_decode(y0, y1)
                        ib_lut[m][iter][layer_id][page_addr][bank_addr] = t

    return ib_lut

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

def ib_flood_sym_vnu(iter_id, layer_id, msg_in):
    iter_layer_id = (iter_id*layer_num)+layer_id
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
            t[i] = lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset)
            rotate_en = sign_ch
        elif i < (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)
            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset)
            rotate_en = sel
        elif i == (decomp_num-1):
            y0=mag_inv(t[i-1], 1)
            y0=mag_bits(y0)

            sel = rotate_en^sign_bit(t[i-1])
            y1=sign_mag_inv(msg_in[i+1], sel, 1)
            t[i] = lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset)
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

def ib_layer_no_absIn_sym_vnu(iter_id, layer_id, msg_in):
    iter_layer_id = (iter_id*layer_num)+layer_id
    sign_ch = msg_in[0] >> (q-1)
    x_offset=int(cardinality/2)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0 = mag_bits(msg_in[0])
            y0=mag_bits(y0)

            in_src_1 = mag_bits(msg_in[1])
            y1_sign = sign_bit(in_src_1)^sign_bit(msg_in[0])
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_no_absIn_f0_lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset) # only F0 is based on special IB-LUT
            rotate_en = sign_ch
        elif i < (decomp_num-2):
            y0=mag_bits(t[i-1])
            sel = rotate_en^sign_bit(t[i-1])

            in_src_1 = mag_bits(msg_in[i+1])
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_no_absIn_lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset, mag_ctrl=1)
            rotate_en = sel
        elif i == (decomp_num - 2): # to output the variable-to-check message
            y0 = mag_bits(t[i - 1])
            sel = rotate_en ^ sign_bit(t[i - 1])

            in_src_1 = msg_in[i+1]
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            t[i] = layer_no_absIn_lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset, mag_ctrl=0)
            v2c_sign = sign_bit(t[i])^sel
            t[i] = mag_bits(t[i]) + (v2c_sign << (q-1)) # v2c
            rotate_en = sel
        elif i == (decomp_num-1):
            v2c_sign = sign_bit(t[i-1])
            y0_sign = v2c_sign^rotate_en # it is acually removable
            y0_mag = not_gate(bitwidth=q-1, val=mag_bits(t[i-1]))
            y0 = y0_mag
            sel = v2c_sign

            in_src_1 = msg_in[i+1]
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))
            t[i] = layer_app_no_absIn_lut_out(iter=iter_layer_id, y0=y0, y1=y1, offset=offset)

            t[i] = sign_mag_inv(signed_val=t[i], sel=sel, ctrl=1)
            #t[i] = sign_bit(t[i])^sel

            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

def ib_layer_no_absIn_sym_lutram(iter_id, layer_id, msg_in):
    ib_lut = VNU_LUT_construct()
    # -------------------------------------------------------------------------------------------------------------
    sign_ch = msg_in[0] >> (q-1)
    x_offset=int(cardinality/2)

    decomp_num = VN_DEGREE-1
    t = np.zeros(decomp_num, dtype=np.int32)
    rotate_en = 0
    for i in range(decomp_num):
        offset=ptr(i)
        if i == 0:
            y0 = mag_bits(msg_in[0])
            y0=mag_bits(y0)

            in_src_1 = mag_bits(msg_in[1])
            y1_sign = sign_bit(in_src_1)^sign_bit(msg_in[0])
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            pa, ba = lutram_addr_decode(y0, y1)
            t[i] = ib_lut[0][iter_id][layer_id][pa][ba]

            rotate_en = sign_ch
        elif i < (decomp_num-2):
            y0=mag_bits(t[i-1])
            sel = rotate_en^sign_bit(t[i-1])

            in_src_1 = mag_bits(msg_in[i+1])
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            pa, ba = lutram_addr_decode(y0, y1)
            t[i] = ib_lut[1][iter_id][layer_id][pa][ba]

            rotate_en = sel
        elif i == (decomp_num - 2): # to output the variable-to-check message
            y0 = mag_bits(t[i - 1])
            sel = rotate_en ^ sign_bit(t[i - 1])

            in_src_1 = msg_in[i+1]
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            pa, ba = lutram_addr_decode(y0, y1)
            t[i] = ib_lut[1][iter_id][layer_id][pa][ba]

            v2c_sign = sign_bit(t[i])^sel
            t[i] = mag_bits(t[i]) + (v2c_sign << (q-1)) # v2c
            rotate_en = sel
        elif i == (decomp_num-1):
            v2c_sign = sign_bit(t[i-1])
            y0_sign = v2c_sign^rotate_en # it is acually removable
            y0_mag = not_gate(bitwidth=q-1, val=mag_bits(t[i-1]))
            y0 = y0_mag
            sel = v2c_sign

            in_src_1 = msg_in[i+1]
            y1_sign = sel^sign_bit(in_src_1)
            y1 = mag_bits(in_src_1) + (y1_sign << (q-1))

            pa, ba = lutram_addr_decode(y0, y1)
            t[i] = ib_lut[2][iter_id][layer_id][pa][ba]

            t[i] = sign_mag_inv(signed_val=t[i], sel=sel, ctrl=1)
            #t[i] = sign_bit(t[i])^sel

            rotate_en = sel

        #print("t[%d]: %d" %(i, t[i]))

    return t

# -------------------------------------------------------------------------------------------------------------
## Predicated
def noAbIn_sim_compare_noAbIn_lutRam():
    ib_lut = VNU_LUT_construct()
    ch = [14, 15, 14, 13, 14, 12, 14, 14, 13]
    c2v0 = [4, 4, 11, 11, 4, 8, 11, 10, 9]
    c2v1 = [9, 13, 11, 13, 14, 12, 12, 11, 13]
    dnuIn0 = [14, 15, 15, 15, 15, 14, 15, 15, 15]
    dnuIn1 = [12, 12, 13, 12, 8, 9, 8, 6, 11]
    for i in range(9):
        msg_in = [ch[i], c2v0[i], c2v1[i], 0]
        layer_no_absIn_temp = ib_layer_no_absIn_sym_vnu(msg_in=msg_in)
        print(layer_no_absIn_temp)
        # -------------------------------------------------------------------------------------------------------------
        y0 = msg_in[0]
        y1 = mag_inv(msg_in[1], 0)
        y1_s = sign_bit(y1) ^ sign_bit(y0)
        y1 = mag_bits(y1) + (y1_s << (q - 1))
        pa, ba = lutram_addr_decode(y0, y1)
        t0 = ib_lut[0][pa][ba]

        y0 = t0
        y1 = mag_inv(msg_in[2], 0)
        y1_s = sign_bit(y1) ^ sign_bit(y0) ^ sign_bit(msg_in[0])
        y1 = mag_bits(y1) + (y1_s << (q - 1))
        pa, ba = lutram_addr_decode(y0, y1)
        t1 = ib_lut[1][pa][ba]
        t1_s = sign_bit(t1) ^ sign_bit(y0) ^ sign_bit(msg_in[0])
        t1 = mag_bits(t1) + (t1_s << (q - 1))
        print('[%d %d]' % (t0, t1))
        print("----------")
        # -------------------------------------------------------------------------------------------------------------

        offset = ptr(2)
        y0 = mag_bits(dnuIn0[i])
        # y0=not_gate(bitwidth=q-1, val=y0)
        y0_sign = sign_bit(dnuIn0[i])

        sel = 1 ^ y0_sign

        in_src_1 = mag_inv(signed_val=dnuIn1[i],
                           ctrl=0)  # to mimic the removal of signed~value conversion from output of CNU
        y1_sign = sel ^ sign_bit(in_src_1)
        y1 = mag_bits(in_src_1) + (y1_sign << (q - 1))
        t = layer_app_no_absIn_lut_out(iter=0, y0=y0, y1=y1, offset=offset)

        # t = sign_mag_inv(t, sel, 1)
        t = sign_bit(t) ^ sel
        # print(t)

## Predicated
def comprehensive_verification():
    for i in range(10):
        msg_in = [random.randint(0, 15), random.randint(0, 15), random.randint(0, 15), random.randint(0, 15)]
        flood_temp = ib_flood_sym_vnu(msg_in=msg_in)
        layer_temp = ib_layer_sym_vnu(msg_in=msg_in)
        layer_temp_cnuIn = ib_layer_eliminated_sym_vnu(msg_in=msg_in)
        layer_no_absIn_temp = ib_layer_no_absIn_sym_vnu(msg_in=msg_in)
        flood_v2c = flood_temp[1]
        layer_v2c = layer_temp[1]

        t = np.zeros(3, dtype=np.int32)
        offset = ptr(0)
        t[0] = lut_out(iter=0, y0=msg_in[0], y1=msg_in[1], offset=offset)
        # print("Without Symmetry: %d" %(t[0]))
        offset = ptr(1)
        t[1] = lut_out(iter=0, y0=t[0], y1=msg_in[2], offset=offset)
        # print("Without Symmetry: %d" %(t[1]))
        offset = ptr(2)
        t[2] = lut_out(iter=0, y0=t[1], y1=msg_in[3], offset=offset)
        # print("Without Symmetry: %d" %(t[2]))

        # print("actual_v2c:%d(\t%d\t)\tflood_v2c:%d(\t%d\t)\tlayer_v2c:%d(\t%d\t)" %(t[1], t[2], flood_v2c, flood_temp[2], layer_v2c, layer_temp[2]))
        if flood_v2c != t[1]:
            print("-----Sample_%d: V2Cs are not identical, i.e., %d != %d" % (i, flood_v2c, t[1]))
        # else:
        # print("V2Cs: %d == %d" %(flood_v2c, t[1]))

        if flood_temp[2] != t[2]:
            print("-----Sample_%d: APPs are not identical, i.e., %d != %d" % (i, flood_temp[2], t[2]))
        # else:
        # print("APPs: %d == %d" %(flood_temp[2], t[2]))

        if layer_v2c != t[1]:
            print("----------------------------(Layer)\tSample_%d: V2Cs are not identical, i.e., %d != %d" % (
                i, layer_v2c, t[1]))
        # else:
        # print("(Layer)\tV2Cs: %d == %d" %(layer_v2c, t[1]))

        if layer_temp[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" % (
                i, layer_temp[2], t[2]))
        # else:
        # print("(Layer)\tAPPs: %d == %d" %(layer_temp[2], t[2]))

        if layer_temp_cnuIn[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" % (
                i, layer_temp_cnuIn[2], t[2]))
        # else:
        # print("(Layer)\tAPPs: %d == %d" %(layer_temp_cnuIn[2], t[2]))

        if layer_no_absIn_temp[2] != t[2]:
            print("----------------------------(Layer)\tSample_%d: APPs are not identical, i.e., %d != %d" % (
                i, layer_no_absIn_temp[2], t[2]))
        # else:
        # print("(Layer)\tAPPs: %d == %d" %(layer_no_absIn_temp[2], t[2]))

        # Other verification
        flood_v2c_cnuIn = mag_inv(flood_temp[1], 0)
        layer_v2c_cnuIn = mag_inv(layer_temp[1], 0)
        layer_temp_v2c_cnuIn = layer_temp_cnuIn[1]

        if ~(flood_v2c_cnuIn == layer_v2c_cnuIn == layer_temp_v2c_cnuIn):
            print("------------------------(Wrong)\tcnuIn:(%d\t%d\t%d)" % (
                flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))
        # else:
        # print("cnuIn:(%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))

        # verification (19.June.2021) where all converstion at I/O of both CNUs and VNUs are aimed to be removed
        layer_no_absIn_v2c = layer_no_absIn_temp[1]

        if ~(flood_v2c_cnuIn == layer_v2c_cnuIn == layer_temp_v2c_cnuIn == layer_no_absIn_v2c):
            print("--(Wrong)\tV2C:(%d\t%d\t%d\t%d)" % (
                flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn, layer_no_absIn_v2c))
        # else:
        # print("cnuIn:(%d\t%d\t%d)" %(flood_v2c_cnuIn, layer_v2c_cnuIn, layer_temp_v2c_cnuIn))
        # print("flood_temp_v2c: ", flood_v2c_cnuIn, "layer_no_absIn_v2c: ", layer_no_absIn_v2c)

def ib_no_absIn_quan(signed_val_vec, vec_num):
    temp = np.zeros(vec_num, dtype=np.int32)
    for i in range(vec_num):
        temp[i] = mag_inv(signed_val=signed_val_vec[i], ctrl=0)
    return temp

def main():
    exportVNU_LUT_COE_Iter0_9()
    print("Test")

if __name__ == "__main__":
    #main()

    ib_lut = VNU_LUT_construct()
    # =================================================================================================================
    # Verification of removal of Sign-Extension logics
    # =================================================================================================================
    #noAbIn_sim_compare_noAbIn_lutRam()
    #comprehensive_verification()
    for iter_id in range(Iter_max):
        for layer_id in range(layer_num):
            for ch_msg in range(0, 16):
                for c2v_0 in range(0, 16):
                    for c2v_1 in range(0, 16):
                        for c2v_2 in range(0, 16):
                            msg_in = [ch_msg, c2v_0, c2v_1, c2v_2]
                            flood_temp = ib_flood_sym_vnu(iter_id=iter_id, layer_id=layer_id, msg_in=msg_in)
                            flood_v2c = mag_inv(signed_val=flood_temp[1], ctrl=0)  # comparison based on magnitude (to transform into absolute value) instead of signed integer
                            flood_hard = flood_temp[2]

                            msg_in_no_absIn = ib_no_absIn_quan(signed_val_vec=msg_in, vec_num=len(msg_in))
                            layer_no_absIn_lutram = ib_layer_no_absIn_sym_lutram(iter_id=iter_id, layer_id=layer_id, msg_in=msg_in_no_absIn)
                            layer_no_absIn_temp = ib_layer_no_absIn_sym_vnu(iter_id=iter_id, layer_id=layer_id, msg_in=msg_in_no_absIn)

                            layer_no_absIn_lutram_v2c = layer_no_absIn_lutram[1]
                            layer_no_absIn_lutram_hard = layer_no_absIn_lutram[2]
                            layer_no_absIn_v2c = layer_no_absIn_temp[1]
                            layer_no_absIn_hard = layer_no_absIn_temp[2]

                            if flood_v2c != layer_no_absIn_lutram_v2c:
                            	print('Iter_%d, Layer_%d (w.r.t. lutram) =>' % (iter_id, layer_id), format(c2v_2, '04b'), format(c2v_1, '04b'), format(c2v_0, '04b'), format(ch_msg, '04b'), '\t->\t%d and %d' % (flood_v2c, layer_no_absIn_lutram_v2c))

                            if flood_v2c != layer_no_absIn_v2c:
                                print('Iter_%d, Layer_%d (w.r.t. sim) => ' % (iter_id, layer_id), format(c2v_2, '04b'), format(c2v_1, '04b'), format(c2v_0, '04b'), format(ch_msg, '04b'), '\t->\t%d and %d' % (flood_v2c, layer_no_absIn_v2c))

                            if flood_hard != layer_no_absIn_lutram_hard:
                                print('Iter_%d, Layer_%d => (Hard-Decision)\t' % (iter_id, layer_id), format(c2v_2, '04b'), format(c2v_1, '04b'), format(c2v_0, '04b'), format(ch_msg, '04b'), '\t->\t%d and %d' % (flood_hard, layer_no_absIn_lutram_hard))

                            if flood_hard != layer_no_absIn_hard:
                                print('Iter_%d, Layer_%d => (Hard-Decision)\t' % (iter_id, layer_id), format(c2v_2, '04b'), format(c2v_1, '04b'), format(c2v_0, '04b'), format(ch_msg, '04b'), '\t->\t%d and %d' % (flood_hard, layer_no_absIn_hard))

    # =================================================================================================================
    # Base-Delta Compression and Decompression
    # =================================================================================================================
    #ib_lut = VNU_LUT_construct()
    #bdi.bdi_eval(decompose_num=M+1, ib_lut=ib_lut, Iter_max=Iter_max, layer_num=layer_num, quant_bits=q, interleave_bank_num=interleave_bank_num)
#        delta5 = np.zeros((8, 16), dtype=np.int32)
# bash -> ./ls > $(date "+%Y.%m.%d-%H.%M.%S").ver
