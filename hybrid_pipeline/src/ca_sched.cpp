#include "../inc/ca_sched.hpp"

extern unsigned short dec_cur_layer;
extern MSGPASS_BUFFER_RADDR msgBuffer_raddr_vec[SHARE_GP_NUM];
extern msgPass_buffer_t layered_msgPass_buffer[DEC_LAYER_NUM];
extern unsigned int msgPass_buf_raddr_iter;
extern bool is_2nd_shiftOut[RQST_NUM];
extern unsigned short allcSeq_cnt[RQST_NUM];

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

    shiftCtrl_sim_wrapper = new shiftCtrlUnit_wrapper();
    msgBuffer_init((char*) MSGPASS_BUFFER_INIT_NAME);
#ifdef MSGBUF_MEM_DEBUG_EN
    msgBuffer_display();
#endif // MSGBUF_MEM_DEBUG_EN
}

void cycle_sched::msgBuffer_init(char *MSGPASS_BUFFER_INIT_FILENAME)
{
    std::string config_filename = (std::string) MSGPASS_BUFFER_INIT_FILENAME;
    std::string str_buf;
    std::string str_conma_buf;
    unsigned short line_cnt, text_cnt;
    unsigned short pattern_addr;
    unsigned short layer_id, msg_quant, msg_num, msg_temp, msg_cnt;
    std::ifstream ifs_csv_file(MSGPASS_BUFFER_INIT_FILENAME);

    msg_cnt = 0; line_cnt = 0;
    if(!ifs_csv_file.is_open()) {
        std::cout << "Failed to open the configuration file: " 
                  << config_filename << std::endl;
        exit(1);
    } else {
        while (getline(ifs_csv_file, str_buf)) {    
            // To read string with separator of comma
            std::istringstream i_stream(str_buf);
            if(line_cnt == 0) {
                // Doing nothing at the header line
            } else { // To start read the line of csv file from the second line
                text_cnt = 0;
                while (getline(i_stream, str_conma_buf, ',')) {
                    if(text_cnt == msgPassBuf_initPattern_e::ADDR)
                        pattern_addr = (unsigned short) std::stoi(str_conma_buf);
                    else if(text_cnt == msgPassBuf_initPattern_e::LAYER_ID)
                        layer_id = (unsigned short) std::stoi(str_conma_buf);
                    else if(text_cnt == msgPassBuf_initPattern_e::MSG_TYPE) {

                    }
                    else if(text_cnt == msgPassBuf_initPattern_e::MSG_QUANT) {
                        msg_quant = (unsigned short) std::stoi(str_conma_buf);
                        if(msg_quant != QUAN_SIZE) {
                            std::cout << "The quantisation level of every message is set to " << QUAN_SIZE
                                      << ", however the level set in the msgPass_buffer pattern file is " << msg_quant << std::endl;
                            exit(1);
                        }
                    }
                    else if(text_cnt == msgPassBuf_initPattern_e::MSG_NUM) {
                        msg_num = (unsigned short) std::stoi(str_conma_buf);
                        if(msg_num != SHARE_GP_NUM) {
                            std::cout << "The number of messages stored in one msgPass_buffer is set to " << SHARE_GP_NUM
                                      << ", however the number set in the msgPass_buffer pattern file is " << msg_num << std::endl;
                            exit(1);
                        }
                        msg_cnt = 0;             
                    }
                    else if(text_cnt >= msgPassBuf_initPattern_e::MSG_0) {
                        if(msg_cnt >= msg_num) {
                            std::cout << "Exceeded the number of the messages which is supposed to be stored in a msgPass_buffer page" << std::endl;
                            exit(1);
                        }
                        msg_temp = (unsigned short) std::stoi(str_conma_buf);
                        layered_msgPass_buffer[layer_id].perm_c2v_mag[pattern_addr][msg_cnt] = msg_temp;
                        msg_cnt += 1;
                    }
                    else {
                        std::cout << "Exception from the text counting" << std::endl;
                        exit(1);
                    }
                    text_cnt = (text_cnt == msgPassBuf_initPattern_e::MSG_0+msg_num-1) ? 0 : text_cnt+1;
                }
            }
            line_cnt += 1;
        }
    }
}

