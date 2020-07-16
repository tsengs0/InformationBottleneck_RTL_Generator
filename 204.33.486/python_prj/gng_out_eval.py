import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
import math

gng_out_float_filename = ['gng_float_data_out.csv', 'gng_float_data_out.snr_4.csv']
gng_out_filename = ['gng_data_out.sign.txt', 'gng_data_out.sign.snr_4.txt']
x0_awgn_filename = ['x0_awgn.txt', 'x0_awgn.snr_4.txt']
x0_sw_awgn_filename = ['sw_awgn.snr_4.txt']
x0_gauss_pdf_filename = ['x0_gauss_pdf.txt', 'x0_gauss_pdf.snr_4.txt']
x0_ib_filename = [
	'sw_ib_cluster_map.txt',
	'hw_behav_ib_cluster_map.txt', # not used any more
	'hw_impl_func_ib_cluster_map.txt', # not used any more
	'hw_impl_timing_ib_cluster_map.txt' # not used any more
]
	
x0_ib_dist_filename = [
	'sw_ch_msg_dist.txt',
	'hw_behav_ch_msg_dist.txt',
	'hw_impl_funct_ch_msg_dist.txt',
	'hw_impl_timing_ch_msg_dist.txt'
]

## The testbench log files from Symbol Generator where a GNG, FPU and IB-Cluster are integrated into one module
x0_symbol_gen_filename = [
	"/home/s1820419/LDPC_MinorResearch/Encoder/AWGN_Gen/gng/trunk/icdf/icdf.sim/symbol_gen_sim/behav/xsim/hw_symbol_gen_out.txt",
	"/home/s1820419/LDPC_MinorResearch/Encoder/AWGN_Gen/gng/trunk/icdf/icdf.sim/symbol_gen_sim/impl/func/xsim/hw_symbol_gen_out.txt",
	"/home/s1820419/LDPC_MinorResearch/Encoder/AWGN_Gen/gng/trunk/icdf/icdf.sim/symbol_gen_sim/impl/timing/xsim/hw_symbol_gen_out.txt"
]

ib_boundaries = [-1.74, -1.293, -0.987, -0.744, -0.537, -0.348, -0.171, 0.0, 0.171, 0.348, 0.537, 0.744, 0.987, 1.293, 1.74]
ib_mag = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
ib_level = len(ib_mag)
ib_boundary_num = len(ib_boundaries)

mu_offset = 0.0
sigma = 1.0
snr_eval = 8
fig_filename = 'awgn_mu_' + 'snr_' + str(snr_eval) + '.png'
fig_ch_msg_dist_filename =  'ch_msg_dist.' + 'snr_' + str(snr_eval) + '.png'
symbol_generator_latency = 24 # 24 pipeline stage for the underlying symbol gnerator, 
			      # thus the first channel message will be generated 24 clock cycle right after the startup timing
#test_sample_num = 625000 - symbol_generator_latency
test_sample_num = 20000

def load_file(filename):
	fd = open(filename, 'r')
	Lines = fd.readlines()
	x0 = np.array([], dtype=np.float32)

	# Strips the newline character 
	#for line in range(999985):#Lines: 
	for line in range(test_sample_num):#Lines: 
		x0_line = float(Lines[line].strip())
		x0 = np.append(x0, x0_line) 

	fd.close()
	x0.sort()
	return x0

# y = mu + sigma*N with returning sorted vector of AWGN samples
def convert_awgn(x_filename, x_awgn_filename, mean, std_dev):
	# Using readlines() 
	file1 = open(x_filename, 'r') 
	fd = open(x_awgn_filename, 'w')
	Lines = file1.readlines() 
	x0 = np.array([], dtype=np.float32)

	# Strips the newline character 
	#for line in Lines: 
	#for line in range(999985):#Lines: 
	for line in range(test_sample_num):#Lines: 
		x0_line =  mean + std_dev * (float(Lines[line].strip()) / 2**11)
		x0 = np.append(x0, x0_line) 
		fd.write(str(x0_line)+"\n")

	file1.close()
	fd.close()

	x0.sort()
	return x0

