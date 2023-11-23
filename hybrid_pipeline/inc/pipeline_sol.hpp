#ifndef __PIPELINE_SOL_H
#define __PIPELINE_SOL_H

#include <iostream>
#include "../inc/shift_ctrl.hpp"

//==============================================================
//
//==============================================================
class worst_case_solution {
    private:
        unsigned short msgBuffer_read_ptr;

    public:
        worst_case_solution();
        void update_read_pointer();
        void display_read_ptr();
        bool design_rule_check(
            unsigned short rqst_id,
            shiftCtrl_state *fsm_state_cur,
            shiftCtrl_state *fsm_state_prev1
        );

        void arbiter_commit(
            shiftCtrl_state *fsm_state_uncommit,
            shiftCtrl_state *fsm_state_commit    
        );
};

#endif // __PIPELINE_SOL_H