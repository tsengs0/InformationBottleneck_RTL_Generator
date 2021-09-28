#include "main.h"
#include "sys_config.h"
#include "sub_row_pa_lib.h"

//#define DEBUG
#define PA_DA_REV_20_JULY_2021

// H/W configuration
unsigned int BW_bram=20;
unsigned int port_num=2;
uint8_t q = 4; // 4-bit precision

// PCM feature
#define N 10
#define dc 10
#define dv 3
#define layer_num dv
#define z 765
#define Pc 255
#define Ns 5 // row-split factor, i.e., splitting each row block into Ns sub-row blocks
#define PARTIAL_PA_EVENT_SENSITIVITY_NUM 1+layer_num+Ns
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
	TWO_DELAY = 1,
	CIRCULAR_DELAY = 2,
};
#define PAGE_ALIGN_TYPE_NUM 2 // number of page alignment types, e.g., one-delay and two-delay insertion
typedef vector<unsigned int> page_align_set_t;
typedef struct circular_page_t {
	unsigned int PA[layer_num][dc];
	unsigned int DS[layer_num][dc];
} circular_page;
string **circular_cmd_logic;
ofstream pa_hdl_fd[dc];

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
void c2v_msg_pass_test_pattern(unsigned int submatrix_id);
void signExten_msg_pass_test_pattern(unsigned int submatrix_id);
void chMsg_msg_pass_test_pattern(unsigned int submatrix_id);
unsigned int segment(unsigned int s, unsigned int t, unsigned int sub_size, unsigned int seg_size);
unsigned int segment_pos(unsigned int s, unsigned int t, unsigned int sub_size, unsigned int seg_size);
/*--------------------------------------------*/
// Row-Split Manipulation
unsigned int bs_num;
unsigned int **bs_alloc;
map<unsigned int, vector<unsigned int> > partial_layered_pa[Ns][DELAY_TYPE_NUM];
/*--------------------------------------------*/
//bool v2c_msg_pass_verification();
/*-------------------------------------------------------------------------------------------------------*/
// Only used for GDB
void print_2d_vector(unsigned int **vec, unsigned int num_0, unsigned int num_1, char *msgIdentifer)
{
	std::cout << msgIdentifer << ":" << std::endl;
	for(unsigned int i=0; i<num_0; i++) {
		for(unsigned int j=0; j<num_1; j++) {
			std::cout << "[" << i << "][" << j << "]\t=\t" << vec[i][j] << std::endl;
		}
	}
	std::cout << "-------------------------------------" << std::endl;
}
void print_3d_vector(unsigned int ***vec, unsigned int num_0, unsigned int num_1, unsigned int num_2, char *msgIdentifer)
{
	std::cout << msgIdentifer << ":" << std::endl;
	for(unsigned int i=0; i<num_0; i++) {
		for(unsigned int j=0; j<num_1; j++) {
			for(unsigned int k=0; k<num_2; k++)
				std::cout << "[" << i << "][" << j << "][" << k << "]\t=\t" << vec[i][j][k] << std::endl;
		}
	}
	std::cout << "-------------------------------------" << std::endl;
}
/*-------------------------------------------------------------------------------------------------------*/
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
		unsigned int page_a[bs_num], page_b[bs_num]; // Row-Split Manipulation
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
			if(layer_1_shift == 0) {
				unsigned int shift_acc; shift_acc = 0;
				for(int acc_id=0; acc_id<i; acc_id++) shift_acc += layer[acc_id].shift_factor[sub_matrix_id];
				interLayer_offset = Pc-((unsigned int) (shift_acc % Pc));
			}
			else {
				interLayer_offset = abs((int) ((z-layer_0_shift) % Pc) - (int) ((z-layer_1_shift) % Pc));
			}
			layer[i].shift_factor[sub_matrix_id] = interLayer_offset;
#ifdef DEBUG	
			cout << "Shift Factor: " << interLayer_offset << endl;
