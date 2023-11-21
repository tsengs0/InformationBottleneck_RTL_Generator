#ifndef __PIPELINE_SOL_H
#define __PIPELINE_SOL_H

#include <iostream>
#include "../inc/shift_ctrl.hpp"

//==============================================================
//
//==============================================================
class worst_case_solution {
    private:

    public:
        worst_case_solution();
        bool design_rule_check(
            unsigned short rqst_id,
            shiftCtrl_state *fsm_state_cur,
            shiftCtrl_state *fsm_state_prev1
        );
};

#endif // __PIPELINE_SOL_H