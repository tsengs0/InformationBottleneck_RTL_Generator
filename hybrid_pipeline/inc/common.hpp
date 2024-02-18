#ifndef __COMMON_H
#define __COMMON_H

#define SCHED_DEBUG_MODE
#define SHIFT_DEBUG_MODE
//#define WORST_SOL_DEBUG_MODE
//#define ENSKID_SOL_DEBUG_MODE
#define MSGBUF_RD_PTR_DEBUG_EN // To enable the print of current read pointer of message-pass buffer
//#define MSGBUF_MEM_DEBUG_EN // To enable the print of entire content inside the message-pass buffer
//#define UNIT_TEST_MODE
#define SKID_BUFFER_DEBUG

//==============================================================
// Fundamental of decoder configuration
//==============================================================
#define QUAN_SIZE 3
#define DEC_LAYER_NUM 1
#define GP2_NUM 2
#define SHARE_GP_NUM 5
#define RQST_NUM 6
#define MAX_ALLOC_SEQ_NUM 2 // constraint of which guanrantees the maximum number of the allocation sequences required in a requestor
//==============================================================
// Message-pase buffer
// Instatiation policy:
//    Instantiating an array of msgPass_buffer_page_t as a message-
//    pass buffer which contains one layer's corresponding messages.
//==============================================================
#define MSGPASS_BUFFER_INIT_NAME  "config/msgPassBuffer_Ws5_pattern0.csv"
#define MSGPASS_BUFFER_PERM_C2V_PAGE_NUM 10
#define PERM_C2V_ADDR_BASE 0 // The base address to store the permuted C2Vs in the message-pass buffer
// Text identifier of message-pass buffer preload pattern
enum msgPassBuf_initPattern_e{
    ADDR = 0,
    LAYER_ID = 1,
    MSG_TYPE = 2,
    MSG_QUANT = 3,
    MSG_NUM = 4,
    MSG_0 = 5
};
typedef unsigned int MSGPASS_BUFFER_RADDR;
typedef unsigned short COL_ADDR;
typedef struct msgPass_buffer {
    COL_ADDR perm_c2v_mag[MSGPASS_BUFFER_PERM_C2V_PAGE_NUM][SHARE_GP_NUM]; // magnitude of permuted C2V
} msgPass_buffer_t;

//==============================================================
// The macros for the "pipeline_sol.cpp"
//==============================================================

//#define WORST_SOL_0
#define WORST_SOL_1

#endif // __COMMON_H