#endif
			row_chunk_cnt = 0;
			for(int col = 0; col < z; col++) {
				pcm_col = (sub_matrix_id*z)+col;
				layer[i].DS[pcm_col] = segment_pos(layer_1_shift, (col+layer_0_shift) % z, z, Pc);
				layer[i].PA[pcm_col] = segment(layer_1_shift, (col+layer_0_shift) % z, z, Pc);

#ifdef DEBUG
				if((col % Pc) == 0) {
					cout << endl << "Row Chunk_" << row_chunk_cnt << endl;
					log_fd[sub_matrix_id] << endl << "Row Chunk_" << row_chunk_cnt << endl;
					row_chunk_cnt+=1;
				}

				cout << "(" << layer[i].DS[pcm_col] << ", " << layer[i].PA[pcm_col] << ")" << endl;
				log_fd[sub_matrix_id] << "(" << layer[i].DS[pcm_col] << ", " << layer[i].PA[pcm_col] << ")" << endl;
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
								(bool) true//isExcption
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
		log_fd[submatrix_id] << "----------------------------------------------------------------------------------------------------------------------------" << endl
	     					 << "Construction of delay commands" << endl;
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
		log_fd[submatrix_id] << "A-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][0].size(); temp++) {
			cout << delay_cmd[submatrix_id][0][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][0][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "B-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][1].size(); temp++) {
			cout << delay_cmd[submatrix_id][1][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][1][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "A&B delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][2].size(); temp++) {
			cout << delay_cmd[submatrix_id][2][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][2][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "C-only delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][3].size(); temp++) {
			cout << delay_cmd[submatrix_id][3][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][3][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "A&C delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][4].size(); temp++) {
			cout << delay_cmd[submatrix_id][4][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][4][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "B&C delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][5].size(); temp++) {
			cout << delay_cmd[submatrix_id][5][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][5][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
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
		log_fd[submatrix_id] << "All-two-delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][6].size(); temp++) {
			cout << delay_cmd[submatrix_id][6][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][6][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
	
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
		log_fd[submatrix_id] << "All-one-delay command for submatrix-" << submatrix_id << ": {";
		for(unsigned int temp = 0; temp < delay_cmd[submatrix_id][7].size(); temp++) {
			cout << delay_cmd[submatrix_id][7][temp] << " ";
			log_fd[submatrix_id] << delay_cmd[submatrix_id][7][temp] << " ";
		}
		cout << "}" << endl; log_fd[submatrix_id] << "}" << endl;
		
		// To generate HDL source code
		page_align_hdl_gen(submatrix_id, align_cmd_num, delay_cmd[submatrix_id]);
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
		log_fd[submatrix_id] << "----------------------------------------------------------------------------------------------------------------------------" << endl;
	}

/*----------------------------------------------------------------------------------------------------*/
	// Obselete
	// To pick up the subsets from one-delay sets where all elements in those subsets have to be circularly delayed.
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
			log_fd[j] << "Layer_" << i << endl
			          << "submatrix_" << j << ": "			
			          << "{DS_" << circular_page_ptr.DS[i][j] << " ~ DS_" << Pc-1 << "} must be delayed by " << inLayer_cnt << "-cycle when write-page is " 
			          << "PA_" << circular_page_ptr.PA[i][j] << endl
			          << "----------------------------------------------------------------------------------------------------------------------------" << endl;
			
			// There is one exception leading to different identification of mux location
			// E.g., a zero shift factor on next layer
			//if(s[(i+1) % layer_num][j] == 0) {
				vector<unsigned int>::iterator align_msg;
				for(align_msg = layer[i].page_align_set[j][(unsigned int) ONE_DELAY].begin(); 
					align_msg != layer[i].page_align_set[j][(unsigned int) ONE_DELAY].end(); 
					align_msg++
				) {
					critical_set_ref[j][i].push_back(*align_msg);
					cout << "critical_set_ref["<<j<<"]["<<i<<"]:" << critical_set_ref[j][i].back() << endl;
				}
			//}
			//else {
			//	for(unsigned int critical_element = circular_page_ptr.DS[i][j]; critical_element < Pc; critical_element++) 
			//		critical_set_ref[j][i].push_back(critical_element);
			//}
		}
		cout << "----------------------------------------------------------------------------------------------------------------------------" << endl;
	}
#ifdef DEBUG
	cout << endl << endl << endl;
#endif
/*----------------------------------------------------------------------------------------------------*/
	// Revision of above processes
	// To pick up the subsets from one-delay sets where all elements in those subsets have to be circularly delayed.
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
		/*----------------------------------------------------------------------------------------------------------------*/
			sprintf(hdl_filename, "circular_page_align_%d_lib.v", submatrix_id);
			pa_hdl_fd[submatrix_id].open(hdl_filename, ofstream::out | ofstream::app);

			pa_hdl_fd[submatrix_id] << "`include \"define.vh\"" << endl << endl
									<< "`ifdef SCHED_4_6" << endl
									<< dec << "module ram_pageAlign_interface_submatrix_" << submatrix_id << "#(" << endl
						  			<< "\tparameter QUAN_SIZE = " << (unsigned int) q << "," << endl
						  			<< "\tparameter CHECK_PARALLELISM = " << Pc << "," << endl
						  			<< "\tparameter LAYER_NUM = " << layer_num << endl
						  			<<") (" << endl;
			for(unsigned int i = 0; i < Pc; i++)
				pa_hdl_fd[submatrix_id] << "\toutput wire [QUAN_SIZE-1:0] msg_out_" << i << "," << endl;
			pa_hdl_fd[submatrix_id] << endl;
			for(unsigned int i = 0; i < Pc; i++)
				pa_hdl_fd[submatrix_id] << "\tinput wire [QUAN_SIZE-1:0] msg_in_" << i << "," << endl;
			pa_hdl_fd[submatrix_id] << endl
				   					<< "\tinput wire [LAYER_NUM-1:0] layer_status," << endl
				   					<< "\tinput wire first_row_chunk," << endl
				   					<< "\tinput wire sys_clk," << endl
				   					<< "\tinput wire rstn" << endl
				   					<< ");" << endl << endl
									<< "/////////////////////////////////////////////////////////////////////////////////////////////" << endl
				   					<< "// Main structure of Page Alignment Mechanism" << endl;	
		/*----------------------------------------------------------------------------------------------------------------*/
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
		pa_hdl_fd[submatrix_id] << "/////////////////////////////////////////////////////////////////////////////////////////////" << endl
								<< "endmodule" << endl
								<< "`endif";
		pa_hdl_fd[submatrix_id].close();
	}
/*----------------------------------------------------------------------------------------------------*/
// Runtime debugging
		cout << "==============================RUNTIME DEBUGGING===================================" << endl;
		vector<unsigned int> DA_noneShifted;
		for(unsigned int da_id=0; da_id<Pc; da_id++) DA_noneShifted.push_back(da_id);
		vector<unsigned int> diff[Ns][align_cmd_num]; 
		unsigned int Ns_cnt; Ns_cnt=0;
		for(unsigned int submatrix_id=1; submatrix_id<dc; submatrix_id+=2) {
			cout << "Submatrix_" << submatrix_id << endl; 
			for(unsigned int cmd_id=0; cmd_id<align_cmd_num; cmd_id++) {
				cout << "CMD_" << cmd_id << ", ";
				std::set_difference(
							begin(DA_noneShifted), 
							end  (DA_noneShifted), 
							begin(delay_cmd[submatrix_id][cmd_id]), 
							end  (delay_cmd[submatrix_id][cmd_id]), 
							std::inserter(diff[Ns_cnt][cmd_id], end(diff[Ns_cnt][cmd_id]))
				); 
				sort(diff[Ns_cnt][cmd_id].begin(), diff[Ns_cnt][cmd_id].end());
				cout << "Diff.size: " << diff[Ns_cnt][cmd_id].size() << endl;
				for(unsigned int da_id=0; da_id<diff[Ns_cnt][cmd_id].size(); da_id++)
					cout << diff[Ns_cnt][cmd_id][da_id] << ", ";
				//vector<unsigned int>().swap(diff);
				cout << endl;
			}
			Ns_cnt += 1;
		}
	
		//vector<unsigned int> critical_set_ref[dc][layer_num];
		ofstream log_fd_partial_pa; log_fd_partial_pa.open("partial_pa.txt", ofstream::out | ofstream::app);

		log_fd_partial_pa.close();

		vector<unsigned int> inA, inB, inC, inD, inE;
		inA.push_back(1); inA.push_back(2); inA.push_back(3);
		inB.push_back(1); inB.push_back(5);
		union_cal(&inA, &inB, &inC);
		intersection_cal(&inA, &inB, &inD);
		difference_cal(&inA, &inB, &inE);
		//mp.insert({1, layer[0].page_align_set[1][TWO_DELAY]});
		//mp.insert({2, layer[0].page_align_set[3][TWO_DELAY]});
		//mp.insert({3, layer[0].page_align_set[5][TWO_DELAY]});
		//mp.insert({4, layer[0].page_align_set[7][TWO_DELAY]});
		//mp.insert({5, layer[0].page_align_set[9][TWO_DELAY]});


		/*
		for(unsigned int sen_id=0; sen_id<sensitivity_instance_num; sen_id++) {
			vector<unsigned int> nonzero_loc;
			binary_index_decoder(sen_id, , &nonzero_loc);
			unsigned int nonzero_loc_num = nonzero_loc.size();
			if(nonzero_loc_num == 0) {
				vector<unsigned int> diff[PARTIAL_PA_EVENT_SENSITIVITY_NUM-1];
				for(unsigned int sub_row_id=1; sub_row_id<Ns; sub_row_id++) {
					union_cal(layer)
				}
			}

			vector<unsigned int>().swap(nonzero_loc);
		}
		*/
		//layer[1].page_align_set[submatrix_id][TWO_DELAY]
		//vector<unsigned int> critical_set_ref[dc][layer_num];
		//while(1);
/*----------------------------------------------------------------------------------------------------*/
	// To generate the Test Pattern for HDL verification
	for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++)
		v2c_msg_pass_test_pattern(submatrix_id);
	// To generate the Test Pattern for HDL verification
	//for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++)
	//	c2v_msg_pass_test_pattern(submatrix_id);
	// To generate the Test Pattern for HDL verification
	//for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++)
	//	signExten_msg_pass_test_pattern(submatrix_id);
	//for(unsigned int submatrix_id = 1; submatrix_id < dc; submatrix_id++)
	//	chMsg_msg_pass_test_pattern(1);//(submatrix_id);
	for(unsigned int k = 0; k < dc; k++) log_fd[k].close();
	return 0;
}

// To identify all nonzero bit locations 
void binary_index_decoder(unsigned int bin_cmd, unsigned int segment_start, unsigned int segment_end, vector<unsigned int> *loc_set)
{
	bin_cmd = bin_cmd >> segment_start;
	unsigned int segment_num = segment_end-segment_start+1;
	for(unsigned int loc_id=0; loc_id<segment_num; loc_id++) {
		if(bin_cmd % 2 == 1) loc_set -> push_back(loc_id);
		bin_cmd = bin_cmd >> 1;
	}
}
void union_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset)
{
	std::set_union(
				begin (*inA), 
				end   (*inA), 
				begin (*inB), 
				end   (*inB), 
				std::inserter(*new_subset, end(*new_subset))
	); 
	sort(new_subset -> begin(), new_subset -> end());
}

void intersection_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset)
{
	std::set_intersection(
				begin (*inA), 
				end   (*inA), 
				begin (*inB), 
				end   (*inB), 
				std::inserter(*new_subset, end(*new_subset))
	); 
	sort(new_subset -> begin(), new_subset -> end());
}

