import numpy as np
import math

def mag_bits(signed_val, quant_bits):
    return (signed_val & ~(1 << (quant_bits-1)))
def lutram_addr_decode(y0, y1, quant_bits):
    page_addr = (mag_bits(y0, quant_bits) << (quant_bits - 1)) + (y1 >> 1)
    bank_addr = y1 % 2

    return page_addr, bank_addr
##----------------------------------------------------------------------------------=##
#Base-Delta-Immediate Compressein
##----------------------------------------------------------------------------------=##
def delta_mem_map(deltaDepth, deltaAddr, deltaVal, interleave_bank_num):
    delta_rom_addr = []
    delta_rom_val = []
    index=0
    page_num=0
    while(index < deltaDepth):
        if(index < deltaDepth-1):
            if((deltaAddr[index+1]-deltaAddr[index]) == 1): # two adjacent delta values are not zero
                delta_rom_addr = np.append(delta_rom_addr, int(deltaAddr[index] >> math.ceil(math.log2(interleave_bank_num))))
                val_temp = str(deltaVal[index]) + "," + str(deltaVal[index+1])
                delta_rom_val = np.append(delta_rom_val, val_temp)
                index=index+interleave_bank_num

            elif ((deltaAddr[index + 1] - deltaAddr[index]) > 1):  # one out of two adjacent delta values is zero
                delta_rom_addr = np.append(delta_rom_addr, int(deltaAddr[index] >> math.ceil(math.log2(interleave_bank_num))))

                if(deltaAddr[index] % 2 == 0):
                    val_temp = str(deltaVal[index]) + "," + str(0)
                else:
                    val_temp = str(0) + "," + str(deltaVal[index])
                delta_rom_val = np.append(delta_rom_val, val_temp)

                index=index+1

        elif (index >= deltaDepth-1):  # one out of two adjacent delta values is zero
            delta_rom_addr = np.append(delta_rom_addr, int(deltaAddr[index] >> math.ceil(math.log2(interleave_bank_num))))

            if(deltaAddr[index] % 2 == 0):
                val_temp = str(deltaVal[index]) + "," + str(0)
            else:
                val_temp = str(0) + "," + str(deltaVal[index])
            delta_rom_val = np.append(delta_rom_val, val_temp)

            index=index+1
        page_num = page_num + 1

    return delta_rom_addr, delta_rom_val, page_num

