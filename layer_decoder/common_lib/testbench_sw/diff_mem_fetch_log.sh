#/bin/bash

rm diff.c2v.sub*
rm diff.v2c.sub*

for i in {0..9}
do
	diff c2v_mem_fetch_sub$i ~/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/layer_decoder_solution/v2c_mem_fetch_sub$i > diff.c2v.sub$i
	diff c2v_mem_fetch_sub$i v2c_mem_fetch_sub$i > diff.v2c.sub$i
	
	echo "--------------------------Chekc-to-Variable Verification---------------------------"
	if [ -s diff.c2v.sub$i ]
	then
		echo "***********Thus C2V_to_MEM of submatrix" $i "is incorrect"
		cat diff.c2v.sub$i
	else
		echo "Thus C2V_to_MEM of submatrix" $i "is correct"
	fi
	echo "--------------------------Variable-to-Check Verification---------------------------"
	if [ -s diff.v2c.sub$i ]
	then
		echo "***********Thus V2C_to_MEM of submatrix" $i "is incorrect"
		cat diff.v2c.sub$i
	else
		echo "Thus V2C_to_MEM of submatrix" $i "is correct"
	fi
	echo "-----------------------------------------------------------------------------------"
done