#include "rtl_gen.h"

const char *lut_in2_case_filename = "lut_in2_case.v";
verilog_gen::verilog_gen(const char *read_filename, unsigned int card)
{
	unsigned int element_cnt, entry_cnt;
  	unsigned int y0, y1, t;
	string str;
	
	cardinality = card;
	cout << "Reading " << read_filename << endl;
	// Reading the file
	ifstream ifs(read_filename);
 	if(!ifs){
		cout << "Read File Error" << endl
			<< "Probably there is no lut csv file called " << read_filename << endl;
		exit(1);
	}
	lut_in2_file.open(lut_in2_case_filename);

	//Reading file line by line
	entry_cnt = 0;
	while(getline(ifs,str)) {
		string token;
		
        	istringstream stream(str);
		element_cnt = Y0; 
        		while(getline(stream,token, ',')) {
				if(element_cnt == (unsigned int) Y0) // Read value of y0
					y0 = std::stoul(token, nullptr, 0);
				else if(element_cnt == (unsigned int) Y1) // Read value of y1
					y1 = std::stoul(token, nullptr, 0);
				else if(element_cnt == (unsigned int) T) // Read value of t
					t = std::stoul(token, nullptr, 0);
				else {
					puts("Wrong format of CSV file was generated");
					exit(1);
				}
				element_cnt += 1;
			}
		lut_in2_case(y0, y1, t);
		entry_cnt += 1;
	}
	if(entry_cnt != (cardinality*cardinality)) {
		puts("Wrong format of CSV file was generated");
		cout << "There suppose be " << cardinality*cardinality  << " number of entries in the underlying LUT" << endl;
	}
	else
		lut_in2_file.close();
}

void verilog_gen::lut_in2_case(unsigned int y0, unsigned int y1, unsigned int t)
{
	lut_in2_file << "{`QUAN_SIZE'd" << y0 << ", `QUAN_SIZE'd" << y1 << "}: t_c[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd" << t << ";" << endl;
}

