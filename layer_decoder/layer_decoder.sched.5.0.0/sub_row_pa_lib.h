#ifndef __SUB_ROW_PA_LIB_H
#define __SUB_ROW_PA_LIB_H
#include "main.h"

#define DELAY_TYPE_NUM 2 // '0': one-cycle delay; '1': Ns-cycle delay
#define DELAY_TYPE_NUM_BITWIDTH DELAY_TYPE_NUM+1 // additional 1 representing the last_row_chunk


/*--------------------------------------------*/
// Row-Split Manipulation
void sub_row_allocation(void);
bool element_search(unsigned int val, vector<unsigned int> *vec);
void union_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset);
void intersection_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset);
void difference_cal(vector<unsigned int> *inA, vector<unsigned int> *inB, vector<unsigned int> *new_subset);
void binary_index_decoder(unsigned int bin_cmd, unsigned int segment_start, unsigned int segment_end, vector<unsigned int> *loc_set);

void group_intersection_cal(unsigned int bs_id, unsigned int sub_row_id, unsigned int layer_id, vector<unsigned int> *loc_vec, unsigned int loc_num, vector<unsigned int> *new_subset);
void group_set_minus(unsigned int bs_id, vector<unsigned int> *target_subset, unsigned int delay_type_id, vector<unsigned int> *layer_vec, unsigned int layer_vec_num, vector<unsigned int> *new_subset);
struct compare
{
	int key;
	compare(int const &i): key(i) { }

	bool operator()(int const &i) {
		return (i == key);
	}
};
#endif // __SUB_ROW_PA_LIB_H