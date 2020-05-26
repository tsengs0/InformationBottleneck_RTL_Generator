#include "rtl_gen.h"

int main(int argc, char **argv)
{
	if(argc != 3) {
		cout << "Please give the lut csv file and information of quntised bits" << endl;
		exit(1);
	}
	
	unsigned int cardinality = pow(2, atoi(argv[2]));
	verilog_gen Gen(argv[1], cardinality);
	return 0;
}
