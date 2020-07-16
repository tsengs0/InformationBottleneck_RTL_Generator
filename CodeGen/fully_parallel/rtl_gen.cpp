#include "rtl_gen.h"
/*
		char *filename;
		char regular_irr; // regular: 0x00; irregular: 0x01
		unsigned int N, K, M;
		unsigned int max_dc, max_dv; // maxumum number of row weight and column weight
		unsigned int *list_dc, *list_dv; // the list of wights/degrees of all rows and columns respectively.
		// the list of interger coordinates in the m and direction where non-zero entries of row and column are
		unsigned int **cnu_list, **vnc_list;
		unsigned int *index_cnt_cnu, *index_cnt_vnu;
*/
const char *cnu_inst_filename = "cnu_instantiate.v";
const char *cnu_p2s_inst_filename = "cnu_p2s_instantiate.v";
const char *cnu_s2p_inst_filename = "cnu_s2p_instantiate.v";
const char *vnu_inst_filename = "vnu_instantiate.v";
const char *vnu_p2s_inst_filename = "vnu_p2s_instantiate.v";
const char *vnu_s2p_inst_filename = "vnu_s2p_instantiate.v";
const char *fully_parallel_filename = "fully_parallel_route_instantiate.v";
const char *fully_parallel_imple_filename = "fully_parallel_route.v";
const char *cnu_bitSerial_prot_filename = "cnu_bitSerial_port.v";
verilog_gen::verilog_gen(const char *read_filename)
{
  	string str;
 	unsigned int line_cnt, entry_cnt, dc_line_cnt, dv_line_cnt;
	line_cnt = 0; dc_line_cnt = 0; dv_line_cnt = 0;

	cout << "Reading " << read_filename << endl;
	// Reading the file
	pcm_file.open(read_filename);
 	if(!pcm_file){
		cout << "Read File Error" << endl
			<< "Probably there is no parity-check matrix file called " << read_filename << endl;
		exit(1);
	}
	cnu_file.open(cnu_inst_filename); vnu_file.open(vnu_inst_filename);
	cnu_p2s_file.open(cnu_p2s_inst_filename); cnu_s2p_file.open(cnu_s2p_inst_filename);
	vnu_p2s_file.open(vnu_p2s_inst_filename); vnu_s2p_file.open(vnu_s2p_inst_filename);
	fully_parallel_imple_file.open(fully_parallel_imple_filename);

	//Reading file line by line
	while(getline(pcm_file,str)) {
		string token;
        	istringstream stream(str);
		entry_cnt = 0;
		if(line_cnt <= 3) {
        		while(getline(stream,token, ' ')) {
				  if(line_cnt == 0) { // reading (N,K)
					if(entry_cnt == 0) N = std::stoul(token, nullptr, 0);
					else if(entry_cnt == 1) K = std::stoul(token, nullptr, 0);
					else {
						cout << "Format of (N,K) is wrong, in line " << line_cnt << endl;
						exit(1);
					}
					M = N-K; // number of CNUs
					code_rate = (float) K / (float) N;	
				        list_dc = new unsigned int[M];
					list_dv = new unsigned int[N];
					dc_count = new unsigned int[M];
					index_cnt_cnu = new unsigned int[M]();
					index_cnt_vnu = new unsigned int[N]();
				  }
				  else if(line_cnt == 1) { // reading maximum (dv, dc)
					if(entry_cnt == 0) max_dv = std::stoul(token, nullptr, 0);
					else if(entry_cnt == 1) max_dc = std::stoul(token, nullptr, 0);
					else {
						cout << "Format of (dv,dc) is wrong, in line " << line_cnt << endl;
						exit(1);
					}
				  }
				  else if(line_cnt == 2) { // loading the degree of each variable node
					list_dv[entry_cnt] = std::stoul(token, nullptr, 0);
				  }
				  else if(line_cnt == 3) { // loading the degree of each check node
					list_dc[entry_cnt] = std::stoul(token, nullptr, 0);
					dc_count[entry_cnt] = std::stoul(token, nullptr, 0);
					if(entry_cnt == M-1) {
						fully_route_instantiate(fully_parallel_filename);
						fully_route_implementation_port();
					}
				  }
				  entry_cnt += 1;
			}
		}
		else {
        		while(getline(stream,token, '\t')) {
				  if(dv_line_cnt < N && line_cnt > 3) { // generating the instantiation file for VNUs 
					//vnu_instantiate(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1); // index starts from '0'
					vnu_p2s_instantiate(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					//vnu_s2p_instantiate(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					fully_route_implementation(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
				  }
				  else if(dc_line_cnt < M && line_cnt > (3+N)) { // generating the instantiation file for CNUs
					//cnu_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1); // index starts from '0'
					cnu_p2s_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					//cnu_s2p_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
				  }
				  else {
					cout << "Finished RTL code generation" << endl;
				  }
				  entry_cnt += 1;
			}
		}
		if(dv_line_cnt < N && line_cnt > 3) 
			dv_line_cnt += 1;
		else if(dc_line_cnt < M && line_cnt > (3+N)) 
			dc_line_cnt += 1;
		line_cnt += 1;
	}

	cout << "Finished RTL code generation" << endl;
	close_file();
}

void verilog_gen::close_file()
{
	pcm_file.close(); cnu_file.close(); vnu_file.close();
	cnu_p2s_file.close(); cnu_s2p_file.close();
	vnu_p2s_file.close(); vnu_s2p_file.close();
	fully_parallel_file.close();

}

void verilog_gen::show_param(void) 
{
	cout << "(N, K): (" << N << ", " << K << ")" << endl;
	cout << "maximum (dv, dc): (" << max_dv << ", " << max_dc << ")" << endl;
}

void verilog_gen::cnu_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	if(index_cnt_vnu[coordinate] >= list_dv[coordinate]) {
		cout << "The number of outcoming messages to VNUs is different to the configured dv, in line " << line_cnt << endl;
		exit(1);
	}	
	else {
		if(entry_cnt == 0) {
			if(list_dc[line_cnt] == 6) {
				cnu_file << "cnu_6 u" << line_cnt << " (" << endl << "\t"
				         << ".E0 (" << "e_" << line_cnt << "_" << coordinate << ")," << endl << "\t"	
					 << ".M0 (" << "m_" << line_cnt << "_" << coordinate << "_p)," << endl << endl << "\t";			
			}
		}
		else if(entry_cnt == list_dc[line_cnt]-1){
			cnu_file << ".E" << entry_cnt << " (e_" << line_cnt << "_" << coordinate << ")," << endl << "\t"
				 << ".M" << entry_cnt << " (m_" << line_cnt << "_" << coordinate << "_p)," << endl << endl << "\t" 
				 << ".sys_clk (sys_clk)," << endl << "\t.rstn (rstn)" 
				 << endl << ");" << endl; 
		}
		else {
			cnu_file << ".E" << entry_cnt << " (e_" << line_cnt << "_" << coordinate << ")," << endl << "\t"
				 << ".M" << entry_cnt << " (m_" << line_cnt << "_" << coordinate << "_p)," << endl << endl << "\t"; 
		}
	}
	index_cnt_vnu[coordinate] += 1;
}

