import subprocess
import math

def circularRotate(array_list, shift_num):
    return array_list[shift_num:]+array_list[:shift_num]

bank_shift=[0, 1, 2, 3 ,4 ,5, 6, 7]
for i in range(8):
    print(bank_shift)
    for j in range(18):
        if j % 8 != 0 or j == 0:
            print("B_", bank_shift[j%8], " -> ", end='')
        else:
            print("\nB_", bank_shift[j%8], " -> ", end='')
    print("\n")
    bank_shift=circularRotate(bank_shift, 2)



