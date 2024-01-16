#include "../inc/pipeline_sol.hpp"

extern int msgBuffer_read_ptr;

worst_case_solution::worst_case_solution()
{
    msgBuffer_read_ptr = -1; // Read pointer must be started from "0"
    rqst_arrival_cnt = 0;
}

void worst_case_solution::update_read_pointer()
{
    msgBuffer_read_ptr = (msgBuffer_read_ptr == RQST_NUM-1) ? 0 : msgBuffer_read_ptr+1;
}

void worst_case_solution::display_read_ptr()
{
    std::cout << "|-----> #Read pointer of message-pass buffer: " << msgBuffer_read_ptr << std::endl;
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
    static int i;
    static bool is_colAddr_arrival_prev1; // Rule 1
//    static bool is_precedent_complete; // Rule 2
    static bool is_DRC_passed; // Conclusion of DRC
    is_colAddr_arrival_prev1 = false;
//    is_precedent_complete = true;
    is_DRC_passed = true;

#ifdef WORST_SOL_DEBUG_MODE
    std::cout << std::endl << "RqstID: " << rqst_id << std::endl;
#endif // WORST_SOL_DEBUG_MODE

    // Rule 1: to check if any request was at "COL_ADDR_ARRIVAL" state within the previous clock cycle
    for(i=0; i<RQST_NUM; i++) {
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
    if(
        fsm_state_cur[rqst_id] == SHIFT_OUT || // Next FSM_STATE might be COL_ADDR_ARRIVAL
        fsm_state_cur[rqst_id] == SHIFT_OUT_DELTA ||// Next FSM_STATE might be COL_ADDR_ARRIVAL
        fsm_state_cur[rqst_id] == IDLE // Next FSM_STATE might be COL_ADDR_ARRIVAL
    ) {
        if(is_colAddr_arrival_prev1 == true) {
            is_DRC_passed = false;
        }
        else if(
            (unsigned short) ((msgBuffer_read_ptr+1) % RQST_NUM) != rqst_id // Let allocate all the msgPass buffer's pages
                                                                        // of which the addresses are the multiple of rqst_id value,
                                                                        // to the rqeustor[rqst_id]
        ) {
//          is_precedent_complete = false;
//          std::cout << "          ## rqst_id: " << rqst_id << ", msgBuffer_read_ptr: " << msgBuffer_read_ptr
//                    << ", (msgBuffer_read_ptr+1) % RQST_NUM = " << (unsigned short) (msgBuffer_read_ptr+1) % RQST_NUM
//                    << std::endl;
            is_DRC_passed = false; 
        }
    } else {
        is_DRC_passed = true;
    }

#ifdef WORST_SOL_DEBUG_MODE
    std::cout << "##### rqst_id: " << rqst_id << ", is_colAddr_arrival_prev1: " << is_colAddr_arrival_prev1
              << ", is_DRC_passed: " << is_DRC_passed << std::endl;
#endif // WORST_SOL_DEBUG_MODE

    // Do not activate the current request if design rule is violated
    return is_DRC_passed;
}

void worst_case_solution::arbiter_commit(
    bool *is_DRC_passed,
    shiftCtrl_state *fsm_state_uncommit,
    shiftCtrl_state *fsm_state_commit
) {
// FSM_STATE:
//  IDLE = 0,
//  COL_ADDR_ARRIVAL = 1,
//  READ_COL_ADDR = 2,
//  SHIFT_GEN = 3,
//  SHIFT_OUT = 4
//  SHIFT_OUT_DELTA = 5
    static int i; 
    static bool is_resource_busy[FSM_STATE_NUM];
    for(i=0; i<FSM_STATE_NUM; i++) is_resource_busy[i] = false;
    
    // Arbitration policy: smaller the value of reqeust ID, higher the priority
    for(i=0; i<RQST_NUM; i++) {
        // Since IDLE state is not actually a resource,
        // there is no contention of IDLE state across all active requests
//        std::cout << "HW_" << i << " (Uncommitted): "; FSM_HEAD_PRINT(fsm_state_uncommit[i], i) std::cout << std::endl;
//        std::cout << "---> " << "is_resource_busy[ fsm_state_uncommit[" << i << "] ]: " << is_resource_busy[ fsm_state_uncommit[i] ] << ", is_DRC_passed[" << i <<"]: " << is_DRC_passed[i] << std::endl;
        if(fsm_state_uncommit[i] == IDLE) {
            fsm_state_commit[i] = IDLE;
        } else if(is_resource_busy[ fsm_state_uncommit[i] ] == false) {
            if(is_DRC_passed[i] == true) {
                fsm_state_commit[i] = fsm_state_uncommit[i];
                is_resource_busy[ fsm_state_uncommit[i] ] = true;
            } else { // In case that the DRC is not passed
                if(fsm_state_uncommit[i] == COL_ADDR_ARRIVAL) {
                    fsm_state_commit[i] = IDLE;
                } 
                // Wrong guesss: SHFIT_OUT -> COL_ADDR_ARRIVAL
                // Reality: SHFIT_OUT -> SHFIT_OUT_DELTA
                else if(fsm_state_uncommit[i] == SHIFT_OUT_DELTA) {
                    is_DRC_passed[i] = true;
                    fsm_state_commit[i] = fsm_state_uncommit[i];
                    is_resource_busy[ fsm_state_uncommit[i] ] = true;    
                }
            }
        }

        if(fsm_state_commit[i] == COL_ADDR_ARRIVAL) {
            rqst_arrival_cnt = (rqst_arrival_cnt == 1) ? 0 : 1; // rqst_arrival_cnt+1
        }
    }
}
#endif // WORST_SOL_1
