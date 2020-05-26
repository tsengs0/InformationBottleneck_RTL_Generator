#ifndef __RTL_GEN_H
#define __RTL_GEN_H

#include <iostream>
#include <vector>
#include <sstream>
#include <string>
#include <fstream>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>

using namespace std;
enum {
	Y0 = 0,
	Y1 = 1,
	T  = 2
};
class verilog_gen {
	private:
		char *filename;
		ofstream lut_in2_file;
		unsigned int dc;
		unsigned int cardinality;

	public:
		verilog_gen(const char *read_filename, unsigned int card); 
		void show_param(void);
		
		void lut_in2_case(unsigned int y0, unsigned int y1, unsigned int t);		
};	
#endif
