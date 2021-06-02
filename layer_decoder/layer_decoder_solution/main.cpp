#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include <vector>
#include <algorithm>
#include <iterator>
#include <fstream>
#include <string>
#include <sstream>
#include <bitset>
//#include <ctime>

using namespace std;
#define DEBUG
#define DISPLAY_DEVICE_AND_PAGE_ADDR
//#define DISPLAY_DEVICE_SELECTION_ONLY
//#define DISPLAY_PAGE_ADDR_ONLY


// H/W configuration
unsigned int BW_bram=20;
unsigned int port_num=2;
uint8_t q = 4; // 4-bit precision

// PCM feature
#define N 10
#define dc 10
#define dv 3
#define layer_num 3
#define z 765
#define Pc 85
unsigned int inLayer_cnt = z/Pc;
unsigned int v2c_base;
unsigned int s[layer_num][dc] = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 656, 76, 132, 184, 233, 216, 490, 714, 715},
	{0, 22, 650, 359, 587, 65, 463, 635, 91, 100}
};
unsigned int C_index[N*z];
unsigned int col_size;

// Page alignment configuration
enum {
	ONE_DELAY = 0,
	TWO_DELAY = 1
};
#define PAGE_ALIGN_TYPE_NUM 2 // number of page alignment types, e.g., one-delay and two-delay insertion
typedef vector<unsigned int> page_align_set_t;
typedef struct circular_page_t {
	unsigned int PA[layer_num][dc];
	unsigned int DS[layer_num][dc];
} circular_page;
string **circular_cmd_logic;

typedef struct layer_module {
	unsigned int *C_index;
	unsigned int *DS; // device selection
	unsigned int *PA; // page address

	unsigned int *shift_factor; 
	//unsigned int ***page_align_set;
	page_align_set_t **page_align_set;
} Layer_Module;
Layer_Module *layer;
char hdl_filename[50] = "page_align_";
void sys_init();
void var_mem_init();
void mux_insert_set(unsigned int layer_a, unsigned int *mux_num, unsigned int **mux_loc_set);
//void mux_insert_set(unsigned int layer_a, unsigned int layer_b, unsigned int *mux_num, unsigned int **mux_loc_set);
void delay_set_construct(unsigned int sub_matrix_id, unsigned int delay_type, unsigned int target_set_size, unsigned int target_start_loc, Layer_Module *target_layer, bool isExcption);
void page_align_hdl_gen(unsigned int submatrix_id, unsigned int align_cmd_num, vector<unsigned int> *delay_cmd);
void critical_delay_set_construct(unsigned int base_set_id, vector<unsigned int> *base_set, vector<unsigned int> *critical_set_ref, vector<unsigned int> *critical_set);
void circular_page_align_cmd_gen(unsigned int align_cmd_num, vector<unsigned int> base_delay_cmd, vector<unsigned int> *critical_set, vector<unsigned int> *circular_delay_cmd);
void circular_page_align_hdl_gen(unsigned int base_set_id, unsigned int submatrix_id, unsigned align_cmd_num, vector<unsigned int> *circular_delay_cmd);
unsigned int msg_to_mem_bankAddr(unsigned int mem_bank_num, unsigned int shift_factor, unsigned int msg_addr);
void v2c_msg_pass_test_pattern(unsigned int submatrix_id);
//bool v2c_msg_pass_verification();

