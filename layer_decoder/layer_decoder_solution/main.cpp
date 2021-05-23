#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include <vector>
#include <algorithm>
#include <iterator>

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
typedef struct layer_module {
	unsigned int *C_index;
	unsigned int *DS; // device selection
	unsigned int *PA; // page address

	//unsigned int ***page_align_set;
	page_align_set_t **page_align_set;
} Layer_Module;
Layer_Module *layer;


void sys_init();
void var_mem_init();
void mux_insert_set(unsigned int layer_a, unsigned int layer_b, unsigned int *mux_num, unsigned int **mux_loc_set);
void delay_set_construct(unsigned int sub_matrix_id, unsigned int delay_type, unsigned int target_set_size, unsigned int target_start_loc, Layer_Module *target_layer);

int main(int argc, char **argv)
{
	// Unrolling dual-port bitwidth to a (virtual) single-port bitwidth for ease of following address determination
	BW_bram=BW_bram*port_num;
	sys_init();
	var_mem_init();
	unsigned int row_chunk_cnt;

	for(int i = 0; i < layer_num; i++) {
#ifdef DEBUG
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl
		     << "Layer " << i << endl;
#endif
		// Determining the memory device selection/address
		unsigned int pcm_col;
		int interLayer_offset, layer_0_shift, layer_1_shift;
		for(int sub_matrix_id = 0; sub_matrix_id < dc; sub_matrix_id++) {
#ifdef DEBUG
			cout << endl << endl << "Sub-Matrix_" << sub_matrix_id << ":" << endl << "(DS, PA)" << endl;
#endif
			layer_0_shift = (int) s[i][sub_matrix_id];
			layer_1_shift = (int) s[(i+1) % layer_num][sub_matrix_id];
			interLayer_offset = abs((int) ((z-layer_0_shift) % Pc) - (int) ((z-layer_1_shift) % Pc));
			row_chunk_cnt = 0;
			for(int col = 0; col < z; col++) {
				pcm_col = (sub_matrix_id*z)+col;
				layer[i].DS[pcm_col] = ((col % (unsigned int) Pc)+interLayer_offset) % Pc;
				layer[i].PA[pcm_col] = (unsigned int) floor((z-layer_1_shift+col+layer_0_shift)/Pc) % inLayer_cnt;
#ifdef DEBUG
				if((col % Pc) == 0) {
					cout << endl << "Row Chunk_" << row_chunk_cnt << endl;
					row_chunk_cnt+=1;
				}

				#ifdef DISPLAY_DEVICE_AND_PAGE_ADDR
					cout << "(" << layer[i].DS[pcm_col] << ", " << layer[i].PA[pcm_col] << ") ";
				#endif

				#ifdef DISPLAY_DEVICE_SELECTION_ONLY
					cout << layer[i].DS[pcm_col];
					if(col % 10 == 0) cout << endl;
					else cout << " ";
				#endif

				#ifdef DISPLAY_PAGE_ADDR_ONLY
					if(sub_matrix_id == 1) {
					cout << layer[i].PA[pcm_col];
					if((col % Pc == 0 || col % 10 == 0) && col != 0) cout << endl;
					else cout << " ";
					}
				#endif
#endif
			}
		}
	}

	unsigned int **mux_num = new unsigned int* [layer_num];
	unsigned int ***mux_loc_set = new unsigned int** [layer_num];
	for(int i = 0; i < layer_num; i++) {
		unsigned int layer_a = i, layer_b = (i+1) % layer_num;
		mux_num[i] = new unsigned int[dc];
		mux_loc_set[i] = new unsigned int* [dc];
		for(int j = 0; j < dc; j++) mux_loc_set[i][j] = new unsigned int[2];
		mux_insert_set(layer_a, layer_b, mux_num[i], mux_loc_set[i]);
#ifdef DEBUG
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
		cout << "Set of Multipexer Insertion Locations --> Between Layer_" << layer_a << " and " << layer_b << endl
		     << "(Multiplexer number, MemBank.start, MemBank.end):" << endl;
#endif
		layer[i].page_align_set = new page_align_set_t* [dc];
		for(unsigned int k = 0; k < dc; k++) {
#ifdef DEBUG
			cout << "\tSub-matrix_" << k 
			     << " -> {# of one-cycle MUXs:" << Pc-mux_num[i][k] 
			     << " (from:" << mux_loc_set[i][k][0] << ")"
			     << ", # of two-cycle MUXs:" << mux_num[i][k] << " (from:" << mux_loc_set[i][k][1] << ")}" << endl;
#endif
			if(k != 0) {
				// Construction of one- and two-delay insertion sets of all layers
				layer[i].page_align_set[k] = new page_align_set_t [PAGE_ALIGN_TYPE_NUM];	
				unsigned int delay_set_size[PAGE_ALIGN_TYPE_NUM]; 
				delay_set_size[0] = Pc-mux_num[i][k]; delay_set_size[1] = mux_num[i][k];
				for(unsigned int align_type = 0; align_type < PAGE_ALIGN_TYPE_NUM; align_type++) {
					delay_set_construct(
								k,
								align_type, 
								delay_set_size[align_type],
								mux_loc_set[i][k][align_type],
								&layer[i]
					);
#ifdef DEBUG
					cout << align_type+1 << "-delay insertion set:" << endl << "{";
					//for(unsigned int l = 0; l < delay_set_size[align_type]; l++) 
					//	cout << layer[i].page_align_set[k][align_type][l] << " ";
					vector<unsigned int>::iterator align_msg;
					for(align_msg = layer[i].page_align_set[k][align_type].begin(); align_msg != layer[i].page_align_set[k][align_type].end(); align_msg++)
						cout << *align_msg << " ";
					cout << "}" << endl; 
#endif
				}
			}
		}
	}

	// Construction of delay commands
	cout << "----------------------------------------------------------------------------------------------------------------------------" << endl
	     << "Construction of delay commands" << endl;
	vector<unsigned int> **delay_cmd = new vector<unsigned int>* [dc-1];
	vector<unsigned int> all_msg; // a dummy set including all {0, 1, ..., Pc-1} in order to perform complement of a set
	for(unsigned int temp = 0; temp < Pc; temp++) all_msg.push_back(temp);
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++) {
		delay_cmd[submatrix_id] = new vector<unsigned int> [((unsigned int) 1) << layer_num]; // there are 2^(layer_num) number of possible delay commands to be generated
		// 0) Two-delay-only inseration on Layer A:
		//    set operation: (A-B)-C or (A\B)\C
		vector<unsigned int> diff;
		std::set_difference(
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
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][3], end(delay_cmd[submatrix_id][3]))
		);
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
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[1].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][4], end(delay_cmd[submatrix_id][4]))
		);
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
		std::set_difference(
					begin(diff), 
					end(diff), 
					begin(layer[0].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[0].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][5], end(delay_cmd[submatrix_id][5]))
		);
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
		std::set_intersection(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(delay_cmd[submatrix_id][6], end(delay_cmd[submatrix_id][6]))
		);
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
		std::set_union(
					begin(diff), 
					end(diff), 
					begin(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					end(layer[2].page_align_set[submatrix_id][TWO_DELAY]),
					std::inserter(diff1, end(diff1))
		);
		std::set_difference(
					begin(all_msg), 
					end(all_msg), 
					begin(diff1), 
					end(diff1), 
					std::inserter(delay_cmd[submatrix_id][7], end(delay_cmd[submatrix_id][7]))
		);
		vector<unsigned int>().swap(diff);
		vector<unsigned int>().swap(diff1);
		cout << "All-one-delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][7].size(); temp++) cout << delay_cmd[submatrix_id][7][temp] << " ";
		cout << "}" << endl;
		
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
	}

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
		for(unsigned int j = 0; j < col_size; j++) layer[i].C_index[j] = C_index[j] % z;
	}
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
void mux_insert_set(unsigned int layer_a, unsigned int layer_b, unsigned int *mux_num, unsigned int **mux_loc_set)
{
	for(int i = 0; i < dc; i++) {
		unsigned int sub_matrix_end = (i+1)*z-1;
		// To identify the number of messages have to be stored with two clock cycles delay insertion
		int a = (int) layer[layer_a].DS[sub_matrix_end]+1; // number of misaligned messages
		int b = (int) layer[layer_b].DS[sub_matrix_end]+1; // number of misaligned messages
		int mux_num_temp = a-b;
		if(mux_num_temp > 0) { // PA^{j} > PA^{j+1}
			mux_num[i] = a;
			mux_loc_set[i][0] = a; // one-cycle delay insertion
			mux_loc_set[i][1] = 0; // tow-cycle delay insertion
		}
		else if(mux_num_temp < 0) { // PA^{j} < PA^{j+1}
			mux_num[i] = b;
			mux_loc_set[i][0] = b; // one-cycle delay insertion
			mux_loc_set[i][1] = 0; // two-cycle delay insertion
		}
		else { // PA^{j} == PA^{j+1}, i.e., all Pc messages are inserted one-cycle delay
			mux_num[i] = 0;
		}
	}
}

void delay_set_construct(unsigned int sub_matrix_id, unsigned int delay_type, unsigned int target_set_size, unsigned int target_start_loc, Layer_Module *target_layer)
{
	// One- or Two-delay insertion set
	if(delay_type == (unsigned int) ONE_DELAY || delay_type == (unsigned int) TWO_DELAY) {
		for(unsigned int i = 0; i < target_set_size; i++) 
			target_layer -> page_align_set[sub_matrix_id][delay_type].push_back(target_start_loc+i);
	}
}
