#include "rtl_gen.h"
/*
		char *filename;
		char regular_irr; // regular: 0x00; irregular: 0x01
		unsigned int N, K, M;
		unsigned int max_dc, max_dv; // maxumum number of row weight and column weight
		unsigned int *list_dc, *list_dv; // the list of wights/degrees of all rows and columns respectively.
		// the list of interger coordinates in the m and direction where non-zero entries of row and column are
		unsigned int **cnu_route, **vnu_route;
		unsigned int *index_cnt_cnu, *index_cnt_vnu;
*/
/*legacy*/ const char *cnu_inst_filename = "cnu_instantiate.v";
/*legacy*/ const char *cnu_p2s_inst_filename = "cnu_p2s_instantiate.v";
/*legacy*/ const char *cnu_s2p_inst_filename = "cnu_s2p_instantiate.v";
/*legacy*/ const char *vnu_inst_filename = "vnu_instantiate.v";
/*legacy*/ const char *vnu_p2s_inst_filename = "vnu_p2s_instantiate.v";
/*legacy*/ const char *vnu_s2p_inst_filename = "vnu_s2p_instantiate.v";
const char *fully_parallel_filename = "fully_parallel_route_instantiate.v";
const char *fully_parallel_imple_filename = "fully_parallel_route.v";
const char *cnu_bitSerial_prot_filename = "cnu_bitSerial_port.v";
const char *vnu_bitSerial_prot_filename = "vnu_bitSerial_port.v";
const char *cnu_ib_ram_wrapper_filename = "cnu6_ib_ram_wrapper.v";
const char *vnu_ib_ram_wrapper_filename = "vnu3_ib_ram_wrapper.v";
const char *ib_proc_wrapper_filename = "ib_proc_wrapper.v";
const char *ib_ram_wrapper_port_filename = "ib_ram_wrapper_port.v";
const char *cnu6_ib_ram_cascade_template_filename = "template/cnu6_ib_ram_cascade_template.v";
const char *vnu3_ib_ram_cascade_template_filename = "template/vnu3_ib_ram_cascade_template.v";

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
	//cnu_p2s_file.open(cnu_p2s_inst_filename); cnu_s2p_file.open(cnu_s2p_inst_filename);
	//vnu_p2s_file.open(vnu_p2s_inst_filename); vnu_s2p_file.open(vnu_s2p_inst_filename);
	fully_parallel_imple_file.open(fully_parallel_imple_filename);
	cnu_bitSerial_port_file.open(cnu_bitSerial_prot_filename);
	vnu_bitSerial_port_file.open(vnu_bitSerial_prot_filename);

	//Reading file line by line
	while(getline(pcm_file,str)) {
		string token;
        	istringstream stream(str);
		entry_cnt = 0;
		if(line_cnt <= 3) {
        		while(getline(stream,token, ' ')) {
				  if(line_cnt == 0) { // reading (N,K)
					if(entry_cnt == 0) N = std::stoul(token, nullptr, 0);
					else if(entry_cnt == 1) {
						K = std::stoul(token, nullptr, 0);
						M = N-K; // number of CNUs
						code_rate = (float) K / (float) N;
				        	list_dc = new unsigned int[M];
						list_dv = new unsigned int[N];
						dc_count = new unsigned int[M];
						index_cnt_cnu = new unsigned int[M]();
						index_cnt_vnu = new unsigned int[N]();
						cnu_route = new unsigned int* [M];
						vnu_route = new unsigned int* [N];
					}
					else {
						cout << "Format of (N,K) is wrong, in line " << line_cnt << endl;
						exit(1);
					} 
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
					vnu_route[entry_cnt] = new unsigned int[list_dv[entry_cnt]];
				  }
				  else if(line_cnt == 3) { // loading the degree of each check node
					list_dc[entry_cnt] = std::stoul(token, nullptr, 0);
					dc_count[entry_cnt] = list_dc[entry_cnt];
					cnu_route[entry_cnt] = new unsigned int[list_dc[entry_cnt]];
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
					//vnu_p2s_instantiate(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					//vnu_s2p_instantiate(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					//fully_route_implementation(dv_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					unsigned int coordinate = std::stoul(token, nullptr, 0)-1;
					vnu_route[dv_line_cnt][entry_cnt] = coordinate;
				  }
				  else if(dc_line_cnt < M && line_cnt > (3+N)) { // generating the instantiation file for CNUs
					//cnu_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1); // index starts from '0'
					//cnu_p2s_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					//cnu_s2p_instantiate(dc_line_cnt, entry_cnt, std::stoul(token, nullptr, 0)-1);
					unsigned int coordinate = std::stoul(token, nullptr, 0)-1;
					cnu_route[dc_line_cnt][entry_cnt] = coordinate;
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

	// Generating/Routing the connectivities of 1-bit wires between input/output of CNUs and VNUs
	for(unsigned int vn_id = 0; vn_id < N; vn_id++) {
		for(unsigned int line_entry_cnt = 0; line_entry_cnt < list_dv[vn_id]; line_entry_cnt++)
			fully_route_implementation(vn_id, line_entry_cnt, vnu_route[vn_id][line_entry_cnt]);
	}

	// Generating the implementation template of parallel-to-serial-to-parallel converter
	cnu_bitSerial_port(cnu_bitSerial_port_file);
	vnu_bitSerial_port(vnu_bitSerial_port_file);

	// Generating CNU, VNU and DNU IB-RAM Wrappers
	cnu_decompose_num = max_dc-2; vnu_decompose_num = max_dv+1-2;
	ib_ram_wrapper();
	
	// Generating the instantiation of IB-Process Unit which will be appended into the decoder top module
	ib_ram_wrapper_instantiate();

	cout << "Finished RTL code generation" << endl;
	close_file();
}

void verilog_gen::close_file()
{
	pcm_file.close(); 
	//cnu_file.close(); vnu_file.close();
	//cnu_p2s_file.close(); cnu_s2p_file.close();
	//vnu_p2s_file.close(); vnu_s2p_file.close();
	cnu_bitSerial_port_file.close();
	vnu_bitSerial_port_file.close();
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

void verilog_gen::cnu_bitSerial_port(ofstream &fd)
{
	fd 	<< "module cnu_bitSerial_port #(" << endl << "\tparameter MSG_WIDTH = 4," << endl 
		<< "\tparameter CN_DEGREE = 6" << endl
		<< ") (" << endl;
for(unsigned int i = 0; i < max_dc; i++) 
		fd << "\tinout wire serialInOut_" << i << "," << endl;

	// Output port of d_c number of variable-to-check messages
	for(unsigned int i = 0; i < max_dc; i++) 
		fd << "\toutput wire [MSG_WIDTH-1:0] v2c_parallelOut_" << i << "," << endl;
	fd << endl;

	// Input port of d_c number of check-to-variable messages
	for(unsigned int i = 0; i < max_dc; i++) 
		fd << "\tinput wire [MSG_WIDTH-1:0] c2v_parallelIn_" << i << "," << endl;

	fd << "\tinput wire load," << endl
							<< "\tinput wire parallel_en," << endl
							<< "\tinput wire serial_clk" << endl
							<< ");";
	fd << endl;

	// Implementation
	cnu_bitSerial_port_implementation(fd);
}
void verilog_gen::cnu_bitSerial_port_implementation(ofstream &fd)
{
	for(unsigned int i = 0; i < max_dc; i++) {
		fd << endl << "halfDuplex_parallel2serial #(" << endl
								 << "\t.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit" << endl
								 << ") cnu_interface_u" << i << "(" << endl
								 << "\t.serial_inout (serialInOut_" << i << ")," << endl
								 << "\t.parallel_out (v2c_parallelOut_" << i << "[MSG_WIDTH-1:0])," << endl << endl
								 << "\t.parallel_in (c2v_parallelIn_" << i << "[MSG_WIDTH-1:0])," << endl
								 << "\t.load (load)," << endl
								 << "\t.parallel_en (parallel_en)," << endl
								 << "\t.sys_clk (serial_clk)" << endl
								 << ");";
	}
	fd << endl << "endmodule";
}

void verilog_gen::vnu_bitSerial_port(ofstream &fd)
{
	fd 	<< "module vnu_bitSerial_port #(" << endl << "\tparameter MSG_WIDTH = 4," << endl
		<< "\tparameter VN_DEGREE = 3" << endl
		<< ") (" << endl;

for(unsigned int i = 0; i < max_dv; i++) 
		fd << "\tinout wire serialInOut_" << i << "," << endl;

	// Output port of d_c number of check-to-variable messages
	for(unsigned int i = 0; i < max_dv; i++) 
		fd << "\toutput wire [MSG_WIDTH-1:0] c2v_parallelOut_" << i << "," << endl;
	fd << endl;

	// Input port of d_c number of variable-to-check messages
	for(unsigned int i = 0; i < max_dv; i++) 
		fd << "\tinput wire [MSG_WIDTH-1:0] v2c_parallelIn_" << i << "," << endl;

	fd << "\tinput wire load," << endl
							<< "\tinput wire parallel_en," << endl
							<< "\tinput wire serial_clk" << endl
							<< ");";
	fd << endl;

	// Implementation
	vnu_bitSerial_port_implementation(fd);
}
void verilog_gen::vnu_bitSerial_port_implementation(ofstream &fd)
{
	for(unsigned int i = 0; i < max_dv; i++) {
		fd << endl << "halfDuplex_parallel2serial #(" << endl
								 << "\t.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit" << endl
								 << ") vnu_interface_u" << i << "(" << endl
								 << "\t.serial_inout (serialInOut_" << i << ")," << endl
								 << "\t.parallel_out (c2v_parallelOut_" << i << "[MSG_WIDTH-1:0])," << endl << endl
								 << "\t.parallel_in (v2c_parallelIn_" << i << "[MSG_WIDTH-1:0])," << endl
								 << "\t.load (load)," << endl
								 << "\t.parallel_en (parallel_en)," << endl
								 << "\t.sys_clk (serial_clk)" << endl
								 << ");";
	}
	fd << endl << "endmodule";
}

void verilog_gen::fully_route_instantiate(const char *filename)
{
	fully_parallel_file.open(filename);
	fully_parallel_file << "fully_parallel_route #(" << endl
					    << "\t.DATAPATH_WIDTH(DATAPATH_WIDTH)," << endl
					    << "\t.CN_DEGREE     (CN_DEGREE)," << endl
					    << "\t.VN_DEGREE     (VN_DEGREE)," << endl
					    << "\t.MSG_WIDTH     (MSG_WIDTH)"  << endl
						<< ") routing_network (" << endl
			            << "// (N-K) number of check-to-Variable message buses, each of which is d_c bit width as input ports of this routing network" << endl << "\t"; 
	// Generating the instantiation of output port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < max_dc; j++) {
			fully_parallel_file << ".v2c_parallelOut_" << i << j << "(v2c_out" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";

	fully_parallel_file << "// N number of check-to-Variable message buses, each of which is d_v bit width outgoing to serial-to-parallel converters" 
			    << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < max_dv; j++) {
			fully_parallel_file << ".c2v_parallelOut_" << i << j << "(c2v_out" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";

	// Generating the instantiation of input port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < max_dc; j++) {
			fully_parallel_file << ".c2v_parallelIn_" << i << j << "(c2v_in" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	fully_parallel_file << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < max_dv; j++) {
			fully_parallel_file << ".v2c_parallelIn_" << i << j << "(v2c_in" << j << "[" << i << "])," << endl << "\t"; 
		}
	}
	
	fully_parallel_file << endl << "\t";
	fully_parallel_file << ".load(load[1:0])," << endl << "\t"
			    << ".parallel_en (parallel_en[1:0])," << endl << "\t"
			    << ".serial_clk (read_clk)" << endl
			    << ");"; 
	fully_parallel_file.close();
}

unsigned int verilog_gen::find_index_intersection(unsigned int vn_line_cnt, unsigned int coordinate)
{
	unsigned int i;
	for(i = 0; i < list_dc[coordinate]; i++) {
		if(cnu_route[coordinate][i] == vn_line_cnt) break;
	}
	return i;
}
		
void verilog_gen::fully_route_implementation(unsigned line_cnt, unsigned int entry_cnt, unsigned int coordinate) // only for regular codes
{
	unsigned int id; id = 0;
/*
	if(dc_count[coordinate] == 0) {
		cout << "Somethings wrong on the settings of check node degree, the degree of the check node " << coordinate << " is " << list_dc[coordinate] 
		     << "." << endl << "However, there are more than such number of variable nodes which are managed to be connected to the check node." << endl
		     << "Please check the format of the given configuration file of Parity Check Matrix" << endl;
		exit(1);
	}
	else */if(entry_cnt == 0) {
		id = find_index_intersection(line_cnt, coordinate);
		fully_parallel_imple_file << endl << "vnu_bitSerial_port #(" << endl
		    << "\t.MSG_WIDTH (MSG_WIDTH)," << endl
			<< "\t.VN_DEGREE (VN_DEGREE)" << endl
			<< ") vnu_converter_port" << line_cnt << " (" << endl << "\t\t";
	        fully_parallel_imple_file << ".serialInOut_" << entry_cnt << " (cn_serialInOut_" << coordinate << "[" 
					  << id << "])," << endl << "\t\t";//<< list_dc[coordinate]-dc_count[coordinate] << "])," << endl << "\t\t";
		dc_count[coordinate]-=1;
	}
	else if(entry_cnt < (list_dv[line_cnt]-1)){
		id = find_index_intersection(line_cnt, coordinate);
	        fully_parallel_imple_file << ".serialInOut_" << entry_cnt << " (cn_serialInOut_" << coordinate << "[" 
					  << id << "])," << endl << "\t\t";//<< list_dc[coordinate]-dc_count[coordinate] << "])," << endl << "\t\t";
		dc_count[coordinate]-=1;
	}
	else {
		id = find_index_intersection(line_cnt, coordinate);
	        fully_parallel_imple_file << ".serialInOut_" << entry_cnt <<" (cn_serialInOut_" << coordinate << "[" 
					  << id << "])," << endl << "\t\t";//<< list_dc[coordinate]-dc_count[coordinate] << "])," << endl << "\t\t";

			// Instantiation of check-to-variable outgoing message (after PSP converter, i.e., completion of message passing)
			for(unsigned int i = 0; i < list_dv[line_cnt]; i++) {
				fully_parallel_imple_file << ".c2v_parallelOut_" << i << "(c2v_parallelOut_" << line_cnt << i 
										  << "[`DATAPATH_WIDTH-1:0])," << endl << "\t\t";
			}
			fully_parallel_imple_file << endl << "\t\t";
			// Instantiation of variable-to-check incoming message (after PSP converter, i.e., completion of message passing)
			for(unsigned int i = 0; i < list_dv[line_cnt]; i++) {
				fully_parallel_imple_file << ".v2c_parallelIn_" << i << "(v2c_parallelIn_" << line_cnt << i 
										  << "[`DATAPATH_WIDTH-1:0])," << endl << "\t\t";
			}

			fully_parallel_imple_file << ".load (load[1])," << endl << "\t\t"
									  << ".parallel_en (parallel_en[1])," << endl << "\t\t"
									  << ".serial_clk (serial_clk)" << endl
									  << ");" << endl;
		dc_count[coordinate]-=1;
		if(line_cnt == (N-1)) fully_parallel_imple_file << "endmodule";
	}
}

void verilog_gen::fully_route_implementation_port()
{
	fully_parallel_imple_file << "module fully_parallel_route #(" << endl
							  << "\tparameter DATAPATH_WIDTH = 4," << endl
							  << "\tparameter CN_DEGREE      = 6," << endl
							  << "\tparameter VN_DEGREE      = 3," << endl
							  << "\tparameter MSG_WIDTH      = 4"  << endl
							  << ") (" << endl
							  << "\t// (N-K) number of check-to-Variable message buses, each of which is d_c bit width as input ports of this routing network" << endl << "\t"; 
	// Generating the instantiation of output port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << "output wire [DATAPATH_WIDTH-1:0] v2c_parallelOut_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";

	fully_parallel_imple_file << "// N number of check-to-Variable message buses, each of which is d_v bit width outgoing to serial-to-parallel converters" 
			    << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < list_dv[i]; j++) {
			fully_parallel_imple_file << "output wire [DATAPATH_WIDTH-1:0] c2v_parallelOut_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";

	// Generating the instantiation of input port
	for(unsigned int i=0; i < M; i++) {
		for(unsigned int j=0; j < list_dc[i]; j++) {
			fully_parallel_imple_file << "input wire [DATAPATH_WIDTH-1:0] c2v_parallelIn_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";
	for(unsigned int i=0; i < N; i++) {
		for(unsigned int j=0; j < list_dv[i]; j++) {
			fully_parallel_imple_file << "input wire [DATAPATH_WIDTH-1:0] v2c_parallelIn_" << i << j << "," << endl << "\t"; 
		}
	}
	fully_parallel_imple_file << endl << "\t";
	
	fully_parallel_imple_file << "input wire [1:0] load," << endl << "\t"
			    << "input wire [1:0] parallel_en," << endl << "\t"
			    << "input wire serial_clk" << endl
			    << ");" << endl; 

	// Declare the internal wires
	for(unsigned int i=0; i < M; i++) {
		fully_parallel_imple_file << endl << "\t" << "wire [CN_DEGREE-1:0] cn_serialInOut_" << i << ";" << endl << "\t"
			<< "cnu_bitSerial_port #(" << endl
			<< "\t.MSG_WIDTH (MSG_WIDTH)," << endl
			<< "\t.CN_DEGREE (CN_DEGREE)" << endl
			<< ") cnu_converter_port" << i << "(" << endl << "\t\t";
		for(unsigned int j = 0; j < list_dc[i]; j++) 
			fully_parallel_imple_file << ".serialInOut_" << j << " (cn_serialInOut_" << i << "[" << j << "])," << endl << "\t\t";
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
			    << ".serial_clk (serial_clk)" << endl
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

void verilog_gen::ib_ram_wrapper ()
{
	string str;
	// Wrapper of CNU
	ofstream cnu_wrapper;
	ifstream cnu_template;
	
	cnu_wrapper.open(cnu_ib_ram_wrapper_filename);
	cnu_template.open(cnu6_ib_ram_cascade_template_filename);
	cnu_wrapper << "module cnu" << max_dc << "_ib_ram_wrapper #(" << endl
				<< "\tparameter CN_ROM_RD_BW = 6," << endl
				<< "\tparameter CN_ROM_ADDR_BW = 10," << endl
				<< "\tparameter CN_PAGE_ADDR_BW = 5," << endl
				<< "\tparameter CN_DEGREE = 6," << endl
				<< "\tparameter IB_CNU_DECOMP_funNum = 4," << endl
				<< "\tparameter CN_NUM = 102," << endl
				<< "\tparameter CNU6_INSTANTIATE_NUM = 51," << endl
				<< "\tparameter CNU6_INSTANTIATE_UNIT = 2," << endl				
				<< "\tparameter QUAN_SIZE = 4," << endl
				<< "\tparameter DATAPATH_WIDTH = 4" << endl
				<< ") (" << endl;

	cnu_wrapper << "\toutput wire read_addr_offset_out," << endl;
	for(unsigned int i = 0; i < M; i++) {
		for(unsigned int j = 0; j < max_dc; j++) {
			cnu_wrapper << "\toutput wire [DATAPATH_WIDTH-1:0] c2v_" << i << "_out" << j << "," << endl;
		}
	}
	cnu_wrapper << endl;
	for(unsigned int i = 0; i < M; i++) {
		for(unsigned int j = 0; j < max_dc; j++) {
			cnu_wrapper << "\tinput wire [DATAPATH_WIDTH-1:0] v2c_" << i << "_in" << j << "," << endl;
		}
	}
	cnu_wrapper << endl 
				<< "\tinput wire read_clk," << endl
				<< "\tinput wire read_addr_offset," << endl
				<< "\tinput wire v2c_latch_en," << endl
				<< "\tinput wire v2c_parallel_load," << endl
				<< endl;

	cnu_wrapper << "\t// Iteration-Refresh Page Address" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) cnu_wrapper << "\tinput wire [CN_PAGE_ADDR_BW+1-1:0] page_addr_ram_" << j << "," << endl;
	
	cnu_wrapper << "\t//Iteration-Refresh Page Data" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) {
		cnu_wrapper << "\tinput wire [CN_ROM_RD_BW-1:0] ram_write_dataA_" << j << ", // from portA of IB-ROM" << endl;
		cnu_wrapper << "\tinput wire [CN_ROM_RD_BW-1:0] ram_write_dataB_" << j << ", // from portB of IB-ROM" << endl;
	}

	cnu_wrapper << endl;
	cnu_wrapper << "\tinput wire [" << cnu_decompose_num-1 << ":0] ib_ram_we," << endl
	            << "\tinput wire write_clk" << endl
				<< ");";

	cnu_wrapper << endl;
	cnu_wrapper << "// Input sources of check node units" << endl;
	for(unsigned int i = 0; i < max_dc; i++) 
		cnu_wrapper << "wire [QUAN_SIZE-1:0] v2c_" << i << " [0:CN_NUM-1];" << endl;
	cnu_wrapper << "// Output sources of check node units" << endl;
	for(unsigned int i = 0; i < max_dc; i++) 
		cnu_wrapper << "wire [QUAN_SIZE-1:0] c2v_" << i << " [0:CN_NUM-1];" << endl;
	cnu_wrapper << "// Address related signals including the Net type" << endl;
	cnu_wrapper << "wire [CN_DEGREE-2-1-1:0] read_addr_offset_internal [0:CNU6_INSTANTIATE_NUM-1];" << endl
		    << "wire [CNU6_INSTANTIATE_NUM-1:0]read_addr_offset_outSet;" << endl
		    << endl;

	
	// Appending the template of CNU cascading instantiation
	while(getline(cnu_template, str)) cnu_wrapper << str << endl;

	cnu_wrapper << endl;
	for(unsigned int i = 0; i < M; i++) {
		for(unsigned int j = 0; j < max_dc; j++) {
			cnu_wrapper << "assign c2v_" << i << "_out" << j << "[QUAN_SIZE-1:0] = c2v_" << j << "[" << i << "];" << endl;
			cnu_wrapper << "assign v2c_" << j << "[" << i << "] = v2c_" << i << "_in" << j << "[QUAN_SIZE-1:0];" << endl;
		}
	}
	cnu_wrapper << "endmodule";
	cnu_wrapper.close(); cnu_template.close();
//========================================================================================================================//
	// Wrapper of VNU and DNU
	ofstream vnu_wrapper;
	ifstream vnu_template;

	vnu_wrapper.open(vnu_ib_ram_wrapper_filename);
	vnu_template.open(vnu3_ib_ram_cascade_template_filename);
	vnu_wrapper << "module vnu" << max_dv << "_ib_ram_wrapper #(" << endl
				<< "\tparameter VN_ROM_RD_BW = 8," << endl
				<< "\tparameter VN_ROM_ADDR_BW = 11," << endl
				<< "\tparameter VN_PAGE_ADDR_BW = 6," << endl
				<< "\tparameter DN_ROM_RD_BW = 8," << endl
				<< "\tparameter DN_ROM_ADDR_BW = 11," << endl	
				<< "\tparameter DN_PAGE_ADDR_BW = 6," << endl
				<< "\tparameter VN_DEGREE = 3," << endl
				<< "\tparameter IB_VNU_DECOMP_funNum = 2," << endl
				<< "\tparameter VN_NUM = 204," << endl
				<< "\tparameter VNU3_INSTANTIATE_NUM = 51," << endl
				<< "\tparameter VNU3_INSTANTIATE_UNIT = 4," << endl
				<< "\tparameter QUAN_SIZE = 4," << endl
				<< "\tparameter DATAPATH_WIDTH = 4" << endl
				<< ") (" << endl;

	vnu_wrapper << "\toutput wire read_addr_offset_out," << endl;
	for(unsigned int i = 0; i < N; i++) {
		vnu_wrapper << "\toutput wire hard_decision_" << i << "," << endl;
		for(unsigned int j = 0; j < max_dv; j++) {
			vnu_wrapper << "\toutput wire [DATAPATH_WIDTH-1:0] v2c_" << i << "_out" << j << "," << endl;
		}
	}
	vnu_wrapper << endl;
	for(unsigned int i = 0; i < N; i++) {
		vnu_wrapper << "\tinput wire [DATAPATH_WIDTH-1:0] ch_msg_" << i << "," << endl;
		for(unsigned int j = 0; j < max_dv; j++) {
			vnu_wrapper << "\tinput wire [DATAPATH_WIDTH-1:0] c2v_" << i << "_in" << j << "," << endl;
		}
	}
	vnu_wrapper << endl 
				<< "\tinput wire read_clk," << endl
				<< "\tinput wire read_addr_offset," << endl
				<< "\tinput wire c2v_latch_en," << endl
				<< "\tinput wire c2v_parallel_load," << endl
				<< "\tinput wire v2c_src," << endl
				<< endl;

	vnu_wrapper << "\t// Iteration-Refresh Page Address" << endl;
	/*The last loop iteratin is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num) 
			vnu_wrapper << "\tinput wire [DN_PAGE_ADDR_BW+1-1:0] page_addr_ram_" << j << ", // the last one is for decision node" << endl;
		else
			vnu_wrapper << "\tinput wire [VN_PAGE_ADDR_BW+1-1:0] page_addr_ram_" << j << "," << endl;
	}

	vnu_wrapper << "\t//Iteration-Refresh Page Data" << endl;
	/*The last loop iteration is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num)
			vnu_wrapper << "\tinput wire [DN_ROM_RD_BW-1:0] ram_write_dataA_" << j << ", // from portA of IB-ROM (for decision node)" << endl;
		else
			vnu_wrapper << "\tinput wire [VN_ROM_RD_BW-1:0] ram_write_dataA_" << j << ", // from portA of IB-ROM" << endl;

		if(j == vnu_decompose_num)
			vnu_wrapper << "\tinput wire [DN_ROM_RD_BW-1:0] ram_write_dataB_" << j << ", // from portA of IB-ROM (for decision node)" << endl;
		else
			vnu_wrapper << "\tinput wire [VN_ROM_RD_BW-1:0] ram_write_dataB_" << j << ", // from portA of IB-ROM" << endl;
	}

	vnu_wrapper << endl;
	/*The last loop iteration is for DNU*/
	vnu_wrapper << "\tinput wire [" << vnu_decompose_num << ":0] ib_ram_we," << endl
	            << "\tinput wire vn_write_clk," << endl
				<< "\tinput wire dn_write_clk" << endl
				<< ");";

	vnu_wrapper << endl;
	vnu_wrapper << "// Input sources of vaiable node units" << endl;
	for(unsigned int i = 0; i < max_dv; i++) 
		vnu_wrapper << "wire [QUAN_SIZE-1:0] c2v_" << i << " [0:VN_NUM-1];" << endl;
	vnu_wrapper << "wire [QUAN_SIZE-1:0] ch_msg [0:VN_NUM-1];" << endl; 
	
	vnu_wrapper << "// Output sources of check node units" << endl;
	for(unsigned int i = 0; i < max_dv; i++) 
		vnu_wrapper << "wire [QUAN_SIZE-1:0] v2c_" << i << " [0:VN_NUM-1];" << endl;
	vnu_wrapper << "wire [VN_NUM-1:0] hard_decision;" << endl;
	vnu_wrapper << "// Address related signals including the Net type" << endl;
	vnu_wrapper << "wire [VN_DEGREE+1-2-1-1:0] read_addr_offset_internal [0:VNU3_INSTANTIATE_NUM-1];" << endl
		    << "wire [VNU3_INSTANTIATE_NUM-1:0]read_addr_offset_outSet;" << endl
		    << endl;

	vnu_wrapper << endl;
	// Appending the template of VNU (along with DNU) cascading instantiation
	while(getline(vnu_template, str)) vnu_wrapper << str << endl;

	vnu_wrapper << endl;
	for(unsigned int i = 0; i < N; i++) {
		vnu_wrapper << "assign hard_decision_" << i << " = hard_decision[" << i << "];" << endl;
		vnu_wrapper << "assign ch_msg[" << i << "] = ch_msg_" << i << "[QUAN_SIZE-1:0];" << endl;
		for(unsigned int j = 0; j < max_dv; j++) {
			vnu_wrapper << "assign v2c_" << i << "_out" << j << "[QUAN_SIZE-1:0] = v2c_" << j << "[" << i << "];" << endl;
			vnu_wrapper << "assign c2v_" << j << "[" << i << "] = c2v_" << i << "_in" << j << "[QUAN_SIZE-1:0];" << endl;
		}
	}
	vnu_wrapper << "endmodule";
	vnu_wrapper.close(); vnu_template.close();
//========================================================================================================================//
	// Wrapping up the CNUs, VNUs and DNUs IB-RAM wrappers into one module
	// The Interface:
	// Input: N channel messages each of which is Q-bit
	// Output: N hard decisions each of which is 1-bit
	ofstream proc_wrapper;
	proc_wrapper.open(ib_proc_wrapper_filename);
	proc_wrapper << "module ib_proc_wrapper #(" << endl
				 << "\tparameter CN_ROM_RD_BW = 6," << endl
				 << "\tparameter CN_ROM_ADDR_BW = 10," << endl
				 << "\tparameter CN_PAGE_ADDR_BW = 5," << endl
				 << "\tparameter CN_DEGREE = 6," << endl
				 << "\tparameter IB_CNU_DECOMP_funNum = 4," << endl
				 << "\tparameter CN_NUM = 102," << endl
				 << "\tparameter CNU6_INSTANTIATE_NUM = 51," << endl
				 << "\tparameter CNU6_INSTANTIATE_UNIT = 2," << endl				
				 << endl	
				 << "\tparameter VN_ROM_RD_BW = 8," << endl
				 << "\tparameter VN_ROM_ADDR_BW = 11," << endl
				 << "\tparameter VN_PAGE_ADDR_BW = 6," << endl
				 << "\tparameter DN_ROM_RD_BW = 8," << endl
				 << "\tparameter DN_ROM_ADDR_BW = 11," << endl	
				 << "\tparameter DN_PAGE_ADDR_BW = 6," << endl
				 << "\tparameter VN_DEGREE = 3," << endl
				 << "\tparameter IB_VNU_DECOMP_funNum = 2," << endl
				 << "\tparameter VN_NUM = 204," << endl
				 << "\tparameter VNU3_INSTANTIATE_NUM = 51," << endl
				 << "\tparameter VNU3_INSTANTIATE_UNIT = 4," << endl
				 << "\tparameter QUAN_SIZE = 4," << endl
				 << "\tparameter MSG_WIDTH = 4," << endl
				 << "\tparameter DATAPATH_WIDTH = 4" << endl
				 << ") (" << endl;
	
	proc_wrapper << "\toutput wire [VN_NUM-1:0] hard_decision," << endl << endl;
	for(unsigned int i = 0; i < N; i++) proc_wrapper << "\tinput wire [DATAPATH_WIDTH-1:0] ch_msg_" << i << "," << endl;
	proc_wrapper << "\tinput wire read_clk," << endl
				 << "\tinput wire cnu_read_addr_offset," << endl
				 << "\tinput wire vnu_read_addr_offset," << endl
				 << "\tinput wire v2c_latch_en," << endl
				 << "\tinput wire c2v_latch_en," << endl
				 << "\tinput wire v2c_src," << endl
				 << "\tinput wire [1:0] parallel_en," << endl
				 << "\tinput wire [1:0] load," << endl
				 << endl
				 << "\t// Iteration-Refresh Page Address" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) 
		proc_wrapper << "\tinput wire [CN_PAGE_ADDR_BW+1-1:0] cnu_page_addr_ram_" << j << ", // the MSB decides refreshed target, i.e., upper page group or lower page group" << endl;
	/*The last loop iteratin is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		proc_wrapper << "\tinput wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_" << j << ", // the MSB decides refreshed target, i.e., upper page group or lower page group";
		if(j == vnu_decompose_num) proc_wrapper << " // the last one is for decision node" << endl;
		else proc_wrapper << endl;
	}	
	
	proc_wrapper << "\t//Iteration-Refresh Page Data" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) {
		proc_wrapper << "\tinput wire [CN_ROM_RD_BW-1:0] cnu_ram_write_dataA_" << j << ", // from portA of IB-ROM" << endl;
		proc_wrapper << "\tinput wire [CN_ROM_RD_BW-1:0] cnu_ram_write_dataB_" << j << ", // from portB of IB-ROM" << endl;
	}
	/*The last loop iteration is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num)
			proc_wrapper << "\tinput wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataA_" << j << ", // from portA of IB-ROM (for decision node)" << endl;
		else
			proc_wrapper << "\tinput wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_" << j << ", // from portA of IB-ROM" << endl;

		if(j == vnu_decompose_num)
			proc_wrapper << "\tinput wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataB_" << j << ", // from portB of IB-ROM (for decision node)" << endl;
		else
			proc_wrapper << "\tinput wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_" << j << ", // from portB of IB-ROM" << endl;

	}
	
	proc_wrapper << endl;
	proc_wrapper << "\tinput wire [" << cnu_decompose_num-1 << ":0] cnu_ib_ram_we," << endl;
	proc_wrapper << "\tinput wire [" << vnu_decompose_num << ":0] vnu_ib_ram_we," << endl; 	/*The last loop iteration is for DNU*/
	proc_wrapper << "\tinput wire cn_write_clk," << endl
				 << "\tinput wire vn_write_clk," << endl
				 << "\tinput wire dn_write_clk" << endl
	             << ");" << endl;

	proc_wrapper << endl 
				 << "// Net-type interfaces (direction is RouteNetworkModule-centric)" << endl
				 << "//        -------" << endl
				 << "//       |  cnu  |" << endl
				 << "//        -------" << endl
				 << "//         |  ^        " << endl
				 << "// c2v_in  |  | v2c_out" << endl
				 << "//         v  |        " << endl
				 << "//       ----------"  << endl
				 << "//      |   Route  |" << endl
				 << "//      | __    __ |" << endl
				 << "//      |   \\  /   |" << endl
				 << "//      |    \\/    |" << endl
				 << "//      |    /\\    |" << endl
				 << "//      | __/  \\__ |" << endl
				 << "//       -----------"  << endl
				 << "//          |  ^       " << endl
				 << "// c2v_out  |  | v2c_in" << endl
				 << "//          v  |       " << endl
				 << "//         -------" << endl
				 << "//        |  vnu  |" << endl
				 << "//         -------" << endl;				 
	for(unsigned int j = 0; j < max_dc; j++) {
		proc_wrapper << "wire [DATAPATH_WIDTH-1:0] c2v_" << "in"  << j << " [0:CN_NUM-1];" << endl;
		proc_wrapper << "wire [DATAPATH_WIDTH-1:0] v2c_" << "out" << j << " [0:CN_NUM-1];" << endl;
	}
	for(unsigned int j = 0; j < max_dv; j++) {
		proc_wrapper << "wire [DATAPATH_WIDTH-1:0] c2v_" << "out" << j << " [0:VN_NUM-1]; " << endl;
		proc_wrapper << "wire [DATAPATH_WIDTH-1:0] v2c_" << "in"  << j << " [0:VN_NUM-1];" << endl;
	}

	proc_wrapper << endl << "// Instantiation of CNU IB-RAM wrapper" << endl
	             << "cnu" << max_dc << "_ib_ram_wrapper #(" << endl
				 << "\t.CN_ROM_RD_BW          (CN_ROM_RD_BW         )," << endl
				 << "\t.CN_ROM_ADDR_BW        (CN_ROM_ADDR_BW       )," << endl
				 << "\t.CN_PAGE_ADDR_BW       (CN_PAGE_ADDR_BW      )," << endl
				 << "\t.CN_DEGREE	          (CN_DEGREE            )," << endl
				 << "\t.IB_CNU_DECOMP_funNum  (IB_CNU_DECOMP_funNum )," << endl
				 << "\t.CN_NUM                (CN_NUM               )," << endl
				 << "\t.CNU6_INSTANTIATE_NUM  (CNU6_INSTANTIATE_NUM )," << endl
				 << "\t.CNU6_INSTANTIATE_UNIT (CNU6_INSTANTIATE_UNIT)," << endl
				 << "\t.QUAN_SIZE             (QUAN_SIZE            )," << endl
				 << "\t.DATAPATH_WIDTH        (DATAPATH_WIDTH       )" << endl
				 << ") cnu_ib_ram_wrapper_u0 (" << endl;
	for(unsigned int i = 0; i < M; i++) {
		for(unsigned int j = 0; j < max_dc; j++) {
			proc_wrapper << "\t.c2v_" << i << "_out" << j << "(c2v_in" << j << "[" << i << "])," << endl;
		}
	}
	proc_wrapper << endl;
	for(unsigned int i = 0; i < M; i++) {
		for(unsigned int j = 0; j < max_dc; j++) {
			proc_wrapper << "\t.v2c_" << i << "_in" << j << "(v2c_out" << j << "[" << i << "])," << endl;
		}
	}
	proc_wrapper << endl 
				<< "\t.read_clk (read_clk)," << endl
				<< "\t.read_addr_offset (cnu_read_addr_offset)," << endl
				<< "\t.v2c_latch_en (v2c_latch_en)," << endl
				<< "\t.v2c_parallel_load (load[1])," << endl
				<< endl;

	proc_wrapper << "\t// Iteration-Refresh Page Address" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) proc_wrapper << "\t.page_addr_ram_" << j << "(cnu_page_addr_ram_" << j << "[CN_PAGE_ADDR_BW+1-1:0])," << endl;
	proc_wrapper << "\t//Iteration-Refresh Page Data" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) {
		proc_wrapper << "\t. ram_write_dataA_" << j << " (cnu_ram_write_dataA_" << j << "[CN_ROM_RD_BW-1:0]), // from portA of IB-ROM" << endl;
		proc_wrapper << "\t. ram_write_dataB_" << j << " (cnu_ram_write_dataB_" << j << "[CN_ROM_RD_BW-1:0]), // from portB of IB-ROM" << endl;
	}
	proc_wrapper << "\t.ib_ram_we (cnu_ib_ram_we[IB_CNU_DECOMP_funNum-1:0])," << endl
		     << "\t.write_clk (cn_write_clk)" << endl
				 << ");" << endl << endl;	
	
	proc_wrapper << "// Instantiation of VNU IB-RAM wrapper" << endl;
	proc_wrapper << "vnu" << max_dv << "_ib_ram_wrapper #(" << endl
				 << "\t.VN_ROM_RD_BW          (VN_ROM_RD_BW          )," << endl
				 << "\t.VN_ROM_ADDR_BW        (VN_ROM_ADDR_BW        )," << endl
				 << "\t.VN_PAGE_ADDR_BW       (VN_PAGE_ADDR_BW       )," << endl
				 << "\t.DN_ROM_RD_BW          (DN_ROM_RD_BW          )," << endl
				 << "\t.DN_ROM_ADDR_BW        (DN_ROM_ADDR_BW        )," << endl
				 << "\t.DN_PAGE_ADDR_BW       (DN_PAGE_ADDR_BW       )," << endl
				 << "\t.VN_DEGREE             (VN_DEGREE             )," << endl
				 << "\t.IB_VNU_DECOMP_funNum  (IB_VNU_DECOMP_funNum  )," << endl
				 << "\t.VN_NUM                (VN_NUM                )," << endl
				 << "\t.VNU3_INSTANTIATE_NUM  (VNU3_INSTANTIATE_NUM  )," << endl
				 << "\t.VNU3_INSTANTIATE_UNIT (VNU3_INSTANTIATE_UNIT )," << endl
				 << "\t.QUAN_SIZE             (QUAN_SIZE             )," << endl
				 << "\t.DATAPATH_WIDTH        (DATAPATH_WIDTH        )" << endl
				 << ") vnu_ib_ram_wrapper_u0(" << endl;	
	for(unsigned int i = 0; i < N; i++) {
		proc_wrapper << "\t.hard_decision_" << i << " (hard_decision[" << i << "])," << endl;
		for(unsigned int j = 0; j < max_dv; j++) {
			proc_wrapper << "\t.v2c_" << i << "_out" << j << " (v2c_in" << j << "[" << i << "])," << endl;
		}
	}
	proc_wrapper << endl;
	for(unsigned int i = 0; i < N; i++) {
		proc_wrapper << "\t.ch_msg_" << i << " (ch_msg_" << i << "[DATAPATH_WIDTH-1:0]),"<< endl;
		for(unsigned int j = 0; j < max_dv; j++) {
			proc_wrapper << "\t.c2v_" << i << "_in" << j << " (c2v_out" << j << "[" << i << "]),"<< endl;
		}
	}	
//========================================================================================================================//
	proc_wrapper << endl 
				<< "\t.read_clk (read_clk)," << endl
				<< "\t.read_addr_offset (vnu_read_addr_offset)," << endl
				<< "\t.v2c_src (v2c_src)," << endl
				<< "\t.c2v_latch_en (c2v_latch_en)," << endl
				<< "\t.c2v_parallel_load (load[0])," << endl
				<< endl;

	proc_wrapper << "\t// Iteration-Refresh Page Address" << endl;
	/*The last loop iteratin is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num) 
			proc_wrapper << "\t.page_addr_ram_" << j << " (vnu_page_addr_ram_" << j << "[DN_PAGE_ADDR_BW+1-1:0]), // the last one is for decision node" << endl;
		else 
			proc_wrapper << "\t.page_addr_ram_" << j << " (vnu_page_addr_ram_" << j << "[VN_PAGE_ADDR_BW+1-1:0])," << endl;
	}

	proc_wrapper << "\t//Iteration-Refresh Page Data" << endl;
	/*The last loop iteration is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num)
			proc_wrapper << "\t.ram_write_dataA_" << j << " (vnu_ram_write_dataA_" << j << "[DN_ROM_RD_BW-1:0]), // from portA of IB-ROM (for decision node)" << endl;
		else
			proc_wrapper << "\t.ram_write_dataA_" << j << " (vnu_ram_write_dataA_" << j << "[VN_ROM_RD_BW-1:0]), // from portA of IB-ROM" << endl;
	
		if(j == vnu_decompose_num)
			proc_wrapper << "\t.ram_write_dataB_" << j << " (vnu_ram_write_dataB_" << j << "[DN_ROM_RD_BW-1:0]), // from portB of IB-ROM (for decision node)" << endl;
		else
			proc_wrapper << "\t.ram_write_dataB_" << j << " (vnu_ram_write_dataB_" << j << "[VN_ROM_RD_BW-1:0]), // from portB of IB-ROM" << endl;
	}
	/*The last loop iteration is for DNU*/
	proc_wrapper << "\t.ib_ram_we (vnu_ib_ram_we[IB_VNU_DECOMP_funNum:0])," << endl
		     << "\t.vn_write_clk (vn_write_clk)," << endl
				 << "\t.dn_write_clk (dn_write_clk)" << endl
				 << ");" << endl << endl;
//========================================================================================================================//	
	ifstream route_inst_template;
	route_inst_template.open(fully_parallel_filename);
	proc_wrapper << endl << " // Instatiation of Routing Network and Port Mapping" << endl;
	// Appending the template of routing network instantiation source file
	while(getline(route_inst_template, str)) proc_wrapper << str << endl;	 
	proc_wrapper << "endmodule";
	route_inst_template.close();
	proc_wrapper.close();
}

void verilog_gen::ib_ram_wrapper_instantiate()
{
	ofstream proc_port;
	proc_port.open(ib_ram_wrapper_port_filename);
	// The Nets required being generated are:
	// a) N-bit hard deicion
	// b) N number of Q-bit channel messages
	//proc_port << "wire [VN_NUM-1:0] hard_decision;" << endl
	//		  << "wire [QUAN_SIZE-1:0] ch_msg [0:VN_NUM-1];" << endl;
			  
	proc_port << "ib_proc_wrapper #(" << endl
			  << "\t.CN_ROM_RD_BW          (CN_ROM_RD_BW         )," << endl
			  << "\t.CN_ROM_ADDR_BW        (CN_ROM_ADDR_BW       )," << endl
			  << "\t.CN_PAGE_ADDR_BW       (CN_PAGE_ADDR_BW      )," << endl
			  << "\t.CN_DEGREE             (CN_DEGREE            )," << endl
			  << "\t.IB_CNU_DECOMP_funNum  (IB_CNU_DECOMP_funNum )," << endl
			  << "\t.CN_NUM                (CN_NUM               )," << endl
			  << "\t.CNU6_INSTANTIATE_NUM  (CNU6_INSTANTIATE_NUM )," << endl
			  << "\t.CNU6_INSTANTIATE_UNIT (CNU6_INSTANTIATE_UNIT)," << endl				
			  << endl	
			  << "\t.VN_ROM_RD_BW          (VN_ROM_RD_BW         )," << endl
			  << "\t.VN_ROM_ADDR_BW        (VN_ROM_ADDR_BW       )," << endl
			  << "\t.VN_PAGE_ADDR_BW       (VN_PAGE_ADDR_BW      )," << endl
			  << "\t.DN_ROM_RD_BW          (DN_ROM_RD_BW         )," << endl
			  << "\t.DN_ROM_ADDR_BW        (DN_ROM_ADDR_BW       )," << endl
			  << "\t.DN_PAGE_ADDR_BW       (DN_PAGE_ADDR_BW      )," << endl
			  << "\t.VN_DEGREE             (VN_DEGREE            )," << endl
			  << "\t.IB_VNU_DECOMP_funNum  (IB_VNU_DECOMP_funNum )," << endl
			  << "\t.VN_NUM                (VN_NUM               )," << endl
			  << "\t.VNU3_INSTANTIATE_NUM  (VNU3_INSTANTIATE_NUM )," << endl
			  << "\t.VNU3_INSTANTIATE_UNIT (VNU3_INSTANTIATE_UNIT)," << endl
			  << "\t.QUAN_SIZE             (QUAN_SIZE            )," << endl
			  << "\t.DATAPATH_WIDTH        (DATAPATH_WIDTH       )"<< endl
			  << ") ib_proc_u0 (" << endl;
	
	proc_port << "\t.hard_decision (hard_decision[VN_NUM-1:0])," << endl << endl;
	for(unsigned int i = 0; i < N; i++) proc_port << "\t.ch_msg_" << i << " (ch_msg_" << i << "[QUAN_SIZE-1:0])," << endl;
	proc_port << "\t.read_clk (read_clk)," << endl
				 << "\t.cnu_read_addr_offset (cnu_read_addr_offset)," << endl
				 << "\t.vnu_read_addr_offset (vnu_read_addr_offset)," << endl
				 << "\t.v2c_src (v2c_src[0])," << endl
				 << "\t.load({v2c_load[0], c2v_load[0]})," << endl
				 << "\t.parallel_en({v2c_msg_en[0], c2v_msg_en[0]})," << endl
				 << endl
				 << "\t// Iteration-Refresh Page Address" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) 
		proc_port << "\t.cnu_page_addr_ram_" << j << " ({1'b0, cn_wr_page_addr[" << j <<"]})," << endl;
	/*The last loop iteratin is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num) 
			proc_port << "\t.vnu_page_addr_ram_" << j << " ({1'b0, dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]}), // the last one is for decision node" << endl;
		else 
			proc_port << "\t.vnu_page_addr_ram_" << j << " ({1'b0, vn_wr_page_addr[" << j << "]})," << endl;
	}	
	
	proc_port << "\t//Iteration-Refresh Page Data" << endl;
	for(unsigned int j = 0; j < cnu_decompose_num; j++) {
		proc_port << "\t.cnu_ram_write_dataA_" << j << " (cn_latch_outA[" << j << "]), // from portA of IB-ROM" << endl;
		proc_port << "\t.cnu_ram_write_dataB_" << j << " (cn_latch_outB[" << j << "]), // from portB of IB-ROM" << endl;
	}
	/*The last loop iteration is for DNU*/
	for(unsigned int j = 0; j < vnu_decompose_num+1; j++) {
		if(j == vnu_decompose_num)
			proc_port << "\t.vnu_ram_write_dataA_" << j << " (dn_latch_outA[DN_ROM_RD_BW-1:0]), // from portA of IB-ROM (for decision node)" << endl;
		else
			proc_port << "\t.vnu_ram_write_dataA_" << j << " (vn_latch_outA[" << j << "]), // from portA of IB-ROM" << endl;

		if(j == vnu_decompose_num)
			proc_port << "\t.vnu_ram_write_dataB_" << j << " (dn_latch_outB[DN_ROM_RD_BW-1:0]), // from portB of IB-ROM (for decision node)" << endl;
		else
			proc_port << "\t.vnu_ram_write_dataB_" << j << " (vn_latch_outB[" << j << "]), // from portB of IB-ROM" << endl;
	}
	
	proc_port << endl
			  << "\t.cnu_ib_ram_we (cn_ram_write_en[IB_CNU_DECOMP_funNum-1:0])," << endl
			  << "\t.vnu_ib_ram_we ({dn_ram_write_en, vn_ram_write_en[IB_VNU_DECOMP_funNum-1:0]})," << endl
			  << "\t.cn_write_clk (cn_write_clk)," << endl
			  << "\t.vn_write_clk (vn_write_clk)," << endl
			  << "\t.dn_write_clk (dn_write_clk)" << endl
	          << ");" << endl;
	proc_port.close();
}