def gauss_pdf(x0, filename, mean, std_dev):
	fd = open(filename, 'w')
	pdf_x0 = [0.0] * len(x0)
	for i in range(len(x0)):
		temp = norm.pdf(x0[i], mean, std_dev) 
		fd.write(str(temp) + "\n")
		pdf_x0[i] = temp

	fd.close();
	return pdf_x0

def std_dev_cal(EbNodB):
	EbNo=10.0**(EbNodB/10.0)
	noise_var = 1 / (2*EbNo) # sigma**2
	noise_std = math.sqrt(noise_var) #1/sqrt(2*EbNo)
	return noise_std

def gauss_dist_show(x0, y0):
	# Fit a normal distribution to the data:
	#mu, std = norm.fit(data)

	# Plot the true AWGN
	x = np.linspace(min(x0), max(x0), len(x0))
	
	# Theoretical PDF 0
	data0 = norm.rvs(0.0, 1.0, size=len(x0))
	data0 = data0 * std_dev_cal(0.1)
	data0.sort()
	p0 = norm.pdf(data0, mu_offset, std_dev_cal(0.1))
	plt.plot(data0, p0 , color='r', label='Theoretical SNR=0.1dB')
	
	# Theoretical PDF 1
	data1 = norm.rvs(0.0, 1.0, size=len(x0))
	data1 = data1 * std_dev_cal(4)
	data1.sort()
	p1 = norm.pdf(data1, mu_offset, std_dev_cal(4))
	plt.plot(data1, p1 , color='g', label='Theoretical SNR=4dB')
	
	# Plot the PDF.
	min0 = np.min(p0)
	min1 = np.min(p1)
	min2 = np.min(y0)
	max0 = np.max(p0)
	max1 = np.max(p1)
	max2 = np.max(y0)
	min_all = np.min([min0, min1, min2])
	max_all = np.max([max0, max1, max2])
	plt.ylim(min_all, max_all)

	plt.plot(x0, y0, color='b', label='H/W SNR=4dB')
	plt.xlabel('Gaussian Noise')
	plt.ylabel('Probability')
	plt.legend()
	title = "$\mu$ = %.4f,  $\sigma$ = %.4f, sample number = %d" % (1.0, 0.4, len(x0))
	plt.savefig(fig_filename, bbox_inches='tight')
	plt.title(title)

	plt.show()


def ib_mapping(x0, filename):
	sample_num = len(x0)
	x0_ib = [0.0]*sample_num
	for i in range(sample_num):
		if x0[i] < ib_boundaries[0]:
			x0_ib[i] = ib_mag[0]
		elif x0[i] >= ib_boundaries[ib_boundary_num-1]:
			x0_ib[i] = ib_mag[ib_level-1]
		else:
			for j in range(ib_boundary_num):
				if x0[i] >= ib_boundaries[j] and x0[i] < ib_boundaries[j+1]:
					x0_ib[i] = ib_mag[j+1]
					break
	
	fd = open(filename, 'w')
	for x0_list in x0_ib:
		fd.write("%d\n" % x0_list)
	fd.close()
	return x0_ib

def distribution_sort(x0, filename):
	sample_num = len(x0)
	dist = [0]*ib_level
	for i in range(sample_num):
		for j in range(ib_level):
			if x0[i] == ib_mag[j]:
				dist[j] = dist[j] + 1
				break
	fd = open(filename, 'w')
	for x0_list in dist:
		fd.write("%f\n" % x0_list)
	fd.close()

	return dist

def bubbleSort(arr, filename): 
	n = len(arr) 

	# Traverse through all array elements 
	for i in range(n-1): 
	# range(n) also work but outer loop will repeat one time more than needed. 

		# Last i elements are already in place 
		for j in range(0, n-i-1): 

			# traverse the array from 0 to n-i-1 
			# Swap if the element found is greater 
			# than the next element 
			if arr[j] > arr[j+1] : 
				arr[j], arr[j+1] = arr[j+1], arr[j] 

	fd = open(filename, 'w')
	for x0_list in arr:
		file2.write("%f\n" % x0_list)

