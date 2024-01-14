// Cycle-accurate scheduler
#ifndef __CA_SCHED__H
#define __CA_SCHED__H

#include <iostream>
#include <cstring>
#include "../inc/shift_ctrl.hpp"
#include "../inc/pipeline_sol.hpp"
#include "../inc/access_request.hpp"
#include "../inc/common.hpp"

#define SYSTICK_PRINT \
    std::cout << std::endl << "----------------------------------" << std::endl \
              << "@ T" << sysTick -> cycle_count << std::endl;

typedef unsigned short FREQ_UNIT;
typedef unsigned long long CYCLE_UNIT;
//==============================================================
// System Tick
//==============================================================
class sys_tick {
    private:
        FREQ_UNIT freq_MHz;
        CYCLE_UNIT preload_cycle;

    public:
        // To make it public for less overhead of function call (incrementing cycle count)
        CYCLE_UNIT cycle_count;
        CYCLE_UNIT cycleCnt_watermark;

        sys_tick(FREQ_UNIT freq_in, CYCLE_UNIT preload_cycle_in);
        void cycle_reset();
        void set_cycle_watermark(CYCLE_UNIT watermark_in);
};
//==============================================================
// Wrapper for simulating the hardware unit, shift control unit
//==============================================================
class shiftCtrlUnit_wrapper {
    private:

    public:
        shift_control_unit *shiftCtrl;
        msgBuffer_requestor *msgBuffer_rqst;
        worst_case_solution worst_sol;

        shiftCtrl_state rqst_fsm[RQST_NUM];
        unsigned short rqst_id[RQST_NUM];
         
        shiftCtrlUnit_wrapper();
};
//==============================================================
//
//==============================================================
class cycle_sched {
    private:
        // Wrapper for simulating the hardware unit, shift control unit
        shiftCtrlUnit_wrapper *shiftCtrl_sim_wrapper;

        // Halt conditions
        bool isLoop_halt;

    public:
        sys_tick *sysTick;

        cycle_sched(
            // Configureation of system tick
            FREQ_UNIT freq_config,
            CYCLE_UNIT preloadCycle_config
        );

        // To collect the values of read pointers for the W^{s} message-pass buffer, and store in the local array, msgBuffer_raddr_vec
        void msgBuffer_init(char *MSGPASS_BUFFER_INIT_FILENAME);
        void msgBuffer_display();

        void main_loop(); // Infinite loop simulating cycle-based envrionment

        void unit_test(MSGPASS_BUFFER_RADDR raddr_id);
};
#endif // __CA_SCHED__H
