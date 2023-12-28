#include "../inc/pipeline_sol.hpp"

extern float msgPass_buf_raddr_iter;

worst_case_solution::worst_case_solution()
{
    msgBuffer_read_ptr = 0;
    rqst_arrival_cnt = 0;
}

void worst_case_solution::update_read_pointer()
{
    msgBuffer_read_ptr = (msgBuffer_read_ptr == RQST_NUM-1) ? 0 : msgBuffer_read_ptr+1;
}

void worst_case_solution::display_read_ptr()
{
    std::cout << "#Read pointer of message-pass buffer: " << msgBuffer_read_ptr << std::endl;
}

#ifdef WORST_SOL_0
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

    // Rule 1: to check if any request was at "COL_ADDR_ARRIVAL" state one clock cycle before
    for(i=0; i<PIPELINE_STAGE_NUM; i++) {
        if(i != rqst_id) {
#ifdef WORST_SOL_DEBUG_MODE
            std::cout << "Checked rqstID: " << i << ", ";
            FSM_HEAD_PRINT(fsm_state_prev1[i], i)
            std::cout << "\t->\t";
            FSM_HEAD_PRINT(fsm_state_cur[i], i)
            std::cout << std::endl;
#endif // WORST_SOL_DEBUG_MODE
            if(fsm_state_prev1[i] == COL_ADDR_ARRIVAL) {
                is_colAddr_arrival_prev1 = true;
                break;
            }
        }
    }

    // Rule 2: to impose the precedent constraint:
    // Once the Nth request completes on allocation sequence, the next launch must not
    // be enabled before the completion of the relative (N-1) request
    if(fsm_state_cur[rqst_id] == SHIFT_OUT) {
        if(is_colAddr_arrival_prev1 == false && msgBuffer_read_ptr != rqst_id)
            is_colAddr_arrival_prev1 = true;
    }

    // Do not activate the current request if design rule is violated
    return (is_colAddr_arrival_prev1 == true) ? false : true;
}

void worst_case_solution::arbiter_commit(
    shiftCtrl_state *fsm_state_uncommit,
    shiftCtrl_state *fsm_state_commit
) {
// FSM_STATE:
//  IDLE = 0,
//  COL_ADDR_ARRIVAL = 1,
//  READ_COL_ADDR = 2,
//  SHIFT_GEN = 3,
//  SHIFT_OUT = 4
    static int i; 
    static bool is_resource_busy[FSM_STATE_NUM];
    for(i=0; i<FSM_STATE_NUM; i++) is_resource_busy[i] = false;
    
    // Arbitration policy: smaller the value of reqeust ID, higher the priority
    for(i=0; i<PIPELINE_STAGE_NUM; i++) {
        // Since IDLE state is not actually a resource,
        // there is not contention of IDLE state across all active requests
        if(fsm_state_uncommit[i] == IDLE) {
            fsm_state_commit[i] = IDLE;
        } else if(is_resource_busy[ fsm_state_uncommit[i] ] == false) {
//            std::cout << "HW_" << i << " (Uncommitted): "; FSM_HEAD_PRINT(fsm_state_uncommit[i], i) std::cout << std::endl;
            fsm_state_commit[i] = fsm_state_uncommit[i];
            is_resource_busy[ fsm_state_uncommit[i] ] = true;
        }
    }
}
#endif // WORST_SOL_0

#ifdef WORST_SOL_1
bool worst_case_solution::design_rule_check(
    unsigned short rqst_id,
    shiftCtrl_state *fsm_state_cur,
    shiftCtrl_state *fsm_state_prev1
) {

    // Do not activate the current request if design rule is violated

    static int i;
    static bool is_colAddr_arrival_prev1;
    is_colAddr_arrival_prev1 = false;

#ifdef WORST_SOL_DEBUG_MODE
    std::cout << std::endl << "RqstID: " << rqst_id << std::endl;
#endif // WORST_SOL_DEBUG_MODE

    // Rule 1: to check if any request was at "COL_ADDR_ARRIVAL" state one clock cycle before
    for(i=0; i<PIPELINE_STAGE_NUM; i++) {
        if(i != rqst_id) {
#ifdef WORST_SOL_DEBUG_MODE
            std::cout << "Checked rqstID: " << i << ", ";
            FSM_HEAD_PRINT(fsm_state_prev1[i], i)
            std::cout << "\t->\t";
            FSM_HEAD_PRINT(fsm_state_cur[i], i)
            std::cout << std::endl;
#endif // WORST_SOL_DEBUG_MODE
            if(fsm_state_prev1[i] == COL_ADDR_ARRIVAL) {
                is_colAddr_arrival_prev1 = true;
                break;
            }
        }
    }

    // Rule 2: to impose the precedent constraint:
    // Once the Nth request completes its allocation sequence, the next launch must not
    // be enabled before the completion of the relative (N-1) request
    if(fsm_state_cur[rqst_id] == SHIFT_OUT) {
        if(is_colAddr_arrival_prev1 == false && (msgBuffer_read_ptr-1) != rqst_id) // Since the msgBuffer_read_ptr represents the read address for the next transaction,
                                                                                   // the relative rqst_id is thereby (msgBuffer_read_ptr-1)
            is_colAddr_arrival_prev1 = true;
    }

    // Do not activate the current request if design rule is violated
    return (is_colAddr_arrival_prev1 == true) ? false : true;
}

void worst_case_solution::arbiter_commit(
    shiftCtrl_state *fsm_state_uncommit,
    shiftCtrl_state *fsm_state_commit
) {
// FSM_STATE:
//  IDLE = 0,
//  COL_ADDR_ARRIVAL = 1,
//  READ_COL_ADDR = 2,
//  SHIFT_GEN = 3,
//  SHIFT_OUT = 4
    static int i; 
    static bool is_resource_busy[FSM_STATE_NUM];
    for(i=0; i<FSM_STATE_NUM; i++) is_resource_busy[i] = false;
    
    // Arbitration policy: smaller the value of reqeust ID, higher the priority
    for(i=0; i<RQST_NUM; i++) {
        // Since IDLE state is not actually a resource,
        // there is no contention of IDLE state across all active requests
        if(fsm_state_uncommit[i] == IDLE) {
            fsm_state_commit[i] = IDLE;
        } else if(is_resource_busy[ fsm_state_uncommit[i] ] == false) {
//            std::cout << "HW_" << i << " (Uncommitted): "; FSM_HEAD_PRINT(fsm_state_uncommit[i], i) std::cout << std::endl;
            fsm_state_commit[i] = fsm_state_uncommit[i];
            is_resource_busy[ fsm_state_uncommit[i] ] = true;
        }

        if(fsm_state_commit[i] == COL_ADDR_ARRIVAL) {
            rqst_arrival_cnt = (rqst_arrival_cnt == 1) ? 0 : 1; // rqst_arrival_cnt+1
        }
    }
}
#endif // WORST_SOL_1