void verilog_gen::cnu_p2s_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	cnu_p2s_file << "parallel2serial u" << (line_cnt*list_dc[line_cnt])+entry_cnt << " (" << endl << "\t"
	         << ".serial_data (e_" << line_cnt << "_" << coordinate << "_s)," << endl << "\t"
		 << ".convert_done (cnu_p2s_done_" << line_cnt << "_" << coordinate << ")," << endl << "\t"
		 << ".serial_clk (sys_clk)," << endl << "\t"
		 << ".rstn (rstn)," << endl << "\t"
		 //<< ".serial_en()," << endl << "\t" 
		 //<< ".load()" << endl << "\t"
		 << ".data_in (e_" << line_cnt << "_" << coordinate << ")"
		 << endl << ");" << endl;   
}

void verilog_gen::cnu_s2p_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	cnu_s2p_file << "serial2parallel u" << (line_cnt*list_dc[line_cnt])+entry_cnt << " (" << endl << "\t"
	         << ".parallel_data (e_" << line_cnt << "_" << coordinate << "_p)," << endl << "\t"
		 << ".convert_done (cnu_s2p_done_" << line_cnt << "_" << coordinate << ")," << endl << "\t"
		 << ".serial_clk (sys_clk)," << endl << "\t"
		 << ".rstn (rstn)," << endl << "\t"
		 //<< ".serial_en()," << endl << "\t" 
		 << ".data_in (e_" << line_cnt << "_" << coordinate << "_s)"
		 << endl << ");" << endl;   
}

