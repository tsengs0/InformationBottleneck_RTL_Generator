import glob
from openpyxl import Workbook

rx_file_format_0 = ".txt"
rx_file_format_1 = ".xlsx"

rx_filename_0 = glob.glob("./Rx/*"+rx_file_format_0)
rx_filename_1 = ['']*len(rx_filename_0)
print(len(rx_filename_0))
print(len(rx_filename_1))

for i in range(len(rx_filename_0)):
    wb = Workbook()
    ws = wb.active
    rx_filename_1[i] = rx_filename_0[i].replace(rx_file_format_0, rx_file_format_1)
    f = open(rx_filename_0[i], 'r+', encoding='cp932')
    data = f.readlines()
    spaces = ""
    for j in range(len(data)):
        row = data[j].split("\t")
        ws.append(row)
    wb.save(rx_filename_1[i])