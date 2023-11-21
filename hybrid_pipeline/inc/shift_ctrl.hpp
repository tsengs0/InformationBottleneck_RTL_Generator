#ifndef __SHIFT_CTRL_H
#define __SHIFT_CTRL_H
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>

#include "../inc/common.hpp"

#define PIPELINE_STAGE_NUM 3
#define FSM_HEAD_PRINT(FSM_STATE, RESOURCE_ID) \
    switch(FSM_STATE) { \
        case IDLE: std::cout << "IDLE (HW_" << RESOURCE_ID << ")"; break; \
        case COL_ADDR_ARRIVAL: std::cout << "COL_ADDR_ARRIVAL (HW_" << RESOURCE_ID << ")"; break; \
        case READ_COL_ADDR: std::cout << "READ_COL_ADDR (HW_" << RESOURCE_ID << ")"; break; \
        case SHIFT_GEN: std::cout << "SHIFT_GEN (HW_" << RESOURCE_ID << ")"; break; \
        case SHIFT_OUT: std::cout << "SHIFT_OUT (HW_" << RESOURCE_ID << ")"; break; \
        default: break; \
    }

//==============================================================
// Text identifier of L1PA configuration read file
//==============================================================
enum {
    PATTERN_ID = 0,
    GP2_RQST_PATTERN = 1,
    L1PA_SPR = 2,
    SEQ_ELEMENT_ID = 3
};
//==============================================================
//
//==============================================================
typedef enum FSM_STATE {
    IDLE = 0,
    COL_ADDR_ARRIVAL = 1,
    READ_COL_ADDR = 2,
    SHIFT_GEN = 3,
    SHIFT_OUT = 4
} shiftCtrl_state;
//==============================================================
//
//==============================================================
typedef struct skid_buffer {
    // Output port(s)
    unsigned short buffer_dout_o;

    // Input port(s)
    unsigned short buffer_din_i;
    bool isColAddr_skid_i;

    // N-depth buffer
    unsigned short *col_addr;
} skid_buffer_t;
//==============================================================
//
//==============================================================
typedef struct shiftCtrl_regfile {
    short l1pa_shift;
    short l1pa_delta;
    bool isGtr;
} shiftCtrl_regfile_page;
//==============================================================
//
//==============================================================
typedef struct regfile_inteface {
    // Output
    shiftCtrl_regfile_page page_out;

    // Input
    unsigned short raddr_i;
} regFile_IF_t;
//==============================================================
//
//==============================================================
typedef struct pipeline_register_bank {
    shiftCtrl_state fsm_state[PIPELINE_STAGE_NUM];
} pipeline_regBank_t;
//==============================================================
//
//==============================================================
class shift_control_unit {
    private:
        std::string fsm_state_header[5];
        unsigned short *colBankID_gp2;
        unsigned short col_addr[SHARE_GP_NUM]; // The lates address to be input to address-mapping unit
        std::vector<shiftCtrl_regfile_page> shiftCtrl_regfile;
        unsigned short rqst_gp2;
        regFile_IF_t regFile_IF;
        short shift_gen_out[2];

        // Pipeline resource
        pipeline_regBank_t pipeline_regBank;

    public:
        shift_control_unit(unsigned short *colBankID_gp2_config);
        void fsm_update(bool is_active, shiftCtrl_state &fsm_state, unsigned short resourceID);
        void col_addr_receive(unsigned short *col_addr_in);
        void col_addr_read();
        void shift_gen();
        short shift_out(unsigned short alloc_cycle_id);
        void fsm_process(unsigned short fsm_state);

        // For debugging
        void show_regfile();
};
#endif // __SHIFT_CTRL_H