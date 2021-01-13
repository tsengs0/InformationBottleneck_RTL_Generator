#include "rtl_gen.h"

int main(int argc, char **argv)
{
	if(argc != 2) {
		cout << "The file of Parity Check Matrix must be given" << endl;
		exit(1);
	}
	verilog_gen Gen(argv[1]);
	Gen.show_param();
	return 0;
}
