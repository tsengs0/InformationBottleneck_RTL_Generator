#ifndef __RTL_GEN_H
#define __RTL_GEN_H

#include <iostream>
#include <vector>
#include <sstream>
#include <string>
#include <fstream>
#include <cstdio>
#include <cstdlib>

using namespace std;
enum {
	REGULAR   = 0x00,
	IRREGULAR = 0x01
};

class verilog_gen {
	private:
		char *filename;
		ifstream pcm_file;
		ofstream cnu_file, vnu_file, cnu_p2s_file, cnu_s2p_file, vnu_p2s_file, vnu_s2p_file;
		ofstream cnu_bitSerial_port_file, fully_parallel_file, fully_parallel_imple_file;
		char regular_irr; // regular: 0x00; irregular: 0x01
		unsigned int N, K, M;
		unsigned int max_dc, max_dv; // maxumum number of row weight and column weight
		unsigned int *list_dc, *list_dv; // the list of wights/degrees of all rows and columns respectively.
		// the list of interger coordinates in the m and direction where non-zero entries of row and column are
		unsigned int **cnu_list, **vnc_list;
		unsigned int *index_cnt_cnu, *index_cnt_vnu;
		float code_rate;

	public:
		verilog_gen(const char *read_filename); 
		void close_file();
		void show_param(void);
				
		void cnu_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
		// 1) Wired route instatiation which will be used in top.v
		void cnu_p2s_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
		void cnu_s2p_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
		// 2) Bit-serial fully-parallel route which will be used in top.v
		/*Not Finished Yet*/void cnu_bitSerial_port(const char *filename);
		/*Not Finished Yet*/void vnu_bitSerial_port(const char *filename);
		void fully_route_instantiate(const char *filename); // only for regular codes
		void fully_route_implementation(const char *filename); // only for regular codes
		
		void vnu_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
		void vnu_p2s_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
		void vnu_s2p_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate);
};	
#endif
