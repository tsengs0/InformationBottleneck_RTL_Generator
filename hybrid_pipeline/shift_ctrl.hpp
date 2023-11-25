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
#include <bitset>
#include <ctime>

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
#define FSM_STATE_NUM 5
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
// Message-pase buffer
//==============================================================
typedef unsigned int MSGPASS_BUFFER_RADDR;
typedef unsigned short COL_ADDR;
typedef struct msgPass_buffer_page {
    COL_ADDR shiftCtrl_colAddr_buf2shift[SHARE_GP_NUM]; // tentative
} msgPass_buffer_page_t;
//==============================================================
// L1PA shift-control register file
//==============================================================
typedef unsigned short RQST_FLAG;
typedef unsigned short REGFILE_RADDR;
typedef short SHIFT_SIG;
typedef short SHIFT_DELTA_SIG;
#define MIN_REGFILE_RADDR 0
#define MAX_REGFILE_RADDR (((REGFILE_RADDR) 0x1 << SHARE_GP_NUM)-1)
typedef struct shiftCtrl_regfile {
    SHIFT_SIG l1pa_shift;
    SHIFT_DELTA_SIG l1pa_delta;
    bool isGtr;
} shiftCtrl_regfile_page;
//==============================================================
// For exporting log file
//==============================================================
typedef struct shiftCtrlUnit_outputData {
    SHIFT_SIG l1pa_shift;
    bool isGtr;
} shiftCtrlUnit_outputData_t;
//==============================================================
//
//==============================================================
typedef struct regfile_inteface {
    // Output
    shiftCtrl_regfile_page page_out;

    // Input
    REGFILE_RADDR raddr_i;
} regFile_IF_t;
//==============================================================
//
//==============================================================
typedef struct pipeline_reg {
    // Pipeline stage 0
    COL_ADDR col_addr_ff[SHARE_GP_NUM];
    // Pipeline stage 1
    shiftCtrl_regfile_page regfile_page_ff;
    SHIFT_DELTA_SIG shiftDelta_interFF;
    // Pipeline stage 2
    SHIFT_SIG l1pa_shift_ff;
} pipeline_reg_t;
//==============================================================
//
//==============================================================
class shift_control_unit {
    private:
        // Input of this simulator
        MSGPASS_BUFFER_RADDR msgBuffer_raddr_vec[SHARE_GP_NUM];

        std::string fsm_state_header[5];
        COL_ADDR *colBankID_gp2;
        COL_ADDR col_addr[SHARE_GP_NUM]; // The lates address to be input to address-mapping unit
        std::vector<shiftCtrl_regfile_page> shiftCtrl_regfile;
        RQST_FLAG rqst_gp2;

        // Output of shift control unit (after the last pipeline stage)
        SHIFT_SIG l1pa_shift_out;
        bool isGtr_out;

        // For exporting the log file
        std::vector<shiftCtrlUnit_outputData_t> shiftCtrlUnit_logData;

    public:
        pipeline_reg_t shiftCtrl_pipeline_reg; // Pipeline resource
        regFile_IF_t regFile_IF; // I/F of shift ctrl. register file (internal LUT)

        shift_control_unit(COL_ADDR *colBankID_gp2_config);
        shiftCtrl_state fsm_update(bool is_active, shiftCtrl_state fsm_state, unsigned short resourceID);
        void msgBuffer_raddr_in(MSGPASS_BUFFER_RADDR *raddr_vec_in);
        void msgBuffer_read();
        void rqst_flag_gen(COL_ADDR *col_addr_in);
        bool regfile_read();
        void shift_gen();
        short shift_out(bool is_2nd_shiftOut);
        void fsm_process(shiftCtrl_state fsm_state, bool is_2nd_shiftOut);

        // For exporting the log file
        void shiftOut_export();
        void shiftOut_log_read();

        // For debugging
        void show_regfile();
};
#endif // __SHIFT_CTRL_H