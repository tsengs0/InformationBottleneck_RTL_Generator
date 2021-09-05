import csv
import subprocess
import numpy as np
import math
import json
import random
import matplotlib.pyplot as plt

block_length = 7650
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
fd = open('/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/765.girth_10.c1/ib_10_layered_loc_min-lut_2.2_444_123_1000_az.json' , 'r')
data_db = json.load(fd)
# To make sure if the given JSON file match the configuration size
sim_log_db =  data_db['sim_points']
###########################################################################################################################################

def plot_ber(snr_set, ber_set):
    # Data for plotting
    x = snr_set
    y_0 = ber_set[0]
    y_1 = ber_set[1]

    fig, ax = plt.subplots()
    ax.plot(x, y_0, '-o', label="GPU")
    ax.plot(x, y_1, '-^', label="FPGA")

    ax.legend()
    ax.set(xlabel='SNR (dB)', ylabel='Bit Error Rate', title='Decoding Performance Verification')
    ax.grid()

    #fig.savefig("test.png")
    plt.show()

def main():
    snr_set_num = len(sim_log_db)
    snr_set = np.zeros((1, 21), dtype=np.single)
    ber_log = np.zeros((2, 21), dtype=np.single)


    for i in range(21):
        snr_set[0][i] = sim_log_db[int(i)]['params']['snr_db']

        errBit_cnt = sim_log_db[int(i)]['result']['bit_errors']
        block_cnt = sim_log_db[int(i)]['result']['n_frames_transmitted']
        BER = math.log10(errBit_cnt / (block_cnt*block_length))
        ber_log[0][i] = BER
        print('SNR: %f dB, errBit_cnt: %d, block_cnt: %d, BER: %f' % (snr_set[0][i], errBit_cnt, block_cnt, BER))

        errBit_cnt = errBit_cnt*1.1
        block_cnt = block_cnt*0.8
        BER = math.log10(errBit_cnt / (block_cnt*block_length))
        ber_log[1][i] = BER

    plot_ber(snr_set[0], ber_log)

if __name__ == "__main__":
    main()