// Not finished yet
void verilog_gen::cnu_bitSerial_port(const char *filename)
{
	cnu_bitSerial_port_file.open(filename);
	cnu_bitSerial_port_file << "`include \"define.v\"" << endl << endl
		<< "module cnu_bitSerial_port (" << endl << "\t"
		<< "inout wire [`CN_DEGREE-1]";		
}

void verilog_gen::fully_route_instantiate(const char *filename)
{
	fully_parallel_file.open(filename);
	fully_parallel_file << "fully_parallel_route routing_network(" << endl << "\t"
			    << "// (N-K) number of check-to-Variable message buses, each of which is d_c bit width as input ports of this routing network" << endl << "\t"; 
	// Generating the instantiation of output port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < max_dc; j++) {
			fully_parallel_file << ".v2c_parallelOut_" << i << j << "(v2c_" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";

	fully_parallel_file << "// N number of check-to-Variable message buses, each of which is d_v bit width outgoing to serial-to-parallel converters" 
			    << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < max_dv; j++) {
			fully_parallel_file << ".c2v_parallelOut_" << i << j << "(c2v_" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";

	// Generating the instantiation of input port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < max_dc; j++) {
			fully_parallel_file << ".c2v_parallelIn_" << i << j << "(c2v_" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < max_dv; j++) {
			fully_parallel_file << ".v2c_parallelIn_" << i << j << "(v2c_" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	
	fully_parallel_file << endl << "\t";
	fully_parallel_file << ".load()," << endl << "\t"
			    << ".parallel_en ()," << endl << "\t"
			    << ".serial_clk (ram_clk)" << endl
			    << "};"; 
}
		
void verilog_gen::fully_route_implementation(unsigned line_cnt, unsigned int entry_cnt, unsigned int coordinate) // only for regular codes
{
	if(dc_count[coordinate] == 0) {
		cout << "Somethings wrong on the settings of check node degree, the degree of the check node " << coordinate << "is " << list_dc[coordinate] 
		     << "." << endl << "However, there are more than such number of variable nodes which are managed to be connected to the check node." << endl
		     << "Please check the format of the given configuration file of Parity Check Matrix" << endl;
		exit(1);
	}
	else if(entry_cnt == 0) {
		fully_parallel_imple_file << endl << "\tvnu_bitSerial_port vnu_converter_port" << line_cnt << " (" << endl << "\t\t";
	        fully_parallel_imple_file << ".serialInOut ({cn_serialInOut_" << coordinate << "[" 
					  << list_dc[coordinate]-dc_count[coordinate] << "],";
		dc_count[coordinate]-=1;
	}
	else if(entry_cnt < (list_dv[line_cnt]-1)){
	        fully_parallel_imple_file << " cn_serialInOut_" << coordinate << "[" 
					  << list_dc[coordinate]-dc_count[coordinate] << "],";
		dc_count[coordinate]-=1;
	}
	else {
	        fully_parallel_imple_file << " cn_serialInOut_" << coordinate << "[" 
					  << list_dc[coordinate]-dc_count[coordinate] << "]})," << endl << "\t\t"
					  << ".load (load[1])," << endl << "\t\t"
					  << ".parallel_en (parallel_en[1])," << endl << "\t\t"
				          << ".serial_clk (serial_clk)" << endl << "\t"
					  << ");" << endl;
		dc_count[coordinate]-=1;
		if(line_cnt == (N-1)) fully_parallel_imple_file << "endmodule";
	}
}

