#include "../inc/common.hpp"

// Mailbox to exchange information between shit_control_unit and decoding system, i.e. cycle-accurate simulator
bool is_2nd_shiftOut[RQST_NUM]; // To indicate that the 2nd allocation sequence has been completed
unsigned short allcSeq_cnt[RQST_NUM]; // To count the number of processed allocation sequences for the underlying reqeust set

// Related to the message-pass buffer 
MSGPASS_BUFFER_RADDR msgBuffer_raddr_vec[SHARE_GP_NUM];
msgPass_buffer_t layered_msgPass_buffer[DEC_LAYER_NUM];
unsigned int msgPass_buf_raddr_iter;