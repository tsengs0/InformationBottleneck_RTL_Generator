#include <iostream>
#include <cstdio>
#include <cstdlib>
#include "../inc/shift_ctrl.hpp"
#include "../inc/ca_sched.hpp"

extern COL_ADDR *colBankID_gp2;

// Global variables to model the decoder behaviour
unsigned short dec_cur_layer;

int main(int argc, char **argv)
{
    // To configure the IB-LUT column banks which are in
    // the cold subgroup, i.e. GP2 bank group
    colBankID_gp2 = new unsigned short[GP2_NUM];
    for(int i=0; i<GP2_NUM; i++) {
        colBankID_gp2[i] = std::atoi(argv[i+1]);
    }

    cycle_sched main_sched(
        (FREQ_UNIT) 200, // 200 MHz
        (CYCLE_UNIT) 0 // Preloaded cycle count=0
    );

    main_sched.sysTick -> set_cycle_watermark(7);
    main_sched.main_loop();

    
    return 0;
}
/*
    static int i;
    static msgPass_buffer_page_t buffer_rdata;

    std::srand(std::time(0));
    for(i=0; i<SHARE_GP_NUM; i++) {
        // Tentative - 24th Nov., 2023
        buffer_rdata.shiftCtrl_colAddr_buf2shift[i] = std::rand() % (0x1 << (QUAN_SIZE-1));

        shiftCtrl_pipeline_reg.col_addr_ff[i] = buffer_rdata.shiftCtrl_colAddr_buf2shift[i];
    }
*/