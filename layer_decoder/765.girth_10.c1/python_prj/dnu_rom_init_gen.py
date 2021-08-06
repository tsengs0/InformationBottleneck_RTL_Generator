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
    coe_folder_filename = 'COE_BRAM32.DNU'
    subprocess.call(cmd_mkdir + coe_folder_filename, shell=True)
    for i in range(1):
        filename = 'Iter_' + str(IB_ROM_MAX_ITER * i) + '_' + str((IB_ROM_MAX_ITER * i) + 10 - 1)
        create_Iter_filename = cmd_mkdir + filename
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move + filename + ' ' + coe_folder_filename + '/', shell=True)

        m = M
        create_coe_filename = file_lut_coe + 'Iter' + str(IB_ROM_MAX_ITER * i) + '_' + str((IB_ROM_MAX_ITER * i) + 10 - 1) + '_Func' + str(m) + '.coe'
        coe_file = open(create_coe_filename, "w")
        coe_file.write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")

        line = 0
        cnt = 0
        offset = ptr(m)
        for iter in range(IB_ROM_MAX_ITER * i, ( IB_ROM_MAX_ITER* i) + 10):
            for y0 in range(int(cardinality / 2)):  # only half symmetry
                for y1 in range(int(cardinality)):
                    t = int(layer_app_no_absIn_lut_out(iter=iter, y0=y0, y1=y1, offset=offset))
                    t = sign_bit(t)
                    #print(t)

                    if y0 == (cardinality / 2) - 1 and y1 == cardinality - 1 and line == (depth_ib_func / interleave_bank_num) *  IB_ROM_MAX_ITER - 1:
                        coe_file.write(str(format(t, '01b')) + ";")
                    else:
                        if (cnt == interleave_bank_num - 1):
                            coe_file.write(str(format(t, '01b')) + ", \n")
                            line = line + 1
                            cnt = 0
                        else:
                            coe_file.write(str(format(t, '01b')))
                            cnt = cnt + 1

        subprocess.call(cmd_move + create_coe_filename + ' ' + coe_folder_filename + '/' + filename + '/', shell=True)
        coe_file.close()
###########################################################################################################################################
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
###########################################################################################################################################
def main():
    exportVNU_LUT_COE_Iter0_9()

if __name__ == "__main__":
    main()