int main(int argc, char **argv)
{
	// Unrolling dual-port bitwidth to a (virtual) single-port bitwidth for ease of following address determination
	BW_bram=BW_bram*port_num;
	sys_init();
	var_mem_init();
	unsigned int row_chunk_cnt;

	ofstream log_fd[dc]; char *log_filename;
	for(int i = 0; i < layer_num; i++) {
#ifdef DEBUG
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl
		     << "Layer " << i << endl;
#endif
		// Determining the memory device selection/address
		unsigned int pcm_col;
		int interLayer_offset, layer_0_shift, layer_1_shift;
		for(int sub_matrix_id = 0; sub_matrix_id < dc; sub_matrix_id++) {
			if(i == 0) {
				log_filename = new char [50];
				sprintf(log_filename, "submatrix_col_%d.log.txt", sub_matrix_id);
				log_fd[sub_matrix_id].open(log_filename, ofstream::out | ofstream::app);
				delete [] log_filename;
			}
#ifdef DEBUG
			cout << endl << endl << "Sub-Matrix_" << sub_matrix_id << ":" << endl << "(DS, PA)" << endl;
			log_fd[sub_matrix_id] << "Layer_" << i << ", Sub-Matrix_" << sub_matrix_id << ":" << endl << "(DS, PA)" << endl;
#endif
			layer_0_shift = (int) s[i][sub_matrix_id];
			layer_1_shift = (int) s[(i+1) % layer_num][sub_matrix_id];
			interLayer_offset = abs((int) ((z-layer_0_shift) % Pc) - (int) ((z-layer_1_shift) % Pc));
			layer[i].shift_factor[sub_matrix_id] = interLayer_offset;
#ifdef DEBUG	
			cout << "Shift Factor: " << interLayer_offset << endl;
#endif
			row_chunk_cnt = 0;
			for(int col = 0; col < z; col++) {
				pcm_col = (sub_matrix_id*z)+col;
				layer[i].DS[pcm_col] = ((col % (unsigned int) Pc)+interLayer_offset) % Pc;
				layer[i].PA[pcm_col] = (unsigned int) floor((z-layer_1_shift+col+layer_0_shift)/Pc) % inLayer_cnt;
#ifdef DEBUG
				if((col % Pc) == 0) {
					cout << endl << "Row Chunk_" << row_chunk_cnt << endl;
					log_fd[sub_matrix_id] << endl << "Row Chunk_" << row_chunk_cnt << endl;
					row_chunk_cnt+=1;
				}

				#ifdef DISPLAY_DEVICE_AND_PAGE_ADDR
					cout << "(" << layer[i].DS[pcm_col] << ", " << layer[i].PA[pcm_col] << ") ";
					log_fd[sub_matrix_id] << "(" << layer[i].DS[pcm_col] << ", " << layer[i].PA[pcm_col] << ") ";
				#endif

				#ifdef DISPLAY_DEVICE_SELECTION_ONLY
					cout << std::dec << layer[i].DS[pcm_col];
					log_fd[sub_matrix_id] << layer[i].DS[pcm_col];
					if(col % 10 == 0) {
						cout << endl;
						log_fd[sub_matrix_id] << endl;
					}
					else { 
						cout << " ";
						log_fd[sub_matrix_id] << " ";
					}
				#endif

				#ifdef DISPLAY_PAGE_ADDR_ONLY
					if(sub_matrix_id > 0) {
						cout << layer[i].PA[pcm_col];
						log_fd[sub_matrix_id] << layer[i].PA[pcm_col];
						if((col % Pc == 0 || col % 10 == 0) && col != 0) {
							cout << endl;
							log_fd[sub_matrix_id] << endl;
						}
						else {
							cout << " ";
							log_fd[sub_matrix_id] << " ";
						}
					}
				#endif
#endif
			}
		}
	}

	unsigned int **mux_num = new unsigned int* [layer_num];
	unsigned int ***mux_loc_set = new unsigned int** [layer_num];
	bool isExcption;
	circular_page circular_page_ptr;
	for(int i = 0; i < layer_num; i++) {
		unsigned int layer_a = i, layer_b = (i+1) % layer_num;
		mux_num[i] = new unsigned int[dc];
		mux_loc_set[i] = new unsigned int* [dc];
		for(int j = 0; j < dc; j++) mux_loc_set[i][j] = new unsigned int[2];
		mux_insert_set(layer_a, mux_num[i], mux_loc_set[i]);

		layer[i].page_align_set = new page_align_set_t* [dc];
		for(unsigned int k = 0; k < dc; k++) {
			if(k != 0) {
				// Construction of one- and two-delay insertion sets of all layers
				layer[i].page_align_set[k] = new page_align_set_t [PAGE_ALIGN_TYPE_NUM];	
				unsigned int delay_set_size[PAGE_ALIGN_TYPE_NUM]; 
				delay_set_size[0] = Pc-mux_num[i][k]; delay_set_size[1] = mux_num[i][k];
				for(unsigned int align_type = 0; align_type < PAGE_ALIGN_TYPE_NUM; align_type++) {
					// There is one exception leads to different identification of mux location
					// E.g., a zero shift factor on next layer
					if(s[layer_b][k] == 0) isExcption = true;
					else isExcption = false;
					delay_set_construct(
								k,
								align_type, 
								delay_set_size[align_type],
								mux_loc_set[i][k][align_type],
								&layer[i],
								isExcption
					);
					
#ifdef DEBUG
					log_fd[k] << endl << "Layer_" << i << " -> " << align_type+1 << "-delay insertion set:" << endl << "{";
					cout << endl << "Layer_" << i << " -> " << align_type+1 << "-delay insertion set:" << endl << "{";
					//for(unsigned int l = 0; l < delay_set_size[align_type]; l++) 
					//	cout << layer[i].page_align_set[k][align_type][l] << " ";
					vector<unsigned int>::iterator align_msg;
					for(align_msg = layer[i].page_align_set[k][align_type].begin(); align_msg != layer[i].page_align_set[k][align_type].end(); align_msg++) {
						cout << *align_msg << " ";
						log_fd[k] << *align_msg << " ";
					}
					cout << "}" << endl; 
					log_fd[k] << "}" << endl; 
#endif
				}

				// To find the starting point of msg among Pc whaich have to be especially delayed by (z/Pc) cycles instead of one cycle delay insertion
				circular_page_ptr.DS[i][k] = mux_loc_set[i][k][ONE_DELAY]; 
				circular_page_ptr.PA[i][k] = layer[i].PA[(k+1)*z-1];
			}
		}
	}

	// Construction of delay commands
	cout << "----------------------------------------------------------------------------------------------------------------------------" << endl
	     << "Construction of delay commands" << endl;
	vector<unsigned int> **delay_cmd = new vector<unsigned int>* [dc];
	vector<unsigned int> all_msg; // a dummy set including all {0, 1, ..., Pc-1} in order to perform complement of a set
	unsigned int align_cmd_num = ((unsigned int) 1) << layer_num; // there are 2^(layer_num) number of possible delay commands to be generated
	for(unsigned int temp = 0; temp < Pc; temp++) all_msg.push_back(temp);
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++) {
		delay_cmd[submatrix_id] = new vector<unsigned int> [align_cmd_num];
		// 0) Two-delay-only inseration on Layer A:
		//    set operation: (A-B)-C or (A\B)\C
		sort(layer[0].page_align_set[submatrix_id][TWO_DELAY].begin(), layer[0].page_align_set[submatrix_id][TWO_DELAY].end());
		sort(layer[1].page_align_set[submatrix_id][TWO_DELAY].begin(), layer[1].page_align_set[submatrix_id][TWO_DELAY].end());
		sort(layer[2].page_align_set[submatrix_id][TWO_DELAY].begin(), layer[2].page_align_set[submatrix_id][TWO_DELAY].end());
		vector<unsigned int> diff;
		std::set_difference(
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		); 
		sort(diff.begin(), diff.end());
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][0], end(delay_cmd[submatrix_id][0]))
		);
		vector<unsigned int>().swap(diff);
		cout << "A-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][0].size(); temp++) cout << delay_cmd[submatrix_id][0][temp] << " ";
		cout << "}" << endl;
		
		// 1) Two-delay-only inseration on Layer B:
		//    set operation: (B-A)-C
		std::set_difference(
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][1], end(delay_cmd[submatrix_id][1]))
		);
		vector<unsigned int>().swap(diff);
		cout << "B-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][1].size(); temp++) cout << delay_cmd[submatrix_id][1][temp] << " ";
		cout << "}" << endl;
		
		// 2) Two-delay-only inseration on Layer A and B:
		//    set operation: (A intersection B)\C
		std::set_intersection(
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][2], end(delay_cmd[submatrix_id][2]))
		);
		sort(delay_cmd[submatrix_id][2].begin(), delay_cmd[submatrix_id][2].end());

		vector<unsigned int>().swap(diff);
		cout << "A&B delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][2].size(); temp++) cout << delay_cmd[submatrix_id][2][temp] << " ";
		cout << "}" << endl;
		
		// 3) Two-delay-only inseration on Layer C:
		//    set operation: (C-A)-B
		std::set_difference(
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][3], end(delay_cmd[submatrix_id][3]))
		);
		sort(delay_cmd[submatrix_id][3].begin(), delay_cmd[submatrix_id][3].end());

		vector<unsigned int>().swap(diff);
		cout << "C-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][3].size(); temp++) cout << delay_cmd[submatrix_id][3][temp] << " ";
		cout << "}" << endl;
		
		// 4) Two-delay-only inseration on Layer A and C:
		//    set operation: (A intersection C)\B
		std::set_intersection(
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][4], end(delay_cmd[submatrix_id][4]))
		);
		sort(delay_cmd[submatrix_id][4].begin(), delay_cmd[submatrix_id][4].end());

		vector<unsigned int>().swap(diff);
		cout << "A&C delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][4].size(); temp++) cout << delay_cmd[submatrix_id][4][temp] << " ";
		cout << "}" << endl;
		
		// 5) Two-delay-only inseration on Layer B and C:
		//    set operation: (B intersection C)\A
		std::set_intersection(
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][5], end(delay_cmd[submatrix_id][5]))
		);
		sort(delay_cmd[submatrix_id][5].begin(), delay_cmd[submatrix_id][5].end());

		vector<unsigned int>().swap(diff);
		cout << "B&C delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][5].size(); temp++) cout << delay_cmd[submatrix_id][5][temp] << " ";
		cout << "}" << endl;
		
		// 6) Two-delay-only inseration over all layers:
		//    set operation: A iintersection B intersection C
		std::set_intersection(
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_intersection(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][6], end(delay_cmd[submatrix_id][6]))
		);
		sort(delay_cmd[submatrix_id][6].begin(), delay_cmd[submatrix_id][6].end());

		vector<unsigned int>().swap(diff);
		cout << "All-two-delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][6].size(); temp++) cout << delay_cmd[submatrix_id][6][temp] << " ";
		cout << "}" << endl;
	
		// 7) One-delay-only inseration over all layers:
		//    set operation: (A union B union C)'
		vector<unsigned int> diff1;
		std::set_union(
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]), 
					std::inserter(diff, end(diff))
		);
		sort(diff.begin(), diff.end());
		std::set_union(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(diff1, end(diff1))
		);
		sort(diff1.begin(), diff1.end());
		std::set_difference(
					begin(all_msg), 
					end(all_msg), 
					begin(diff1), 
					end(diff1), 
					std::inserter(delay_cmd[submatrix_id][7], end(delay_cmd[submatrix_id][7]))
		);
		sort(delay_cmd[submatrix_id][7].begin(), delay_cmd[submatrix_id][7].end());

		vector<unsigned int>().swap(diff);
		vector<unsigned int>().swap(diff1);
		cout << "All-one-delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][7].size(); temp++) cout << delay_cmd[submatrix_id][7][temp] << " ";
		cout << "}" << endl;
		
		// To generate HDL source code
		page_align_hdl_gen(submatrix_id, align_cmd_num, delay_cmd[submatrix_id]);
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
	}

	for(unsigned int k = 0; k < dc; k++) {log_fd[k].close();}
	
	vector<unsigned int> critical_set_ref[dc][layer_num];
	vector<unsigned int> ***critical_set = new vector<unsigned int>** [dc];
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++) {
		critical_set[submatrix_id] = new vector<unsigned int>* [align_cmd_num];

		for(unsigned int cmd_id = 0; cmd_id < align_cmd_num; cmd_id++)
			critical_set[submatrix_id][cmd_id] = new vector<unsigned int> [layer_num];
	}

	for(unsigned int i = 0; i < layer_num; i++) {
		cout << "Layer_" << i << endl;
		for(unsigned int j = 1; j < dc; j++) {
			cout << "submatrix_" << j << ": "			
			     << "{DS_" << circular_page_ptr.DS[i][j] << " ~ DS_" << Pc-1 << "} must be delayed by " << inLayer_cnt << "-cycle when write-page is " 
			     << "PA_" << circular_page_ptr.PA[i][j] << endl;
			
			// There is one exception leads to different identification of mux location
			// E.g., a zero shift factor on next layer
			if(s[(i+1) % layer_num][j] == 0) {
				vector<unsigned int>::iterator align_msg;
				for(align_msg = layer[i].page_align_set[j][(unsigned int) ONE_DELAY].begin(); 
					align_msg != layer[i].page_align_set[j][(unsigned int) ONE_DELAY].end(); 
					align_msg++
				) {
					critical_set_ref[j][i].push_back(*align_msg);
					//cout << "critical_set_ref["<<j<<"]["<<i<<"]:" << critical_set_ref[j][i].back() << endl;
				}
			}
			else {
				for(unsigned int critical_element = circular_page_ptr.DS[i][j]; critical_element < Pc; critical_element++) 
					critical_set_ref[j][i].push_back(critical_element);
			}
		}
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
	}