void difference_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset)
{
	std::set_difference(
				begin (*inA), 
				end   (*inA), 
				begin (*inB), 
				end   (*inB), 
				std::inserter(*new_subset, end(*new_subset))
	); 
	sort(new_subset -> begin(), new_subset -> end());
}

/*
//layer[1].page_align_set[submatrix_id][TWO_DELAY]
//vector<unsigned int> critical_set_ref[dc][layer_num];
void group_intersection_cal(
	unsigned int bs_id,
	unsigned int sub_row_id,
	unsigned int delay_type, 
	vector<unsigned int> *layer_loc_vec, 
	unsigned int layer_loc_num, 
	vector<unsigned int> *new_subset
)
{
	if(layer_loc_num == 1) { // if there is only one set involved, just a duplication of that set onto new_subset is enough
		for (std::vector<unsigned int>::iterator it = layer[layer_id].page_align_set[ (*layer_loc_vec)[0]*bs_num+bs_id ][delay_type].begin() ; it != layer[layer_id].page_align_set[ (*layer_loc_vec)[0]*bs_num+bs_id ][delay_type].end(); ++it)
			new_subset -> push_back(*it);
	}
	else {
		unsigned int compare_pair_num = layer_loc_num-1;
		vector<unsigned int> diff[compare_pair_num];
		for(unsigned int pair_id=0; pair_id<compare_pair_num; pair_id++) {
			if(pair_id == 0) {
				intersection_cal(
					&layer[layer_id].page_align_set[ (*layer_loc_vec)[0]*bs_num+bs_id ][delay_type], 
					&layer[layer_id].page_align_set[ (*layer_loc_vec)[1]*bs_num+bs_id ][delay_type], 
					&diff[0]
				);
			}
			else {
				intersection_cal(
					&diff[pair_id-1], 
					&layer[layer_id].page_align_set[ (*layer_loc_vec)[pair_id+1]*bs_num+bs_id ][delay_type], 
					&diff[pair_id]
				);			
			}
		}
		new_subset -> swap(diff[compare_pair_num-1]);
	}
}

//layer[1].page_align_set[submatrix_id][TWO_DELAY]
//vector<unsigned int> critical_set_ref[dc][layer_num];
void group_set_minus(
	unsigned int bs_id,
	vector<unsigned int> *target_subset, 
	unsigned int delay_type_id,
	vector<unsigned int> *layer_vec, 
	unsigned int layer_vec_num, 
	vector<unsigned int> *new_subset
) {
	vector<unsigned int> diff_0, diff_1;
	for(std::vector<unsigned int>::iterator it = target_subset -> begin() ; it != target_subset -> end(); ++it)
		diff_0.push_back(*it);
	for(unsigned int layer_cnt=0; layer_cnt<layer_num; layer_cnt++) {
		if(!(std::any_of(layer_vec -> begin(), layer_vec -> end(), compare(layer_cnt)) == true)) {// whilst not involved
			difference_cal(&diff_0, &layer[layer_cnt].page_align_set[sub_cnt*bs_num+bs_id][delay_type_id], &diff_1);
			vector<unsigned int>().swap(diff_0); diff_1.swap(diff_0); vector<unsigned int>().swap(diff_1);
		}
	}
	for(std::vector<unsigned int>::iterator it = diff_0.begin() ; it != diff_0.end(); ++it)
		new_subset -> push_back(*it);
}

bool element_search(unsigned int val, vector<unsigned int> *vec)
{
	// Check if element val exists in vector vec
	vector<unsigned int>::iterator it = std::find(vec -> begin(), vec -> end(), val);
	if (it != vec -> end())
    	return true;
	else
    	return false;
}

void sub_row_delay_type_search(unsigned int sub_inst_id)
{
	unsigned int last_chunk_instance_num = (unsigned int) pow(2, 1);
	unsigned int layer_instance_num = (unsigned int) pow(2, (unsigned int) layer_num);
	unsigned int sub_row_instance_num = (unsigned int) pow(2, (unsigned int) Ns);
	unsigned int sen_id;
	unsigned int bs_id=1; // bs_id in {0, ..., bs_num-1}
	vector<unsigned int> nonzero_loc[2], final_diff;
	vector<unsigned int> *layer_diff;
	vector<unsigned int> *exclusive_intersection;
		for(unsigned int delay_type_id=0; delay_type_id<DELAY_TYPE_NUM; delay_type_id) {
			sen_id=0;
			for(unsigned int layer_inst_id=0; layer_inst_id<layer_instance_num; layer_inst_id++) {
				binary_index_decoder(sen_id, 0, layer_num-1, &nonzero_loc[0]);
				binary_index_decoder(sen_id, layer_num, layer_num+DELA, &nonzero_loc[1]);
				
				// Only one of delay types are imposed on every single DA whilst there must be at least one of layers taking into account
				// Otherwise, skipping this instance of evaluation.
				if(!(nonzero_loc[1].size() != 1 || nonzero_loc[0].size() == 0)) {
					unsigned int involved_layer_num = nonzero_loc[0].size();
					layer_diff = new vector<unsigned int> [involved_layer_num];
					for(unsigned int layer_cnt=0; layer_cnt<involved_layer_num; layer_cnt++) {
						if(last_chunk == 0) {
							group_intersection_cal(
								bs_id,
								sub_inst_id,
								nonzero_loc[1][0], 
								&nonzero_loc[0], 
								nonzero_loc[0].size(), 
								&layer_diff[layer_cnt]
							);
						}
						else { // last_chunk == 1
						}
					}
					// Exclusive intersection of all involved sub-rows across all involved layers
					if(involved_layer_num==1) {
						exclusive_intersection = new vector<unsigned int> [1];
						for (std::vector<unsigned int>::iterator it = layer_diff[0].begin() ; it != layer_diff[0].end(); ++it)
							exclusive_intersection[0].push_back(*it);
					}
					else {
						exclusive_intersection = new vector<unsigned int> [involved_layer_num-1];
						for(unsigned int i=0; i<involved_layer_num-1; i++) {
							if(i==0) intersection_cal(&layer_diff[0], &layer_diff[1], &exclusive_intersection[0]);
							else intersection_cal(&exclusive_intersection[i-1], &layer_diff[i+1], &exclusive_intersection[i]);
						}
					}
					// Finalising the exclusive intersection
					group_set_minus(
						bs_id,
						&exclusive_intersection[(involved_layer_num == 1) ? 0 : involved_layer_num-2], 
						nonzero_loc[1][0],
						&nonzero_loc[0], 
						nonzero_loc[0].size(), 
						&final_diff
					);
					delete [] exclusive_intersection;
					partial_layered_pa[sub_inst_id][delay_type_id].insert({sen_id, final_diff});
					cout << "MP_" << sen_id << ": ";

					vector<unsigned int>().swap(nonzero_loc[0]); vector<unsigned int>().swap(nonzero_loc[1]);
					delete [] layer_diff;
					vector<unsigned int>().swap(final_diff);
				}	
				sen_id+=1;			
			}
		}
}
*/
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
	
	sub_row_allocation();
	//srand(time(NULL));
}

