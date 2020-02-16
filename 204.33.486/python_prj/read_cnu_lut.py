import h5py
import csv
import subprocess

q=4 # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE-2
cardinality = pow(2, q)
Iter_max = 50

file_204_102='ib_regular_444_1.300_50_ib_123_10_5_first_none_ib_ib.h5'
file_lut_csv='lut_' # lut_Iter50_Func3.csv
file_lut_coe='lut_' # lut_Iter50_Func3.csv
file_lut_rtl='lut_cnu_'
cmd_mkdir='mkdir '
cmd_move='mv '
f=h5py.File(file_204_102, 'r')
# Show all keys
list(f.keys())
dset1=f['config']
dset2=f['dde_results']

# There are six members in the Group f['dde_results']
print(dset2.keys())

check_node_lut=dset2['check_node_vector']
print(check_node_lut)
print("\n\n")

# Get pointer of target LUT
def ptr(i, m):
    offset = i*M*cardinality*cardinality+m*cardinality*cardinality
    return offset

# Get result of designated LUT
def lut_out(y0, y1, offset):
    t=check_node_lut[offset+y0*cardinality+y1]
    return t

# Export every LUT to individual CSV file
def exportCNU_LUT_CSV():
    csv_folder_filename='CSV_LUT'
    subprocess.call(cmd_mkdir+csv_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename=cmd_mkdir+'Iter_'+str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move+'Iter_'+str(i)+' '+csv_folder_filename+'/', shell=True)
        for m in range(M):
            create_csv_filename=file_lut_csv + 'Iter' + str(i) + '_Func' + str(m) + '.csv'
            csv_file = open(create_csv_filename, mode='w')
            csv_writer = csv.writer(csv_file, delimiter=',')
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    csv_writer.writerow([int(y0), int(y1), int(t)])
            subprocess.call(cmd_move+create_csv_filename+' '+csv_folder_filename+'/Iter_'+str(i)+'/', shell=True)

# Export every LUT to individual Memory Coefficient file for Xilinx Vivado to initially write the data into BlockRAM
def exportCNU_LUT_COE():
    coe_folder_filename='COE_LUT'
    subprocess.call(cmd_mkdir+coe_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename=cmd_mkdir+'Iter_'+str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move+'Iter_'+str(i)+' '+coe_folder_filename+'/', shell=True)

        # Generate COE file for each iteration, where one COE file conatains all 1024 entries of f^{Iter}_m. m in {0, 1, 2, 3}
        create_coe_filename = file_lut_coe + 'Iter' + str(i) + '_Func0_3.coe'
        coe_file = open(create_coe_filename, "w")
        coe_file.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        # Write down output value of each corresponding entry
        for m in range(M):
            t_c=''
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    if y0 == cardinality-1 and y1 == cardinality-1:
                        if m == M-1:
                            coe_file.write(str(hex(int(t))[2:])+ ";")
                        else:
                            coe_file.write(str(hex(int(t))[2:])+ ", \n")
                    else:
                        coe_file.write(str(hex(int(t))[2:]))
        subprocess.call(cmd_move+create_coe_filename+' '+coe_folder_filename+'/Iter_'+str(i)+'/', shell=True)

# Demonstrate output of all LUTs with given entry address
def showCNU_LUT():
    for i in range(50):
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
    fp.write("{`QUAN_SIZE'd"+str(int(y0))+", "+"`QUAN_SIZE'd"+str(int(y1))+"}: "+"t_c[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd"+str(int(t))+"\n")

# Export every LUT to individual Verilog file
def gen_CNU_LUT_V():
    verilog_folder_filename = 'Verilog_LUT'
    subprocess.call(cmd_mkdir + verilog_folder_filename, shell=True)
    for i in range(Iter_max):
        create_Iter_filename=cmd_mkdir+'Iter_'+str(i)
        subprocess.call(create_Iter_filename, shell=True)
        subprocess.call(cmd_move+'Iter_'+str(i)+' '+verilog_folder_filename+'/', shell=True)
        for m in range(M):
            create_verilog_filename=file_lut_rtl + 'Iter' + str(i) + '_Func' + str(m) + '.v'
            rtl_file = open(create_verilog_filename, "w")
            offset = ptr(i, m)
            for y0 in range(cardinality):
                for y1 in range(cardinality):
                    t = lut_out(y0, y1, offset)
                    gen_verilog_cnu_lut_entry(rtl_file, str(int(y0)), str(' '+int(y1)), str(' '+int(t)))
            subprocess.call(cmd_move+create_verilog_filename+' '+verilog_folder_filename+'/Iter_'+str(i)+'/', shell=True)
            rtl_file.close()

exportCNU_LUT_COE()
#exportCNU_LUT_CSV()
#gen_CNU_LUT_V()