#ifdef DEBUG
	cout << endl << endl << endl;
#endif
	// Reading and loading the configuration file of each circular command generation logic
	ifstream logic_fd("circular_cmd_log.v", ifstream::in);
	circular_cmd_logic = new string* [align_cmd_num];
	for(unsigned int base_set_id = 0; base_set_id < align_cmd_num; base_set_id++) {
		circular_cmd_logic[base_set_id] = new string [align_cmd_num-1]; // the last one without circular cmd at all
		for(unsigned int circular_id = 0; circular_id < align_cmd_num-1; circular_id++)
			std::getline(logic_fd, circular_cmd_logic[base_set_id][circular_id]);
	}
	logic_fd.close();

	vector<unsigned int> ***circular_delay_cmd = new vector<unsigned int>** [dc];
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++) {
		circular_delay_cmd[submatrix_id] = new vector<unsigned int>* [align_cmd_num];
		for(unsigned int base_set_id = 0; base_set_id < align_cmd_num; base_set_id++) {
			circular_delay_cmd[submatrix_id][base_set_id] = new vector<unsigned int> [align_cmd_num];
			critical_delay_set_construct(
				base_set_id, 
				delay_cmd[submatrix_id], 
				critical_set_ref[submatrix_id],
				critical_set[submatrix_id][base_set_id]
			);
#ifdef DEBUG
			for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
				cout << "Submatrix_" << submatrix_id << ", Delay-Cmd_" << base_set_id 
					 << "\t->\tCritical_set_" << (char) (68+layer_id) << "={ ";
				
				for(unsigned int set_element = 0; set_element < critical_set[submatrix_id][base_set_id][layer_id].size(); set_element++)
					cout << critical_set[submatrix_id][base_set_id][layer_id][set_element] << " ";

				cout << "}" << endl;
			}
			if(base_set_id != align_cmd_num-1)
				cout << endl;
			else
				cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
#endif
			// Generation of circular delay command
#ifdef DEBUG
			cout << "Circular Delay Command subsets of base set: { ";
			for(unsigned int element_id = 0; element_id < delay_cmd[submatrix_id][base_set_id].size(); element_id++)
				cout << delay_cmd[submatrix_id][base_set_id][element_id] << " ";
			cout << "}" << endl;
#endif
			circular_page_align_cmd_gen(
				align_cmd_num,
				delay_cmd[submatrix_id][base_set_id],
				critical_set[submatrix_id][base_set_id],
				circular_delay_cmd[submatrix_id][base_set_id]
			);
#ifdef DEBUG
			cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
#endif
			// To generate the final page-aligned mechanism including circular-aware command generators and page-aligned message net assignment
			circular_page_align_hdl_gen(
				base_set_id,
				submatrix_id,
				align_cmd_num,
				circular_delay_cmd[submatrix_id][base_set_id]
			);
		}
	}

	// To generate the Test Pattern for HDL verification
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++)
		v2c_msg_pass_test_pattern(submatrix_id);

	return 0;
}