unsigned int segment(unsigned int s, unsigned int t, unsigned int sub_size, unsigned int seg_size)
{
	return ((unsigned int) floor(((sub_size-s+t) % sub_size) / seg_size));
}
unsigned int segment_pos(unsigned int s, unsigned int t, unsigned int sub_size, unsigned int seg_size)
{
	return (unsigned int) (((sub_size-s+t) % sub_size) % seg_size);
}

void var_mem_init()
{
	v2c_base = ceil((dc*q)/BW_bram)*(inLayer_cnt);
}

/*
 Description:
 	According to the predefined row-split factor Ns, there are ceil(dc / Ns) number of Message Passing Blocks are physically implemented.
 	Thus, the following function is to determine the allocation of each sub-row block to one of ceil(dc / Ns) Message Passing Blocks 
*/
void sub_row_allocation()
{
	bs_num = dc/Ns;
	bs_alloc = new unsigned int* [bs_num];
	for(unsigned int bs_id=0; bs_id<bs_num; bs_id++) {
		bs_alloc[bs_id] = new unsigned int [Ns];
		for(unsigned int sub_row_id=0; sub_row_id<Ns; sub_row_id++)
			bs_alloc[bs_id][sub_row_id] = (sub_row_id*bs_num)+bs_id;
	}
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
	//sprintf(hdl_filename, "circular_page_align_%d_lib.v", submatrix_id);
	//ofstream hdl_fd; hdl_fd.open(hdl_filename, ofstream::out | ofstream::app);
	unsigned int memBank_addr;

	for(unsigned int cmd_id = 0; cmd_id < align_cmd_num; cmd_id++) {
		unsigned int circular_set_size = circular_delay_cmd[cmd_id].size();
		if(circular_set_size != 0 && cmd_id < (align_cmd_num-2)) {
			// One common command generator/logic is enough to be shared by the following elements
			pa_hdl_fd[submatrix_id] << "wire [1:0] sub_" << submatrix_id << "_circular_delay_cmd_" << base_set_id << "_" << cmd_id << ";" << endl
				   					<< "assign sub_" << submatrix_id << "_circular_delay_cmd_" << base_set_id << "_" << cmd_id
				   					<< " = " << circular_cmd_logic[base_set_id][cmd_id] << endl;

			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				pa_hdl_fd[submatrix_id] << "circular_page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u"
					   					<< memBank_addr
					   					<< " (.align_out (msg_out_" << memBank_addr
					   					<< "), .align_target_in (msg_in_" << memBank_addr
					   					<< "), .delay_cmd(sub_" << submatrix_id << "_circular_delay_cmd_" << base_set_id << "_" << cmd_id
					   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-2)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				pa_hdl_fd[submatrix_id] << "circular_page_align_depth_";
				if(base_set_id == 6) pa_hdl_fd[submatrix_id] << "2"; // 2-circular delay
				else if(base_set_id == 7) pa_hdl_fd[submatrix_id] << "1"; // 1-circular delay
				pa_hdl_fd[submatrix_id] << " #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
				       					<< " (.align_out (msg_out_" << memBank_addr
				       					<< "), .align_target_in (msg_in_" << memBank_addr
				       					<< "), .first_row_chunk(first_row_chunk), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-1)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				if(base_set_id < 6){
					pa_hdl_fd[submatrix_id] << "wire delay_cmd_" << memBank_addr << ";" << endl
						   					<< "align_cmd_gen_" << base_set_id
			    	   	   					<< " #(.LAYER_NUM (LAYER_NUM)) delay_cmd_u" << memBank_addr
			    	   	   					<< "(.delay_cmd(delay_cmd_" << memBank_addr
			    	   	   					<< "), .layer_status(layer_status[LAYER_NUM-1:0]));" << endl
			    	   	   					<< "page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
			    	   	   					<< "(.align_out (msg_out_" << memBank_addr
			    	   	   					<< "), .align_target_in (msg_in_" << memBank_addr
			    	   	   					<< "), .delay_cmd(delay_cmd_" << memBank_addr
			    	   	   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl << endl;
			    }
				else if(base_set_id == 6) {
					pa_hdl_fd[submatrix_id] << "page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   					<< "(.align_out(msg_out_" << memBank_addr
						   					<< "), .align_target_in (msg_in_" << memBank_addr
						   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			    }
				else if(base_set_id == 7) {
					pa_hdl_fd[submatrix_id] << "page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   					<< "(.align_out(msg_out_" << memBank_addr
						   					<< "), .align_target_in (msg_in_" << memBank_addr
						   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
				}
			}
		}
	}
}
/*
void circular_shift_param_header_gen(unsigned int submatrix_id,)
{
	//sprintf(hdl_filename, "circular_page_align_%d_lib.v", submatrix_id);
	//ofstream hdl_fd; hdl_fd.open(hdl_filename, ofstream::out | ofstream::app);
	unsigned int memBank_addr;

	for(unsigned int cmd_id = 0; cmd_id < align_cmd_num; cmd_id++) {
		unsigned int circular_set_size = circular_delay_cmd[cmd_id].size();
		if(circular_set_size != 0 && cmd_id < (align_cmd_num-2)) {
			// One common command generator/logic is enough to be shared by the following elements
			pa_hdl_fd[submatrix_id] << "wire [1:0] circular_delay_cmd_" << base_set_id << "_" << cmd_id << ";" << endl
				   					<< "assign circular_delay_cmd_" << base_set_id << "_" << cmd_id
				   					<< " = " << circular_cmd_logic[base_set_id][cmd_id] << endl;

			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				pa_hdl_fd[submatrix_id] << "circular_page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u"
					   					<< memBank_addr
					   					<< " (.align_out (msg_out_" << memBank_addr
					   					<< "), .align_target_in (msg_in_" << memBank_addr
					   					<< "), .delay_cmd(circular_delay_cmd_" << base_set_id << "_" << cmd_id
					   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-2)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				pa_hdl_fd[submatrix_id] << "circular_page_align_depth_";
				if(base_set_id == 6) pa_hdl_fd[submatrix_id] << "2"; // 2-circular delay
				else if(base_set_id == 7) pa_hdl_fd[submatrix_id] << "1"; // 1-circular delay
				pa_hdl_fd[submatrix_id] << " #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
				       					<< " (.align_out (msg_out_" << memBank_addr
				       					<< "), .align_target_in (msg_in_" << memBank_addr
				       					<< "), .first_row_chunk(first_row_chunk), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			}
		}
		else if(circular_set_size != 0 && cmd_id == (align_cmd_num-1)) {
			for(unsigned int msg_id = 0; msg_id < circular_set_size; msg_id++) {
				memBank_addr = circular_delay_cmd[cmd_id][msg_id];
				if(base_set_id < 6){
					pa_hdl_fd[submatrix_id] << "wire delay_cmd_" << memBank_addr << ";" << endl
						   					<< "align_cmd_gen_" << base_set_id
			    	   	   					<< " #(.LAYER_NUM (LAYER_NUM)) delay_cmd_u" << memBank_addr
			    	   	   					<< "(.delay_cmd(delay_cmd_" << memBank_addr
			    	   	   					<< "), .layer_status(layer_status[LAYER_NUM-1:0]));" << endl
			    	   	   					<< "page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
			    	   	   					<< "(.align_out (msg_out_" << memBank_addr
			    	   	   					<< "), .align_target_in (msg_in_" << memBank_addr
			    	   	   					<< "), .delay_cmd(delay_cmd_" << memBank_addr
			    	   	   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl << endl;
			    }
				else if(base_set_id == 6) {
					pa_hdl_fd[submatrix_id] << "page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   					<< "(.align_out(msg_out_" << memBank_addr
						   					<< "), .align_target_in (msg_in_" << memBank_addr
						   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
			    }
				else if(base_set_id == 7) {
					pa_hdl_fd[submatrix_id] << "page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u" << memBank_addr
						   					<< "(.align_out(msg_out_" << memBank_addr
						   					<< "), .align_target_in (msg_in_" << memBank_addr
						   					<< "), .sys_clk(sys_clk), .rstn(rstn));" << endl;
				}
			}
		}
	}
}
*/
void v2c_msg_pass_test_pattern(unsigned int submatrix_id)
{
#ifdef MSG_TO_BS_RAND_GEN
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
#endif
#ifdef MSG_TO_BS_INPUT_LOG
	std::string str_buf;
	std::string str_comma_buf;
	char *filename = new char [50];
	sprintf(filename, "submatrix_%d_v2c_to_bs.mem.csv", submatrix_id);
	std::ifstream logIn_fd(filename);

	unsigned int v2c_bs_out[layer_num][inLayer_cnt][Pc];
	unsigned int norm_col; // normalised column index
	unsigned int rand_temp, norm_col1, norm_row1;	
	string line, word, temp;
	unsigned int layer_id, row_chunk_id, col;
	layer_id = 0; row_chunk_id = 0;

	while(getline(logIn_fd, str_buf)) {
		std::istringstream i_stream(str_buf);

		col = 0;
		while(getline(i_stream, str_comma_buf, ',')) {
			printf("sub_%d, z:%d, Pc:%d, row_chunk_id:%d, col:%d, layer_id:%d\r\n", submatrix_id, z, Pc, row_chunk_id, col, layer_id);
			norm_col = (submatrix_id*z)+(Pc*row_chunk_id)+col;
			norm_row1 = layer[layer_id].PA[norm_col];
			norm_col1 = layer[layer_id].DS[norm_col];
			std::stringstream ss;
			ss << std::hex << str_comma_buf;
			cout << "str_comma_buf: " << str_comma_buf << dec << "\tlayer_id: " << layer_id << ", norm_row1: " << norm_row1 << ", norm_col1: " << norm_col1 << ", col: " << col << ", sub_" << submatrix_id << ", row_chunk_id: " << row_chunk_id << endl;
			ss >> v2c_bs_out[layer_id][norm_row1][norm_col1];
				cout << "v2c_bs_out["
					 << dec << layer_id << "][" 
					 << dec << norm_row1 
					 << "][" 
					 << dec << norm_col1 
					 << "]: " 
					 << hex << v2c_bs_out[layer_id][norm_row1][norm_col1] << endl;

			col+=1;
			// To make sure number of messages in each line does match the underlying decoder configuration
			if(col > Pc) {
				cout << "The format of given log file is wrong, where in each line of log filer, there suppose to contain " 
					 << Pc << " messages so as to message count within one Row Chunk Process; However, there are at least " << col << " messages inside one line of log." << endl;
				exit(1); 
			}
		}

		row_chunk_id+=1;
		layer_id = layer_id+(unsigned int) (row_chunk_id / inLayer_cnt);
		row_chunk_id = row_chunk_id % inLayer_cnt;
		if(layer_id > layer_num) {
				cout << "The format of given log file is wrong, where in the log filer, there suppose to contain " 
					 << layer_num << " Layer; However, there are at least " << layer_id << " layers inside log." << endl;
				exit(1); 		
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

	logIn_fd.close();
	hdl_fd1.close();
	delete [] filename;
#endif
}

void c2v_msg_pass_test_pattern(unsigned int submatrix_id)
{
#ifdef MSG_TO_BS_INPUT_LOG
	std::string str_buf;
	std::string str_comma_buf;
	char *filename = new char [50];
	sprintf(filename, "submatrix_%d_c2v_to_bs.mem.csv", submatrix_id);
	std::ifstream logIn_fd(filename);

	unsigned int v2c_bs_out[layer_num][inLayer_cnt][Pc];
	unsigned int norm_col; // normalised column index
	unsigned int rand_temp, norm_col1, norm_row1;	
	string line, word, temp;
	unsigned int layer_id, row_chunk_id, col;
	layer_id = 0; row_chunk_id = 0;

	while(getline(logIn_fd, str_buf)) {
		std::istringstream i_stream(str_buf);

		col = 0;
		while(getline(i_stream, str_comma_buf, ',')) {
			printf("sub_%d, z:%d, Pc:%d, row_chunk_id:%d, col:%d, layer_id:%d\r\n", submatrix_id, z, Pc, row_chunk_id, col, layer_id);
			norm_col = (submatrix_id*z)+(Pc*row_chunk_id)+col;
			norm_row1 = layer[layer_id].PA[norm_col];
			norm_col1 = layer[layer_id].DS[norm_col];
			std::stringstream ss;
			ss << std::hex << str_comma_buf;
			cout << "str_comma_buf: " << str_comma_buf << dec << "\tlayer_id: " << layer_id << ", norm_row1: " << norm_row1 << ", norm_col1: " << norm_col1 << ", col: " << col << ", sub_" << submatrix_id << ", row_chunk_id: " << row_chunk_id << endl;
			ss >> v2c_bs_out[layer_id][norm_row1][norm_col1];
				cout << "v2c_bs_out["
					 << dec << layer_id << "][" 
					 << dec << norm_row1 
					 << "][" 
					 << dec << norm_col1 
					 << "]: " 
					 << hex << v2c_bs_out[layer_id][norm_row1][norm_col1] << endl;

			col+=1;
			// To make sure number of messages in each line does match the underlying decoder configuration
			if(col > Pc) {
				cout << "The format of given log file is wrong, where in each line of log filer, there suppose to contain " 
					 << Pc << " messages so as to message count within one Row Chunk Process; However, there are at least " << col << " messages inside one line of log." << endl;
				exit(1); 
			}
		}

		row_chunk_id+=1;
		layer_id = layer_id+(unsigned int) (row_chunk_id / inLayer_cnt);
		row_chunk_id = row_chunk_id % inLayer_cnt;
		if(layer_id > layer_num) {
				cout << "The format of given log file is wrong, where in the log filer, there suppose to contain " 
					 << layer_num << " Layer; However, there are at least " << layer_id << " layers inside log." << endl;
				exit(1); 		
		}
	}

	sprintf(filename, "submatrix_%d_cn_to_mem.mem", submatrix_id);
	ofstream hdl_fd1; hdl_fd1.open(filename, ofstream::out);
	for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
		for(unsigned int row_chunk_id = 0; row_chunk_id < inLayer_cnt; row_chunk_id++) {
			for(unsigned int col = 0; col < Pc-1; col++) {
				hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][col] << ",";
			}
			hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][Pc-1] << endl;
		}
	}

	logIn_fd.close();
	hdl_fd1.close();
	delete [] filename;
#endif
}