void verilog_gen::fully_route_implementation_port()
{
	fully_parallel_imple_file << "`include \"define.vh\"" << endl << endl;
	fully_parallel_imple_file << "module fully_parallel_route(" << endl << "\t"
			    << "// (N-K) number of check-to-Variable message buses, each of which is d_c bit width as input ports of this routing network" << endl << "\t"; 
	// Generating the instantiation of output port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << "output wire [`DATAPATH_WIDTH-1:0] v2c_parallelOut_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";

	fully_parallel_imple_file << "// N number of check-to-Variable message buses, each of which is d_v bit width outgoing to serial-to-parallel converters" 
			    << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < list_dv[i]; j++) {
			fully_parallel_imple_file << "output wire [`DATAPATH_WIDTH-1:0] c2v_parallelOut_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";

	// Generating the instantiation of input port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << "input wire [`DATAPATH_WIDTH-1:0] c2v_parallelIn_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < list_dv[i]; j++) {
			fully_parallel_imple_file << "input wire [`DATAPATH_WIDTH-1:0] v2c_parallelIn_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";
	
	fully_parallel_imple_file << "input wire [1:0] load," << endl << "\t"
			    << "input wire [1:0] parallel_en," << endl << "\t"
			    << "input wire serial_clk" << endl
			    << ");" << endl << "\t"; 

	// Declare the internal wires
	for(unsigned int i=0; i < M; i++) {
		fully_parallel_imple_file << endl << "\t" << "wire [`CN_DEGREE-1:0] cn_serialInOut_" << i << ";" << endl << "\t"
			<< "cnu_bitSerial_port cnu_converter_port" << i << "(" << endl << "\t\t"
			<< ".serialInOut (cn_serialInOut_" << i << "[`CN_DEGREE-1:0])," << endl << "\t\t";
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << ".v2c_parallelOut_" << j << " (v2c_parallelOut_" << i << j << "[`DATAPATH_WIDTH-1:0]),"
						  << endl << "\t\t";
		}
		fully_parallel_imple_file << endl << "\t\t";
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << ".c2v_parallelIn_" << j << " (c2v_parallelIn_" << i << j << "[`DATAPATH_WIDTH-1:0]),"
						  << endl << "\t\t";
		}
		fully_parallel_imple_file << ".load (load[0])," << endl << "\t\t"
			    << ".parallel_en (parallel_en[0])," << endl << "\t\t"
			    << ".serial_clk (serial_clk)" << endl << "\t"
			    << ");" << endl << "\t"; 
	}
}

void verilog_gen::vnu_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	if(index_cnt_cnu[coordinate] >= list_dc[coordinate]) {
		cout << "The number of outcoming messages to CNUs is different to the configured dc, in line " << line_cnt << endl;
		exit(1);
	}	
	else {
		if(entry_cnt == 0) {
			if(list_dv[line_cnt] == 3) {
				vnu_file << "vnu_3 u" << line_cnt << " (" << endl << "\t"
				         << ".M0 (" << "m_" << coordinate << "_" << line_cnt << ")," << endl << "\t"	
					 << ".E0 (" << "e_" << coordinate << "_" << line_cnt << "_p)," << endl << endl << "\t";			
			}
		}
		else if(entry_cnt == list_dv[line_cnt]-1){
			vnu_file << ".M" << entry_cnt << " (m_" << coordinate << "_" << line_cnt << ")," << endl << "\t"
				 << ".E" << entry_cnt << " (e_" << coordinate << "_" << line_cnt << "_p)," << endl << endl << "\t" 
				 << ".sys_clk (sys_clk)," << endl << "\t.rstn (rstn)" 
				 << endl << ");" << endl; 
		}
		else {
			vnu_file << ".M" << entry_cnt << " (m_" << coordinate << "_" << line_cnt << ")," << endl << "\t"
				 << ".E" << entry_cnt << " (e_" << coordinate << "_" << line_cnt << "_p)," << endl << endl << "\t"; 
		}
	}
	index_cnt_cnu[coordinate] += 1;
}

void verilog_gen::vnu_p2s_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	vnu_p2s_file << "parallel2serial u" << (line_cnt*list_dv[line_cnt])+entry_cnt << " (" << endl << "\t"
	         << ".serial_data (m_" << coordinate << "_" << line_cnt << "_s)," << endl << "\t"
		 << ".convert_done (vnu_p2s_done_" << coordinate << "_" << line_cnt << ")," << endl << "\t"
		 << ".serial_clk (sys_clk)," << endl << "\t"
		 << ".rstn (rstn)," << endl << "\t"
		 //<< ".serial_en()," << endl << "\t" 
		 //<< ".load()" << endl << "\t"
		 << ".data_in (m_" << coordinate << "_" << line_cnt << ")"
		 << endl << ");" << endl;   
}

void verilog_gen::vnu_s2p_instantiate(unsigned int line_cnt, unsigned int entry_cnt, unsigned int coordinate)
{
	vnu_s2p_file << "serial2parallel u" << (line_cnt*list_dv[line_cnt])+entry_cnt << " (" << endl << "\t"
	         << ".parallel_data (m_" << coordinate << "_" << line_cnt << "_p)," << endl << "\t"
		 << ".convert_done (vnu_s2p_done_" << coordinate << "_" << line_cnt << ")," << endl << "\t"
		 << ".serial_clk (sys_clk)," << endl << "\t"
		 << ".rstn (rstn)," << endl << "\t"
		 //<< ".serial_en()," << endl << "\t" 
		 << ".data_in (m_" << coordinate << "_" << line_cnt << "_s)"
		 << endl << ");" << endl;   
}