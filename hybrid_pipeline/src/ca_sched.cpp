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
    static shiftCtrl_state fsm_state_prev1[PIPELINE_STAGE_NUM]; // FSM states of all active requests at one clock cycle before
    std::memset(is_rqst_active, (bool) true, sizeof(is_rqst_active));
    for(i=0; i<PIPELINE_STAGE_NUM; i++) fsm_state_prev1[i] = IDLE;


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
                is_rqst_active[i] = shiftCtrl_sim_wrapper->worst_sol.design_rule_check(
                    shiftCtrl_sim_wrapper->rqst_id[i],
                    shiftCtrl_sim_wrapper->rqst_fsm,
                    fsm_state_prev1
                );

                // To store the current FSM states of all active requests
                fsm_state_prev1[i] = shiftCtrl_sim_wrapper->rqst_fsm[i];

                shiftCtrl_sim_wrapper->shiftCtrl->fsm_update(
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

                // To store the current FSM states of all active requests
                fsm_state_prev1[i] = shiftCtrl_sim_wrapper->rqst_fsm[i];

                shiftCtrl_sim_wrapper->shiftCtrl->fsm_update(
                    is_rqst_active[i], 
                    shiftCtrl_sim_wrapper->rqst_fsm[i], 
                    shiftCtrl_sim_wrapper->rqst_id[i]
                );
            }
        }
        //---------------------------------------------------------------
        // Step 2) Update the FSM state of each pipelined (H/W) resource
        //---------------------------------------------------------------

        //---------------------------------------------------------------
        // Step ) Incrementing clock cycle and controlling the loop
        //---------------------------------------------------------------
        sysTick -> cycle_count += 1;
        // To check the loop halting condition
        if(sysTick -> cycle_count == sysTick -> cycleCnt_watermark) isLoop_halt = true;
    }
}