void signExten_msg_pass_test_pattern(unsigned int submatrix_id)
{
#ifdef MSG_TO_BS_INPUT_LOG
	std::string str_buf;
	std::string str_comma_buf;
	char *filename = new char [50];
	sprintf(filename, "signExtenOut_sub%d", submatrix_id);
	std::ifstream logIn_fd(filename);

	unsigned int v2c_bs_out[layer_num][inLayer_cnt][Pc];
	unsigned int norm_col; // normalised column index
	unsigned int rand_temp, norm_col1, norm_row1;	
	string line, word, temp;
	unsigned int layer_id, row_chunk_id, col;
	layer_id = 0; row_chunk_id = 0;

	while(getline(logIn_fd, str_buf)) {
		std::istringstream i_stream(str_buf);

		col = 0;
		while(getline(i_stream, str_comma_buf, ',')) {
			printf("sub_%d, z:%d, Pc:%d, row_chunk_id:%d, col:%d, layer_id:%d\r\n", submatrix_id, z, Pc, row_chunk_id, col, layer_id);
			norm_col = (submatrix_id*z)+(Pc*row_chunk_id)+col;
			norm_row1 = layer[layer_id].PA[norm_col];
			norm_col1 = layer[layer_id].DS[norm_col];
			std::stringstream ss;
			ss << std::hex << str_comma_buf;
			cout << "str_comma_buf: " << str_comma_buf << dec << "\tlayer_id: " << layer_id << ", norm_row1: " << norm_row1 << ", norm_col1: " << norm_col1 << ", col: " << col << ", sub_" << submatrix_id << ", row_chunk_id: " << row_chunk_id << endl;
			ss >> v2c_bs_out[layer_id][norm_row1][norm_col1];
				cout << "v2c_bs_out["
					 << dec << layer_id << "][" 
					 << dec << norm_row1 
					 << "][" 
					 << dec << norm_col1 
					 << "]: " 
					 << hex << v2c_bs_out[layer_id][norm_row1][norm_col1] << endl;

			col+=1;
			// To make sure number of messages in each line does match the underlying decoder configuration
			if(col > Pc) {
				cout << "The format of given log file is wrong, where in each line of log filer, there suppose to contain " 
					 << Pc << " messages so as to message count within one Row Chunk Process; However, there are at least " << col << " messages inside one line of log." << endl;
				exit(1); 
			}
		}

		row_chunk_id+=1;
		layer_id = layer_id+(unsigned int) (row_chunk_id / inLayer_cnt);
		row_chunk_id = row_chunk_id % inLayer_cnt;
		if(layer_id > layer_num) {
				cout << "The format of given log file is wrong, where in the log filer, there suppose to contain " 
					 << layer_num << " Layer; However, there are at least " << layer_id << " layers inside log." << endl;
				exit(1); 		
		}
	}

	sprintf(filename, "baseline_mem_to_signExten_sub%d.mem.csv", submatrix_id);
	ofstream hdl_fd1; hdl_fd1.open(filename, ofstream::out);
	//for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
	for(unsigned int layer_id = 1; layer_id < 2; layer_id++) {
		for(unsigned int row_chunk_id = 0; row_chunk_id < inLayer_cnt; row_chunk_id++) {
			for(unsigned int col = 0; col < Pc-1; col++) {
				hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][col] << ",";
			}
			hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][Pc-1] << endl;
		}
	}

	logIn_fd.close();
	hdl_fd1.close();
	delete [] filename;
