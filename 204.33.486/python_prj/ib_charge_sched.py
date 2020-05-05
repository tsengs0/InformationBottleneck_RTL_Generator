import csv
import subprocess

# Theory specification
q = 4  # 4-bit quantisation
VN_DEGREE = 3
CN_DEGREE = 6
M_VN = VN_DEGREE+1-2
M_CN = CN_DEGREE-2
cardinality = pow(2, q)
Iter_max = 50

# Hardware specification
ib_ram_freq = 200 # 200 MHz
ib_rom_freq = 360 # 360 MHz
IB_ROM_ch_num = 2 # 2 read ports for each BRAM-based IB ROM
ROM_RAM_ratio = ib_rom_freq/ib_ram_freq # the clock rate of IB-ROM to clock rate of IB RAM ratio
charge_core_num = M_CN/IB_ROM_ch_num # the number of 2-LUTs which are allowed to be charged simultaneously

#def freq_search(util, deadline, wcet, freq_ref):

exe_time = (q+1)+M_VN+q
capacity_unit = charge_core_num*ROM_RAM_ratio
charge_capacity = capacity_unit*(exe_time+M_CN-1)
rel_dline = [0]*M_CN
# Static scheduling analysis
util=0.0
temp=0.0
ib_rom_freq = 400*pow(10,6)
wcet=(exe_time / ib_rom_freq) * pow(10, 9)
for m in range(M_CN):
    rel_dline[m] = (exe_time+m)*capacity_unit
    util=util+(exe_time/rel_dline[m])

    rel_dline[m]=(rel_dline[m]/ib_rom_freq)*pow(10,9)
    temp=temp+(exe_time/ib_rom_freq)*pow(10,9)
   # print(str(wcet), " -> constraint:", rel_dline[m], "-", temp, "=", rel_dline[m]-temp)
print("Util:", util)
capacity = charge_capacity
priority = [0, 1, 2, 3]
assigned_ram = [0]*M_CN
rem_workload = [exe_time]*M_CN
consume_unit = 1/capacity_unit
print(rem_workload, consume_unit, exe_time)
used_core = 0
t=0
cnt=0
while t <= (exe_time+M_CN-1):
    print(cnt, ":", assigned_ram, "    consumed:", rem_workload)
    for core in range(M_CN):
        if used_core < IB_ROM_ch_num:
            if assigned_ram[core] == 0 and rem_workload[core] != 0:
                assigned_ram[core]=1
                used_core=used_core+1
        if assigned_ram[core] == 1:
            rem_workload[core] = rem_workload[core]-1
            if rem_workload[core] == 0:
                used_core = used_core-1
                assigned_ram[core] = 0
    t=t+(1/ROM_RAM_ratio)
    cnt=cnt+1
#if util <= 1.0:
#    optimal_freq = freq_search(util, rel_dline, exe_time, ib_ram_freq