void cycle_sched::msgBuffer_display()
{
    for(int l=0; l<DEC_LAYER_NUM; l++) {
        std::cout << "Decoding layer: " << l << std::endl;
        for(int j=0; j<MSGPASS_BUFFER_PERM_C2V_PAGE_NUM; j++) {
            std::cout << "Permuted C2V: ";
            for(int k=0; k<SHARE_GP_NUM; k++) {
                std::cout << layered_msgPass_buffer[l].perm_c2v_mag[j][k] << " ";
            }
            std::cout << std::endl;
        }
        std::cout << "------------------------------------------" << std::endl;
    }
}

void cycle_sched::main_loop()
{
    int i;
    bool is_rqst_active[RQST_NUM];
    // To indicate that the 2nd allocation sequence has been completed
    static shiftCtrl_state fsm_state_uncommit[RQST_NUM]; // Temporary FSM states of all active requests 
                                                         // before resource arbitration
    static shiftCtrl_state fsm_state_prev1[RQST_NUM]; // FSM states of all active requests at one clock cycle before
    std::memset(is_rqst_active, (bool) true, sizeof(is_rqst_active));
    std::memset(is_2nd_shiftOut, (bool) true, sizeof(is_2nd_shiftOut));
    std::memset(fsm_state_uncommit, IDLE, sizeof(fsm_state_uncommit));
    std::memset(fsm_state_prev1, IDLE, sizeof(fsm_state_prev1));
    std::memset(allcSeq_cnt, (unsigned short) 0, sizeof(allcSeq_cnt));
    dec_cur_layer = 0;
    msgPass_buf_raddr_iter = 0;

#ifdef UNIT_TEST_MODE
    for(MSGPASS_BUFFER_RADDR raddr_id=0; raddr_id<MSGPASS_BUFFER_PERM_C2V_PAGE_NUM; raddr_id++)
        unit_test(raddr_id);
        exit(0);
#endif // UNIT_TEST_MODE

    while(isLoop_halt == false) {
#ifdef SCHED_DEBUG_MODE
        SYSTICK_PRINT
#endif // SCHED_DEBUG_MODE

        //---------------------------------------------------------------
        // Step 1) Update the FSM state of each pipelined (H/W) resource
        //---------------------------------------------------------------
        // Handling the first PIPELINE_STAGE_NUM clock cycles after reset sequence
        for(i=0; i<RQST_NUM; i++) {
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

        //---------------------------------------------------------------
        // Step 2) Update the FSM state of each pipelined (H/W) resource
        //---------------------------------------------------------------
        // Resource arbitration and committing all update of FSM states
        shiftCtrl_sim_wrapper->worst_sol.arbiter_commit(
            fsm_state_uncommit, 
            shiftCtrl_sim_wrapper->rqst_fsm
        );

#ifdef WORST_SOL_DEBUG_MODE
        for(int j=0; j<RQST_NUM; j++) {std::cout << "loop (" << is_rqst_active[j]<<") -> "; FSM_HEAD_PRINT(shiftCtrl_sim_wrapper->rqst_fsm[j], j) std::cout << "\n";}std::cout << "\n";
#endif // WORST_SOL_DEBUG_MODE
        // To store the current FSM states of all active requests
        for(i=0; i<RQST_NUM; i++) {
#ifdef SHIFT_DEBUG_MODE
            FSM_HEAD_PRINT(fsm_state_prev1[i], i)
            std::cout << " --> ";

            FSM_HEAD_PRINT(shiftCtrl_sim_wrapper->rqst_fsm[i], i)
            std::cout << std::endl;
#endif // SHIFT_DEBUG_MODE   

            fsm_state_prev1[i] = shiftCtrl_sim_wrapper->rqst_fsm[i];
                        
            // To update the read pointer of message-pass buffer for precedent constraint
            if(shiftCtrl_sim_wrapper->rqst_fsm[i] == COL_ADDR_ARRIVAL) {
                if(shiftCtrl_sim_wrapper->worst_sol.rqst_arrival_cnt==1)
                    shiftCtrl_sim_wrapper->worst_sol.update_read_pointer();
            }

            shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(
                shiftCtrl_sim_wrapper->rqst_fsm[i], 
                shiftCtrl_sim_wrapper->rqst_id[i]
            );

            if(shiftCtrl_sim_wrapper->rqst_fsm[i]==SHIFT_OUT) {
                if(shiftCtrl_sim_wrapper->shiftCtrl->isGtr_out==false) {
                    allcSeq_cnt[i] = 0;
                    is_2nd_shiftOut[i] = true;
                } else if(allcSeq_cnt[i] == MAX_ALLOC_SEQ_NUM) {
                        allcSeq_cnt[i] =  0;
                        is_2nd_shiftOut[i] = true;
                } else {
                    is_2nd_shiftOut[i] = false;
                }
            }
        }

                // To check if allcSeq_cnt ought to be reset, and update the is_2nd_shiftOut
        for(i=0; i<RQST_NUM; i++) {

        }

#ifdef MSGBUF_RD_PTR_DEBUG_EN
        shiftCtrl_sim_wrapper->worst_sol.display_read_ptr();
        shiftCtrl_sim_wrapper->shiftCtrl->shiftOut_log_read();
#endif // MSGBUF_RD_PTR_DEBUG_EN
        //---------------------------------------------------------------
        // Step ) Incrementing clock cycle and controlling the loop
        //---------------------------------------------------------------
        sysTick -> cycle_count += 1;
        // To check the loop halting condition
        if(sysTick -> cycle_count == sysTick -> cycleCnt_watermark) isLoop_halt = true;
    }
}

void cycle_sched::unit_test(MSGPASS_BUFFER_RADDR raddr_id)
{
    int i;
    shiftCtrl_sim_wrapper -> shiftCtrl -> show_regfile();
    std::cout << "---------------------------------" << std::endl;
    //shiftCtrl_sim_wrapper->shiftCtrl->msgBuffer_read();
    MSGPASS_BUFFER_RADDR msgPass_buf_raddr_vec[SHARE_GP_NUM] = {raddr_id, raddr_id, raddr_id, raddr_id, raddr_id}; 
    shiftCtrl_sim_wrapper->shiftCtrl->msgBuffer_raddr_in(msgPass_buf_raddr_vec);
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(COL_ADDR_ARRIVAL, 0/*rqstID=0*/);
    for(i=0; i<SHARE_GP_NUM; i++) 
        std::cout << "Col_addr: " <<  shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.col_addr_ff[i] << std::endl;

    //shiftCtrl_sim_wrapper->shiftCtrl->rqst_flag_gen(shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.col_addr_ff);
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(READ_COL_ADDR, 0/*rqstID=0*/);
    std::cout << "Rqst flag: " 
              << std::bitset<SHARE_GP_NUM>(shiftCtrl_sim_wrapper->shiftCtrl->regFile_IF.raddr_i) << std::endl;
    //shiftCtrl_sim_wrapper->shiftCtrl->regfile_read();

    //shiftCtrl_sim_wrapper->shiftCtrl->shift_gen();
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(SHIFT_GEN, 0/*rqstID=0*/);
    std::cout << "Shift: " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.l1pa_shift << std::endl
              << "Delta (intermediate FFs): " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.shiftDelta_interFF << std::endl
//              << "Delta (final): " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.l1pa_delta << std::endl
              << "isGtr (intermediate FF): " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.isGtr << std::endl;
    is_2nd_shiftOut[0]/*rqstID=0*/ = false;
    //shiftCtrl_sim_wrapper->shiftCtrl->shift_out(0/*rqstID=0*/);
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(SHIFT_OUT, 0/*rqstID=0*/);

    //shiftCtrl_sim_wrapper->shiftCtrl->shift_gen();
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(SHIFT_GEN, 0/*rqstID=0*/);
//    std::cout << "\n1cc later -> Shift: " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.l1pa_shift << std::endl
//              << "1cc later -> Delta (intermediate FFs): " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.shift_delta_ff << std::endl
//              << "1cc later -> Delta (final): " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.l1pa_delta << std::endl
//              << "1cc later -> isGtr: " << shiftCtrl_sim_wrapper->shiftCtrl->shiftCtrl_pipeline_reg.regfile_page_ff.isGtr << std::endl;
    is_2nd_shiftOut[0]/*rqstID=0*/ = true;
    //shiftCtrl_sim_wrapper->shiftCtrl->shift_out(0/*rqstID=0*/);
    shiftCtrl_sim_wrapper->shiftCtrl->fsm_process(SHIFT_OUT, 0/*rqstID=0*/);

    shiftCtrl_sim_wrapper->shiftCtrl->shiftOut_log_read();
}