#endif
}

void chMsg_msg_pass_test_pattern(unsigned int submatrix_id)
{
#ifdef MSG_TO_BS_INPUT_LOG
	std::string str_buf;
	std::string str_comma_buf;
	char *filename = new char [50];
	//sprintf(filename, "ChMsg_to_bs/chMsg_to_bs.mem_sub%d", submatrix_id);
	sprintf(filename, "bs.in");
	std::ifstream logIn_fd(filename);

	unsigned int v2c_bs_out[layer_num][inLayer_cnt][Pc];
	unsigned int norm_col; // normalised column index
	unsigned int rand_temp, norm_col1, norm_row1;	
	string line, word, temp;
	unsigned int layer_id, row_chunk_id, col;
	layer_id = 0; row_chunk_id = 0;

	while(getline(logIn_fd, str_buf)) {
		std::istringstream i_stream(str_buf);

		col = 0;
		while(getline(i_stream, str_comma_buf, ',')) {
			//printf("sub_%d, z:%d, Pc:%d, row_chunk_id:%d, col:%d, layer_id:%d\r\n", submatrix_id, z, Pc, row_chunk_id, col, layer_id);
			norm_col = (submatrix_id*z)+(Pc*row_chunk_id)+col;
			norm_row1 = layer[layer_id].PA[norm_col];
			norm_col1 = layer[layer_id].DS[norm_col];
			std::stringstream ss;
			//ss << std::hex << str_comma_buf;
			cout << "str_comma_buf: " << str_comma_buf << dec << "\tlayer_id: " << layer_id << ", norm_row1: " << norm_row1 << ", norm_col1: " << norm_col1 << ", col: " << col << ", sub_" << submatrix_id << ", row_chunk_id: " << row_chunk_id << endl;
			//ss >> v2c_bs_out[layer_id][norm_row1][norm_col1];
				cout << "v2c_bs_out["
					 << dec << layer_id << "][" 
					 << dec << norm_row1 
					 << "][" 
					 << dec << norm_col1 
					 << "]: " 
					 << hex << v2c_bs_out[layer_id][norm_row1][norm_col1] << endl;

			col+=1;
			// To make sure number of messages in each line does match the underlying decoder configuration
			if(col > Pc) {
				cout << "The format of given log file is wrong, where in each line of log filer, there suppose to contain " 
					 << Pc << " messages so as to message count within one Row Chunk Process; However, there are at least " << col << " messages inside one line of log." << endl;
				exit(1); 
			}
		}

		row_chunk_id+=1;
		layer_id = layer_id+(unsigned int) (row_chunk_id / inLayer_cnt);
		row_chunk_id = row_chunk_id % inLayer_cnt;
		if(layer_id > layer_num) {
				cout << "The format of given log file is wrong, where in the log filer, there suppose to contain " 
					 << layer_num << " Layer; However, there are at least " << layer_id << " layers inside log." << endl;
				exit(1); 		
		}
	}

	sprintf(filename, "baseline_mem_to_chMsg_sub%d", submatrix_id);
	ofstream hdl_fd1; hdl_fd1.open(filename, ofstream::out);
	//for(unsigned int layer_id = 0; layer_id < layer_num; layer_id++) {
	for(unsigned int layer_id = 0; layer_id < 3; layer_id++) {
		for(unsigned int row_chunk_id = 0; row_chunk_id < inLayer_cnt; row_chunk_id++) {
			for(unsigned int col = 0; col < Pc-1; col++) {
				hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][col] << ",";
			}
			hdl_fd1 << hex << v2c_bs_out[layer_id][row_chunk_id][Pc-1] << endl;
		}
	}

	logIn_fd.close();
	hdl_fd1.close();
	delete [] filename;
#endif
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
