#this was copied from Learn Python the Hard way exercise.
from sys import argv
from os.path import exists
import csv

#this is the main function to convert hexadecimal to decimal
def hex2dec (hex):
    result_dec = int(hex, 0)
    return result_dec

def split_symbols(symbols):
	return [char for char in symbols]

#this to accept parameter from command-line
script, from_file = argv

#this to make sure the output generate as a new file with _1
to_file = from_file + ".csv"

with open(from_file) as in_file:
    lines = in_file.read().splitlines()

for i in lines:
    #converted = str(hex2dec(i))
    line_symbols = split_symbols(i)
    line_symbols = line_symbols[::-1] # reverse the order of symbole from [Pc-1:0] to [0:Pc-1]

    out_file = open(to_file, 'a')
    with out_file:
    	write = csv.writer(out_file)
    	write.writerow(line_symbols)

print "Conversion of " + from_file + " is done."
