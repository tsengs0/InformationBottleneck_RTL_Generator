#include "../inc/pipeline_sol.hpp"

worst_case_solution::worst_case_solution()
{

}

bool worst_case_solution::design_rule_check(
    unsigned short rqst_id,
    shiftCtrl_state *fsm_state_cur,
    shiftCtrl_state *fsm_state_prev1
) {
    static int i;
    static bool is_colAddr_arrival_prev1;
    is_colAddr_arrival_prev1 = false;

#ifdef WORST_SOL_DEBUG_MODE
    std::cout << std::endl << "RqstID: " << rqst_id << std::endl;
#endif // WORST_SOL_DEBUG_MODE

    // To check if any request was at "COL_ADDR_ARRIVAL" state one clock cycle before
    for(i=0; i<PIPELINE_STAGE_NUM; i++) {
        if(i != rqst_id) {
#ifdef WORST_SOL_DEBUG_MODE
            std::cout << "Checked rqstID: " << i << ", ";
            FSM_HEAD_PRINT(fsm_state_prev1[i], i)
            std::cout << "\t->\t";
            FSM_HEAD_PRINT(fsm_state_cur[i], i)
            std::cout << std::endl;
#endif // WORST_SOL_DEBUG_MODE
            if(fsm_state_cur[i] == COL_ADDR_ARRIVAL || fsm_state_prev1[i] == COL_ADDR_ARRIVAL) {
                is_colAddr_arrival_prev1 = true;
                break;
            }
        }
    }

    // Do not activate the current request if design rule is violated
    return (is_colAddr_arrival_prev1 == true) ? false : true;
}
/*
typedef enum FSM_STATE {
    IDLE = 0,
    COL_ADDR_ARRIVAL = 1,
    READ_COL_ADDR = 2,
    SHIFT_GEN = 3,
    SHIFT_OUT = 4
} shiftCtrl_state;
*/