#ifndef __PIPELINE_SOL_H
#define __PIPELINE_SOL_H

#include <iostream>
#include "../inc/shift_ctrl.hpp"

//==============================================================
// Worst-case Solution (reference)
//==============================================================
class worst_case_solution {
    private:

    public:
        unsigned short rqst_arrival_cnt;
        
        worst_case_solution();
        void update_read_pointer();
        void display_read_ptr();
        bool design_rule_check(
            unsigned short rqst_id,
            shiftCtrl_state *fsm_state_cur,
            shiftCtrl_state *fsm_state_prev1
        );

        void arbiter_commit(
            bool *is_DRC_passed,
            shiftCtrl_state *fsm_state_uncommit,
            shiftCtrl_state *fsm_state_commit    
        );
};
//==============================================================
// Solution 2 (enhanced): skid buffer insertion
//==============================================================
class enhanced_skidInsert_sol {
    private:
        bool pipeline_cancel;

        // "True" if Xth rqst is 2seq, otherwise "False"
        bool requestors_2seq[RQST_NUM];

        // for design rule 1, 2 and 3
        bool is_dr1_matched, is_dr2_matched, is_dr3_matched;

        // The requestor ID which is detected as the 2seq at the "SHIFT_GEN" state
        unsigned short _2seq_rqst_id;

    public:
        unsigned short rqst_arrival_cnt;
       
        
        enhanced_skidInsert_sol();
        void update_read_pointer(unsigned short rqst_id);
        void display_read_ptr();
        bool design_rule_check(
            unsigned short rqst_id,
            shiftCtrl_state *fsm_state_cur,
            shiftCtrl_state *fsm_state_prev1,
            bool isGtr
        );

        void arbiter_commit(
            bool *is_DRC_passed,
            shiftCtrl_state *fsm_state_uncommit,
            shiftCtrl_state *fsm_state_commit    
        );
};

#endif // __PIPELINE_SOL_H