def bdi_eval(decompose_num, ib_lut, Iter_max, layer_num, quant_bits, interleave_bank_num):
    # Base and Delta (including address and value) arrays
    base = np.zeros((8, 16), dtype=np.int32)
    base_temp = np.zeros((8, 16), dtype=np.int32)
    delta_temp = np.zeros((8, 16), dtype=np.int32)
    deltaDepth = [0] * Iter_max
    compressionRate = [] # for debugging only
    spaceSaving = [] # for debugging only
    originSpaceSize = (((2**(2*quant_bits))/2)/interleave_bank_num)*(quant_bits*interleave_bank_num)*(Iter_max*layer_num) # for debugging only
    reducedRefreshCycle = [0]*(Iter_max-1) # for debugging only

    for m in range(decompose_num):
        # Create the BDI file for each 2-LUT
        bdi_filename = 'vn_bdi_m' + str(m) + '.txt'
        bdi_depth_filename0 = 'vn_bdi_depth_m' + str(m) + '.txt'
        bdi_depth_filename1 = 'vn_bdi_depth_m' + str(m) + '.csv'
        bdi_rom_filename = 'vn_bdi_rom_m' + str(m) + '.mem'
        bdi_file = open(bdi_filename, "w")
        bdi_depth_file = open(bdi_depth_filename0, "w")
        bdi_depth_csv = open(bdi_depth_filename1, "w")
        bdi_rom_file = open(bdi_rom_filename, "w")
        pageCnt = [] # for debugging only
        pageVal = [] # for debugging only
        pageBitwidth = [] # for debugging only
        pageAddrBitwidth = [] # for debugging only

        bdi_depth_csv.write('VNU_M' + str(m) + '_Iteration, #NonZero_Delta, #DeltaArrayPage(reduced refresh cycle)\n')
        for iter in range(Iter_max):
            for layer_id in range(layer_num):
                iter_layer = (iter*layer_num)+layer_id
                for i in range(8):
                    for j in range(16):
                        page_addr, bank_addr = lutram_addr_decode(i, j, quant_bits)
                        t = int(ib_lut[m][iter][layer_id][page_addr][bank_addr])

                        # Loading the Base values
                        if (iter == 0):
                            base[i][j] = t
                            base_temp[i][j] = t
                        else:
                            delta_temp[i][j] = t - base_temp[i][j];
                            base_temp[i][j] = t

                # Counting the number of non-zero delta values
                if (iter != 0):
                    deltaAddr = []
                    deltaVal = []
                    deltaDepth[iter] = np.count_nonzero(delta_temp)
                    deltaAddr = np.flatnonzero(delta_temp)
                    deltaVal = delta_temp[np.nonzero(delta_temp)]
                    bdi_file.write("Delta (Iter_" + str(iter) + ") -> ")
                    for depth in range(deltaDepth[iter]):
                        bdi_file.write(str(deltaVal[depth]) + "(" + str(deltaAddr[depth]) + "), ")
                    bdi_file.write("\n")

                    # Generating Delta-Addr and Delta-Val ROMs preload files
                    delta_rom_addr, delta_rom_val, page_num = delta_mem_map(deltaDepth[iter], deltaAddr, deltaVal, interleave_bank_num=interleave_bank_num)
                    for pageIndex in range(page_num):
                        bdi_rom_file.write(
                            str(int(delta_rom_addr[pageIndex])) + " -> " + str(delta_rom_val[pageIndex]) + "\n")
                    bdi_rom_file.write("Page Num:" + str(page_num) + "\n\n")
                    bdi_depth_file.write("Nonzero Delta Count (Iter_" + str(iter) + ") -> " + str(
                        deltaDepth[iter]) + ",\t\tPage Size: " + str(page_num) + "\n")
                    bdi_depth_csv.write(str(iter) + ',' + str(deltaDepth[iter]) + "," + str(page_num) + "\n")
                    reducedRefreshCycle[iter - 1] = page_num
                    pageCnt = np.append(pageCnt, page_num)
                    pageVal = np.append(pageVal, deltaVal)
                    if (len(pageVal) == 0):
                        deltaMax = 1
                        deltaMin = 1
                    else:
                        deltaMax = max(pageVal)
                        deltaMin = min(pageVal)

                    if (deltaMax < 0 and deltaMin < 0):
                        deltaMax = abs(deltaMax)
                        deltaMin = abs(deltaMin)
                        deltaBitwidth = math.ceil(math.log2(deltaMin)) + 1
                    elif (deltaMax > 0 and deltaMin < 0):
                        deltaMin = abs(deltaMin)
                        if (deltaMin > deltaMax):
                            deltaBitwidth = math.ceil(math.log2(deltaMin)) + 1
                        else:
                            deltaBitwidth = math.ceil(math.log2(deltaMax))
                    else:
                        deltaBitwidth = math.ceil(math.log2(deltaMax))

                    pageBitwidth = np.append(pageBitwidth, deltaBitwidth)

                    # Calculating the bitwidth of the Delta-Address ROM
                    if (len(delta_rom_addr) == 0):
                        pageAddrBitwidthMax = 1
                    else:
                        pageAddrBitwidthMax = max(delta_rom_addr)
                        if (pageAddrBitwidthMax == 0):
                            pageAddrBitwidthMax = 1
                        else:
                            pageAddrBitwidthMax = math.ceil(math.log2(pageAddrBitwidthMax))

                    pageAddrBitwidth = np.append(pageAddrBitwidth, pageAddrBitwidthMax)

        # Evaluating the maximum, minimum and average refresh cycles
        page_max = int(np.max(reducedRefreshCycle))
        page_min = int(np.min(reducedRefreshCycle))
        page_mean = int(np.mean(reducedRefreshCycle))
        bdi_depth_csv.write('Min_reducedRefreshCycle,Max_reducedRefreshCycle,Mean_reducedRefreshCycle\n')
        bdi_depth_csv.write(str(page_min)+','+str(page_max)+','+str(page_mean)+'\n')
        bdi_depth_csv.close()

        bdi_file.close()
        bdi_depth_file.close()
        bdi_rom_file.close()

        # For debugging only
        deltaPageBitwidth = max(pageBitwidth)*interleave_bank_num
        deltaPageAddrBitwidth = max(pageAddrBitwidth)
        # Space of Base + Space of all non-zero Deltas across (Iter_max-1) iterations + Space of EOFs + Space of EOFs + Space of Address ROM
        compressSpaceSize = (originSpaceSize/(Iter_max*layer_num)) + sum(pageCnt)*deltaPageBitwidth + ((Iter_max*layer_num)-1)*deltaPageBitwidth  + deltaPageAddrBitwidth*sum(pageCnt)
        compressionRate = np.append(compressionRate, originSpaceSize/compressSpaceSize)
        spaceSaving = np.append(spaceSaving, 1 - (compressSpaceSize/originSpaceSize))
    print("Compression Rate: ", compressionRate)
    print("Space Saving (%): ", spaceSaving*100)

def bdi_eval_debug(decompose_num, ib_lut, Iter_max, quant_bits):
    for m in range(decompose_num):
        # Base and Delta (including address and value) arrays
        base0 = np.zeros((8, 16), dtype=np.int32)
        delta1 = np.zeros((8, 16), dtype=np.int32)
        base2 = np.zeros((8, 16), dtype=np.int32)
        delta3 = np.zeros((8, 16), dtype=np.int32)
        base4 = np.zeros((8, 16), dtype=np.int32)
        delta5 = np.zeros((8, 16), dtype=np.int32)

        for iter in range(Iter_max):
            for layer_id in range(layer_num):
                for i in range(8):
                    for j in range(16):
                        page_addr, bank_addr = lutram_addr_decode(i, j, quant_bits)
                        t = int(ib_lut[m][iter][layer_id][page_addr][bank_addr])

                        # Loading the Base values
                        if (iter == 0):
                            base0[i][j] = t
                        elif (iter == 1):
                            delta1[i][j] = t - base0[i][j]
                        elif (iter == 2):
                            # base2[i][j] = t
                            base2[i][j] = t - base0[i][j]
                        elif (iter == 3):
                            delta3[i][j] = t - base0[i][j]
                        elif (iter == 4):
                            # base4[i][j] = t
                            base4[i][j] = t - base0[i][j]
                        elif (iter == 5):
                            delta5[i][j] = t - base0[i][j]

        print(base0)
        print("\n")
        print(delta1)
        print(np.count_nonzero(delta1))
        print("\n-----------------------------------------------\n")
        print(base2)
        print(np.count_nonzero(base2))
        print("\n")
        print(delta3)
        print(np.count_nonzero(delta3))
        print("\n-----------------------------------------------\n")
        print(base4)
        print(np.count_nonzero(base4))
        print("\n")
        print(delta5)
        print(np.count_nonzero(delta5))