def sw_gauss_sample_gen(export_filename, mean, std_dev, num):
	x0 = norm.rvs(mean, std_dev, size=num)
	x0.sort()
	return x0

def main():
	# x0 = convert_awgn(gng_out_filename[0], x0_awgn_filename[0], 1.0, std_dev_cal(4.0))
	x_sw_awgn = sw_gauss_sample_gen(export_filename=x0_sw_awgn_filename, mean=1.0, std_dev=std_dev_cal(snr_eval),
									num=test_sample_num)
	# y0 = gauss_pdf(x0, x0_gauss_pdf_filename[1])
	# gauss_dist_show(x0, y0)
	# x0_ib = ib_mapping(x0, x0_ib_filename)
	x_sw_ch_msg = ib_mapping(x_sw_awgn, x0_ib_filename[0])

	x_hw_behav_ch_msg = load_file(x0_symbol_gen_filename[0])
	x_hw_impl_func_ch_msg = load_file(x0_symbol_gen_filename[1])
	# x_hw_impl_timing_ch_msg = load_file(x0_symbol_gen_filename[2])

	sw_ch_msg_dist = distribution_sort(x_sw_ch_msg, x0_ib_dist_filename[0])
	hw_ch_msg_dist0 = distribution_sort(x_hw_behav_ch_msg, x0_ib_dist_filename[1])
	hw_ch_msg_dist1 = distribution_sort(x_hw_impl_func_ch_msg, x0_ib_dist_filename[2])
	# hw_ch_msg_dist2 = distribution_sort(x_hw_impl_timing_ch_msg, x0_ib_dist_filename[3])

	fig = plt.figure()
	ax = fig.add_subplot(111)

	## the bars
	ind = np.arange(ib_level)
	width = 0.15
	rects0 = ax.bar(ind, sw_ch_msg_dist, width,
					color='black',
					# yerr=menStd,
					error_kw=dict(elinewidth=2, ecolor='black'), align='edge')

	rects1 = ax.bar(ind + width, hw_ch_msg_dist0, width,
					color='red',
					# yerr=womenStd,
					error_kw=dict(elinewidth=2, ecolor='red'), align='edge')

	rects2 = ax.bar(ind + width * 2, hw_ch_msg_dist1, width,
					color='green',
					# yerr=womenStd,
					error_kw=dict(elinewidth=2, ecolor='green'), align='edge')

	# rects3 = ax.bar(ind+width*3, hw_ch_msg_dist2, width,
	#                    color='blue',
	# yerr=womenStd,
	#                    error_kw=dict(elinewidth=2,ecolor='blue'), align='center')

	# axes and labels
	ax.set_xlim(-width, len(ind) + width * 4)
	max_dist0 = max(sw_ch_msg_dist)
	max_dist1 = max(hw_ch_msg_dist0)
	max_dist2 = max(hw_ch_msg_dist1)
	# max_dist3 = max(hw_ch_msg_dist2)
	max_list = (max_dist0, max_dist1, max_dist2)
	max_all = max(max_list)
	ax.set_ylim(0, max_all + 100)
	ax.set_xlabel('Clustering Level')
	ax.set_ylabel('Distributed Amount')
	ax.set_title(
		'Distribution of Channel Messages over AWGN Channel\n sample number=' + str(test_sample_num) + ' @ SNR=' + str(
			snr_eval) + ', $\sigma$=' + str("{:.5f}".format(std_dev_cal(snr_eval))))
	xTickMarks = ib_mag
	ax.set_xticks(ind + width * 4)
	xtickNames = ax.set_xticklabels(xTickMarks)
	plt.setp(xtickNames, rotation=45, fontsize=10)

	ax.legend([rects0[0], rects1[0], rects2[0]],
			  ['Python norm.rvs($\mu$, $\sigma$)', 'H/W logic simulator', 'FPGA log file'], loc='upper left')
	plt.savefig(fig_ch_msg_dist_filename, bbox_inches='tight')
	plt.show()

if __name__ == "__main__":
	main()