void sys_init()
{	
	col_size = dc*z;
	layer = new Layer_Module[layer_num];
	for(unsigned int i = 0; i < col_size; i++) C_index[i] = i;
	for(unsigned int i = 0; i < layer_num; i++) {
		layer[i].C_index = new unsigned int[col_size];
		layer[i].DS = new unsigned int[col_size];
		layer[i].PA = new unsigned int[col_size];
		layer[i].shift_factor = new unsigned int [dc];
		for(unsigned int j = 0; j < col_size; j++) layer[i].C_index[j] = C_index[j] % z;
	}

	//srand(time(NULL));
}

void var_mem_init()
{
	v2c_base = ceil((dc*q)/BW_bram)*(inLayer_cnt);
}

/*
 Description: 
	To search for the word locations where multiplexers oughout to be inserted, with respect to any two consecutive layers
	The searching approach is based on the following logic: (PA^{j} union PA^{(j+1) % d_v}) \ (PA^{j} intersect PA^{(j+1) % d_v})

*/
void mux_insert_set(unsigned int layer_a, unsigned int *mux_num, unsigned int **mux_loc_set)
{
	for(int i = 0; i < dc; i++) {
		unsigned int sub_matrix_end = (i+1)*z-1;
		// To identify the number of messages have to be stored with two clock cycles delay insertion
		int a = (int) layer[layer_a].DS[sub_matrix_end]+1; // number of misaligned messages
		if(a < Pc) { // PA^{j} > PA^{j+1}
			mux_num[i] = a;
			mux_loc_set[i][0] = a; // one-cycle delay insertion
			mux_loc_set[i][1] = 0; // tow-cycle delay insertion
		}
		else { // PA^{j} == PA^{j+1}, i.e., all Pc messages are inserted one-cycle delay
			mux_num[i] = 0;
			mux_loc_set[i][0] = 0; // one-cycle delay insertion
			mux_loc_set[i][1] = 0; // tow-cycle delay insertion
		}
	}
}

