#include "../inc/ca_sched.hpp"

sys_tick::sys_tick(FREQ_UNIT freq_in, CYCLE_UNIT preload_cycle_in)
{
    freq_MHz = freq_in;
    preload_cycle = preload_cycle_in;
    cycle_count = preload_cycle;
}

void sys_tick::cycle_reset()
{
    cycle_count = preload_cycle;
}

void sys_tick::set_cycle_watermark(CYCLE_UNIT watermark_in)
{
    cycleCnt_watermark = watermark_in;
}

cycle_sched::cycle_sched(
    // Configureation of system tick
    FREQ_UNIT freq_config,
    CYCLE_UNIT preloadCycle_config
) {
    sysTick = new sys_tick(freq_config, preloadCycle_config);

    // To reset all halt conditions
    isLoop_halt = false;

    shiftCtrl_sim_wrapper = new shiftCtrlUnit_wrapper;
}

void cycle_sched::main_loop()
{
    int i, j;
    bool is_rqst_active[PIPELINE_STAGE_NUM];
    static shiftCtrl_state fsm_state_uncommit[PIPELINE_STAGE_NUM]; // Temporary FSM states of all active requests 
                                                                   // before resource arbitration
    static shiftCtrl_state fsm_state_prev1[PIPELINE_STAGE_NUM]; // FSM states of all active requests at one clock cycle before
    std::memset(is_rqst_active, (bool) true, sizeof(is_rqst_active));
    std::memset(fsm_state_uncommit, IDLE, sizeof(fsm_state_uncommit));
    std::memset(fsm_state_prev1, IDLE, sizeof(fsm_state_prev1));

    while(isLoop_halt == false) {
#ifdef SCHED_DEBUG_MODE
        SYSTICK_PRINT
#endif // SCHED_DEBUG_MODE
        //---------------------------------------------------------------
        // Step 1) Update the FSM state of each pipelined (H/W) resource
        //---------------------------------------------------------------
        // Handling the first PIPELINE_STAGE_NUM clock cycles 
        // after reset sequence
        if(sysTick -> cycle_count < PIPELINE_STAGE_NUM) {
            std::cout << "INIT" << std::endl;
            for(i=0; i<(sysTick -> cycle_count)+1; i++) {
                // To check if the underlying request is allowed to update 
                // its FSM state, s.t. the given design rule(s)
                is_rqst_active[i] = shiftCtrl_sim_wrapper->worst_sol.design_rule_check(
                    shiftCtrl_sim_wrapper->rqst_id[i],
                    shiftCtrl_sim_wrapper->rqst_fsm,
                    fsm_state_prev1
                );

                // To attempt an FSM update and sotre the result in a temporary variable 
                // which has not been uncommitted yet 
                fsm_state_uncommit[i] = shiftCtrl_sim_wrapper->shiftCtrl->fsm_update(
                    is_rqst_active[i], 
                    shiftCtrl_sim_wrapper->rqst_fsm[i], 
                    shiftCtrl_sim_wrapper->rqst_id[i]
                );           
            }
        } else {
            for(i=0; i<PIPELINE_STAGE_NUM; i++) {
                is_rqst_active[i] = shiftCtrl_sim_wrapper->worst_sol.design_rule_check(
                    shiftCtrl_sim_wrapper->rqst_id[i],
                    shiftCtrl_sim_wrapper->rqst_fsm,
                    fsm_state_prev1
                );

                fsm_state_uncommit[i] = shiftCtrl_sim_wrapper->shiftCtrl->fsm_update(
                    is_rqst_active[i], 
                    shiftCtrl_sim_wrapper->rqst_fsm[i], 
                    shiftCtrl_sim_wrapper->rqst_id[i]
                );
            }
        }
        //---------------------------------------------------------------
        // Step 2) Update the FSM state of each pipelined (H/W) resource
        //---------------------------------------------------------------
        // Resource arbitration and committing all update of FSM states
        shiftCtrl_sim_wrapper->worst_sol.arbiter_commit(
            fsm_state_uncommit, 
            shiftCtrl_sim_wrapper->rqst_fsm
        );
#ifdef WORST_SOL_DEBUG_MODE
        for(j=0; j<PIPELINE_STAGE_NUM; j++) {std::cout << "loop (" << is_rqst_active[j]<<") -> "; FSM_HEAD_PRINT(shiftCtrl_sim_wrapper->rqst_fsm[j], j) std::cout << "\n";}std::cout << "\n";
#endif // WORST_SOL_DEBUG_MODE
        // To store the current FSM states of all active requests
        for(i=0; i<PIPELINE_STAGE_NUM; i++) {
#ifdef SHIFT_DEBUG_MODE
            FSM_HEAD_PRINT(fsm_state_prev1[i], i)
            std::cout << " --> ";

            FSM_HEAD_PRINT(shiftCtrl_sim_wrapper->rqst_fsm[i], i)
            std::cout << std::endl;
#endif // SHIFT_DEBUG_MODE   

            fsm_state_prev1[i] = shiftCtrl_sim_wrapper->rqst_fsm[i];
                        
            // To update the read pointer of message-pass buffer for precedent constraint
            if(shiftCtrl_sim_wrapper->rqst_fsm[i] == COL_ADDR_ARRIVAL)
                shiftCtrl_sim_wrapper->worst_sol.update_read_pointer();
        }

#ifdef WORST_SOL_DEBUG_MODE
        shiftCtrl_sim_wrapper->worst_sol.display_read_ptr();
#endif // WORST_SOL_DEBUG_MODE

        //---------------------------------------------------------------
        // Step ) Incrementing clock cycle and controlling the loop
        //---------------------------------------------------------------
        sysTick -> cycle_count += 1;
        // To check the loop halting condition
        if(sysTick -> cycle_count == sysTick -> cycleCnt_watermark) isLoop_halt = true;
    }
}
