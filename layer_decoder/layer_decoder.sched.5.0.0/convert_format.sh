#/bin/bash

for i in {0..9}
do
	echo "--------------------------Chekc-to-Variable Msg to BS Log File Conversion---------------------------"
	rm "submatrix_"$i"_c2v_to_bs.mem.csv";
	python ./convert_format.py "submatrix_"$i"_c2v_to_bs.mem";
	rm "submatrix_"$i"_c2v_to_bs.mem"

	echo "--------------------------Variable-to-Check Msg to BS Log File Conversion---------------------------"
	rm "submatrix_"$i"_v2c_to_bs.mem.csv";
	python ./convert_format.py "submatrix_"$i"_v2c_to_bs.mem";
	rm "submatrix_"$i"_v2c_to_bs.mem"

	echo "--------------------------Chekc-to-Variable Msg MEMs to VNUs Log File Conversion---------------------------"
	rm "c2v_mem_fetch_submatrix_"$i".csv";
	python ./convert_format.py "c2v_mem_fetch_submatrix_"$i;
	rm "c2v_mem_fetch_submatrix_"$i

	echo "--------------------------Variable-to-Check Msg MEMs to CNUs Log File Conversion---------------------------"
	rm "v2c_mem_fetch_submatrix_"$i".csv";
	python ./convert_format.py "v2c_mem_fetch_submatrix_"$i;
	rm "v2c_mem_fetch_submatrix_"$i

	echo "--------------------------Variable-to-Check Msg MEMs to CNUs Log File Conversion---------------------------"
	rm "mem_to_signExten_sub"$i".mem.csv"
	python ./convert_format.py "mem_to_signExten_sub"$i".mem";
	rm "mem_to_signExten_sub"$i".mem"
done