void delay_set_construct(unsigned int submatrix_id, unsigned int delay_type, unsigned int target_set_size, unsigned int target_start_loc, Layer_Module *target_layer, bool isExcption)
{
	if(isExcption == true) {
		unsigned int pcm_col, one_delay_page, DS_cur;
		pcm_col = (submatrix_id*z);
		one_delay_page = target_layer -> PA[pcm_col];

		if(delay_type == (unsigned int) ONE_DELAY) {
			for(unsigned int col = pcm_col; col < pcm_col+Pc; col++) {
				DS_cur = target_layer -> DS[col];
				if(target_layer -> PA[col] == one_delay_page)
					target_layer -> page_align_set[submatrix_id][(unsigned int) ONE_DELAY].push_back(DS_cur);
				else
					target_layer -> page_align_set[submatrix_id][(unsigned int) TWO_DELAY].push_back(DS_cur);
			}
		}
	}
	else { // if isException == false
		// One- or Two-delay insertion set
		if(delay_type == (unsigned int) ONE_DELAY || delay_type == (unsigned int) TWO_DELAY) {
			for(unsigned int i = 0; i < target_set_size; i++) 
				target_layer -> page_align_set[submatrix_id][delay_type].push_back(target_start_loc+i);
		}
	}
}

void page_align_hdl_gen(unsigned int submatrix_id, unsigned int align_cmd_num, vector<unsigned int> *delay_cmd)
{
	unsigned int *align_set_size = new unsigned int [align_cmd_num];
	unsigned int cmd_type;
	
	sprintf(hdl_filename+11, "%d_lib.v", submatrix_id);
	ofstream hdl_fd; hdl_fd.open(hdl_filename, ofstream::out | ofstream::app);
	for(unsigned int cmd_id = 0; cmd_id < align_cmd_num; cmd_id++)
		align_set_size[cmd_id] = delay_cmd[cmd_id].size();

	cmd_type = 0;
	while(cmd_type < 6) {
		if(align_set_size[cmd_type] != 0) {
			for(unsigned int i = 0; i < align_set_size[cmd_type]; i++)
				hdl_fd << "wire delay_cmd_" << delay_cmd[cmd_type][i] << ";" << endl
					   << "align_cmd_gen_" << cmd_type
			       	   << " #(.LAYER_NUM (LAYER_NUM)) delay_cmd_" << delay_cmd[cmd_type][i]
			       	   << "(.delay_cmd(delay_cmd_" << delay_cmd[cmd_type][i]
			       	   << "), .layer_status(layer_status[LAYER_NUM-1:0]));" << endl
			       	   << "page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << delay_cmd[cmd_type][i]
			       	   << "(.align_out (msg_out_" << delay_cmd[cmd_type][i]
			       	   << "), .align_target_in (msg_mux_out[" << delay_cmd[cmd_type][i]
			       	   << "]), .delay_cmd(delay_cmd_" << delay_cmd[cmd_type][i]
			       	   << "), .sys_clk(sys_clk), .rstn(rstn));" << endl << endl;
		}
		cmd_type += 1;
	}

	for(unsigned int i = 0; i < align_set_size[6]; i++) {
		hdl_fd << "page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << delay_cmd[6][i]
			   << "(.align_out(msg_out_" << delay_cmd[6][i]
			   << "), .align_target_in (msg_mux_out[" << delay_cmd[6][i]
			   << "]), .sys_clk(sys_clk), .rstn(rstn));" << endl;
	}
	for(unsigned int i = 0; i < align_set_size[7]; i++) {
		hdl_fd << "page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << delay_cmd[7][i]
			   << "(.align_out(msg_out_" << delay_cmd[7][i]
			   << "), .align_target_in (msg_mux_out[" << delay_cmd[7][i]
			   << "]), .sys_clk(sys_clk), .rstn(rstn));" << endl;
	}

	hdl_fd.close();
}

