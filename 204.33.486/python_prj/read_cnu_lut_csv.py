import h5py
import csv

q=4 # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE-2
cardinality = pow(2, q)

file_204_102='ib_regular_444_1.300_50_ib_123_10_5_first_none_ib_ib.h5'
file_lut_csv='lut_'

f=h5py.File(file_204_102, 'r')
# Show all keys
list(f.keys())
dset1=f['config']
dset2=f['dde_results']

# There are six members in the Group f['dde_results']
#print(dset2.keys())

check_node_lut=dset2['check_node_vector']
#print(check_node_lut)
#print("\n\n")

# Get pointer of target LUT
def ptr(i, m):
    offset = i*M*cardinality*cardinality+m*cardinality*cardinality
    return offset

# Get result of designated LUT
def lut_out(y0, y1, offset):
    t=check_node_lut[offset+y0*cardinality+y1]
    return t

csv_file = open('lut_in2.csv', mode='w')
csv_writer = csv.writer(csv_file, delimiter=',')
offset = ptr(0, 0)
for y0 in range(cardinality):
	for y1 in range(cardinality):
		t = lut_out(y0, y1, offset)
		csv_writer.writerow([y0, y1, t])
		print(y0, ",", y1, ",", t)


#with open('test.csv', mode='w') as csv_file:
#    csv_writer = csv.writer(csv_file, delimiter=',')
#    csv_writer.writerow([1,3,4])