void critical_delay_set_construct(
	unsigned int base_set_id, 
	vector<unsigned int> *base_set, 
	vector<unsigned int> *critical_set_ref,
	vector<unsigned int> *critical_set
)
{
	for(unsigned int critical_set_id = 0; critical_set_id < layer_num; critical_set_id++) {
		sort(critical_set_ref[critical_set_id].begin(), critical_set_ref[critical_set_id].end());
		sort(base_set[base_set_id].begin(), base_set[base_set_id].end());
		std::set_intersection(
					begin(base_set[base_set_id]), 
					end(base_set[base_set_id]), 
					begin(critical_set_ref[critical_set_id]), 
					end(critical_set_ref[critical_set_id]), 
					std::inserter(critical_set[critical_set_id], end(critical_set[critical_set_id]))
		);
		sort(critical_set[critical_set_id].begin(), critical_set[critical_set_id].end());
		/*
		for(unsigned i = 0; i < base_set[base_set_id].size(); i++)
			cout << "1) base_set["<<base_set_id<<"]:"<<base_set[base_set_id][i] << endl;
		for(unsigned i = 0; i < critical_set_ref[critical_set_id].size(); i++)
			cout << "2) critical_set_ref[" << critical_set_id << "]:" << critical_set_ref[critical_set_id][i] << endl;
		for(unsigned i = 0; i < critical_set[critical_set_id].size(); i++)
			cout << "3) critical_set["<<critical_set_id<<"]:" << critical_set[critical_set_id][i] << endl;
		*/
	}
}

void circular_page_align_cmd_gen(unsigned int align_cmd_num, vector<unsigned int> base_delay_cmd, vector<unsigned int> *critical_set, vector<unsigned int> *circular_delay_cmd)
{
	sort(critical_set[0].begin(), critical_set[0].end());
	sort(critical_set[1].begin(), critical_set[1].end());
	sort(critical_set[2].begin(), critical_set[2].end());

	// Construction of delay commands
	cout << "Construction of Circular delay commands" << endl;
	// 0) Two-delay-only inseration on Layer A:
	//    set operation: (A-B)-C or (A\B)\C
	vector<unsigned int> diff;
	std::set_difference(
				begin(critical_set[0]), 
				end(critical_set[0]), 
				begin(critical_set[1]), 
				end(critical_set[1]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[2]),
				end(critical_set[2]),
				std::inserter(circular_delay_cmd[0], end(circular_delay_cmd[0]))
	);
	vector<unsigned int>().swap(diff);
	cout << "D-only delay command: { ";
	for(unsigned int temp = 0; temp < circular_delay_cmd[0].size(); temp++) cout << circular_delay_cmd[0][temp] << " ";
	cout << "}" << endl;
	
	// 1) Two-delay-only inseration on Layer B:
	//    set operation: (B-A)-C
	std::set_difference(
				begin(critical_set[1]), 
				end(critical_set[1]), 
				begin(critical_set[0]), 
				end(critical_set[0]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[2]),
				end(critical_set[2]),
				std::inserter(circular_delay_cmd[1], end(circular_delay_cmd[1]))
	);
	vector<unsigned int>().swap(diff);
	cout << "E-only delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[1].size(); temp++) cout << circular_delay_cmd[1][temp] << " ";
	cout << "}" << endl;
	
	// 2) Two-delay-only inseration on Layer A and B:
	//    set operation: (A intersection B)\C
	std::set_intersection(
				begin(critical_set[0]), 
				end(critical_set[0]), 
				begin(critical_set[1]), 
				end(critical_set[1]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[2]),
				end(critical_set[2]),
				std::inserter(circular_delay_cmd[2], end(circular_delay_cmd[2]))
	);
	vector<unsigned int>().swap(diff);
	cout << "D&E delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[2].size(); temp++) cout << circular_delay_cmd[2][temp] << " ";
	cout << "}" << endl;
	
	// 3) Two-delay-only inseration on Layer C:
	//    set operation: (C-A)-B
	std::set_difference(
				begin(critical_set[2]), 
				end(critical_set[2]), 
				begin(critical_set[0]), 
				end(critical_set[0]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[1]),
				end(critical_set[1]),
				std::inserter(circular_delay_cmd[3], end(circular_delay_cmd[3]))
	);
	vector<unsigned int>().swap(diff);
	cout << "F-only delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[3].size(); temp++) cout << circular_delay_cmd[3][temp] << " ";
	cout << "}" << endl;
	
	// 4) Two-delay-only inseration on Layer A and C:
	//    set operation: (A intersection C)\B
	std::set_intersection(
				begin(critical_set[0]), 
				end(critical_set[0]), 
				begin(critical_set[2]), 
				end(critical_set[2]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[1]),
				end(critical_set[1]),
				std::inserter(circular_delay_cmd[4], end(circular_delay_cmd[4]))
	);
	vector<unsigned int>().swap(diff);
	cout << "D&F delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[4].size(); temp++) cout << circular_delay_cmd[4][temp] << " ";
	cout << "}" << endl;
	
	// 5) Two-delay-only inseration on Layer B and C:
	//    set operation: (B intersection C)\A
	std::set_intersection(
				begin(critical_set[1]), 
				end(critical_set[1]), 
				begin(critical_set[2]), 
				end(critical_set[2]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_difference(
				begin(diff), 
				end(diff), 
				begin(critical_set[0]),
				end(critical_set[0]),
				std::inserter(circular_delay_cmd[5], end(circular_delay_cmd[5]))
	);
	sort(diff.begin(), diff.end());
	vector<unsigned int>().swap(diff);
	cout << "E&F delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[5].size(); temp++) cout << circular_delay_cmd[5][temp] << " ";
	cout << "}" << endl;
	
	// 6) Two-delay-only inseration over all layers:
	//    set operation: A iintersection B intersection C
	std::set_intersection(
				begin(critical_set[0]), 
				end(critical_set[0]), 
				begin(critical_set[1]), 
				end(critical_set[1]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_intersection(
				begin(diff), 
				end(diff), 
				begin(critical_set[2]),
				end(critical_set[2]),
				std::inserter(circular_delay_cmd[6], end(circular_delay_cmd[6]))
	);
	vector<unsigned int>().swap(diff);
	cout << "All-" << inLayer_cnt << "-delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[6].size(); temp++) cout << circular_delay_cmd[6][temp] << " ";
	cout << "}" << endl;
	
	// 7) One-delay-only inseration over all layers:
	//    set operation: (A union B union C)'
	vector<unsigned int> diff1;
	std::set_union(
				begin(critical_set[0]), 
				end(critical_set[0]), 
				begin(critical_set[1]), 
				end(critical_set[1]), 
				std::inserter(diff, end(diff))
	);
	sort(diff.begin(), diff.end());
	std::set_union(
				begin(diff), 
				end(diff), 
				begin(critical_set[2]),
				end(critical_set[2]),
				std::inserter(diff1, end(diff1))
	);
	sort(diff1.begin(), diff1.end());
	std::set_difference(
				begin(base_delay_cmd), 
				end(base_delay_cmd), 
				begin(diff1), 
				end(diff1), 
				std::inserter(circular_delay_cmd[7], end(circular_delay_cmd[7]))
	);
	vector<unsigned int>().swap(diff);
	vector<unsigned int>().swap(diff1);
	cout << "All-no-circular-delay command: {";
	for(unsigned int temp = 0; temp < circular_delay_cmd[7].size(); temp++) cout << circular_delay_cmd[7][temp] << " ";
	cout << "}" << endl;
	
	sort(circular_delay_cmd[0].begin(), circular_delay_cmd[0].end());
	sort(circular_delay_cmd[1].begin(), circular_delay_cmd[1].end());
	sort(circular_delay_cmd[2].begin(), circular_delay_cmd[2].end());
	sort(circular_delay_cmd[3].begin(), circular_delay_cmd[3].end());
	sort(circular_delay_cmd[4].begin(), circular_delay_cmd[4].end());
	sort(circular_delay_cmd[5].begin(), circular_delay_cmd[5].end());
	sort(circular_delay_cmd[6].begin(), circular_delay_cmd[6].end());
	sort(circular_delay_cmd[7].begin(), circular_delay_cmd[7].end());
}

void circular_page_align_hdl_gen(unsigned int base_set_id, unsigned int submatrix_id, unsigned align_cmd_num, vector<unsigned int> *circular_delay_cmd)
{
	sprintf(hdl_filename, "circular_page_align_%d_lib.v", submatrix_id);
	ofstream hdl_fd; hdl_fd.open(hdl_filename, ofstream::out | ofstream::app);
	unsigned int memBank_addr;

	for(unsigned int cmd_id = 0; cmd_id < align_cmd_num; cmd_id++) {
		unsigned int circular_set_size = circular_delay_cmd[cmd_id].size();
		if(circular_set_size != 0 && cmd_id < (align_cmd_num-2)) {
			// One common command generator/logic is enough to be shared by the following elements
			hdl_fd << "wire [1:0] circular_delay_cmd_" << base_set_id << "_" << cmd_id << ";" << endl
				   << "assign circular_delay_cmd_" << base_set_id << "_" << cmd_id
				   << " = " << circular_cmd_logic[base_set_id][cmd_id] << endl;

			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				hdl_fd << "circular_page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u"
					   << memBank_addr
					   << " (.align_out (msg_out_" << memBank_addr
					   << "), .align_target_in (msg_mux_out[" << memBank_addr
					   << "]), .delay_cmd(circular_delay_cmd_" << base_set_id << "_" << cmd_id
					   << "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-2)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				hdl_fd << "circular_page_align_depth_";
				if(base_set_id == 6) hdl_fd << "2"; // 2-circular delay
				else if(base_set_id == 7) hdl_fd << "1"; // 1-circular delay
				hdl_fd << " #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
				       << " (.align_out (msg_out_" << memBank_addr
				       << "), .align_target_in (msg_mux_out[" << memBank_addr
				       << "]), .first_row_chunk(first_row_chunk), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-1)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				if(base_set_id < 6){
					hdl_fd << "wire delay_cmd_" << memBank_addr << ";" << endl
						   << "align_cmd_gen_" << base_set_id
			    	   	   << " #(.LAYER_NUM (LAYER_NUM)) delay_cmd_u" << memBank_addr
			    	   	   << "(.delay_cmd(delay_cmd_" << memBank_addr
			    	   	   << "), .layer_status(layer_status[LAYER_NUM-1:0]));" << endl
			    	   	   << "page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
			    	   	   << "(.align_out (msg_out_" << memBank_addr
			    	   	   << "), .align_target_in (msg_mux_out[" << memBank_addr
			    	   	   << "]), .delay_cmd(delay_cmd_" << memBank_addr
			    	   	   << "), .sys_clk(sys_clk), .rstn(rstn));" << endl << endl;
			    }
				else if(base_set_id == 6) {
					hdl_fd << "page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   << "(.align_out(msg_out_" << memBank_addr
						   << "), .align_target_in (msg_mux_out[" << memBank_addr
						   << "]), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			    }
				else if(base_set_id == 7) {
					hdl_fd << "page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   << "(.align_out(msg_out_" << memBank_addr
						   << "), .align_target_in (msg_mux_out[" << memBank_addr
						   << "]), .sys_clk(sys_clk), .rstn(rstn));" << endl;
				}
			}
		}
	}
	hdl_fd.close();
}

void v2c_msg_pass_test_pattern(unsigned int submatrix_id)
{
	char *filename = new char [50];
	sprintf(filename, "submatrix_%d_v2c_bs_in.mem", submatrix_id);
	ofstream hdl_fd; hdl_fd.open(filename, ofstream::out);

	unsigned int v2c_bs_out[layer_num][inLayer_cnt][Pc];
	unsigned int norm_col; // normalised column index
	unsigned int rand_temp, norm_col1, norm_row1;
	for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
		for(unsigned int row_chunk_id = 0; row_chunk_id < inLayer_cnt; row_chunk_id++) {
			for(unsigned int col = 0; col < Pc; col++) {
				rand_temp = rand() % ((unsigned int) 1 << q);
				hdl_fd << hex << rand_temp << " ";
				cout << hex << rand_temp << " -> ";

				norm_col = (submatrix_id*z)+(Pc*row_chunk_id)+col;
				norm_row1 = layer[layer_id].PA[norm_col];
				norm_col1 = layer[layer_id].DS[norm_col];
				v2c_bs_out[layer_id][norm_row1][norm_col1] = rand_temp;
				cout << "v2c_bs_out["
					 << dec << layer_id << "][" 
					 << dec << norm_row1 
					 << "][" 
					 << dec << norm_col1 
					 << "]: " 
					 << hex << v2c_bs_out[layer_id][norm_row1][norm_col1] << endl;
			}
			hdl_fd << endl;
		}		
	}

	sprintf(filename, "submatrix_%d_vn_to_mem.mem", submatrix_id);
	ofstream hdl_fd1; hdl_fd1.open(filename, ofstream::out);
	for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
		for(unsigned int row_chunk_id = 0; row_chunk_id < inLayer_cnt; row_chunk_id++) {
			for(unsigned int col = 0; col < Pc-1; col++) {
				hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][col] << ",";
			}
			hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][Pc-1] << endl;
		}
	}

	hdl_fd.close();
	hdl_fd1.close();
	delete [] filename;
}
/*
circular_page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u46(.align_out (msg_out_46), .align_target_in (msg_mux_out[46]), .delay_cmd(delay_cmd_46), .sys_clk(sys_clk), .rstn(rstn));

circular_page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u46(.align_out (msg_out_46), .align_target_in (msg_mux_out[46]), .first_row_chunk(first_row_chunk), .sys_clk(sys_clk), .rstn(rstn));
*/
/*
wire delay_cmd_58;
module circular_align_cmd_gen_5 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 5) Two-delay-only inseration on Layer B and C:
assign delay_cmd = ((layer_status[1] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b1) ? 2'b10
                   ((layer_status[1] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule


wire [1:0] delay_cmd_0;
assign delay_cmd_0 = (layer_status[0] == 1'b1 && first_row_chunk == 1'b1) ? 2'b10 :
		     (layer_status[0] == 1'b1 && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;

assign delay_cmd_0 = ()
*/