#include <iostream>
#include <cstdio>
#include <cstdlib>
#include "../inc/shift_ctrl.hpp"
#include "../inc/ca_sched.hpp"

extern unsigned short *colBankID_gp2;

int main(int argc, char **argv)
{
    // To configure the IB-LUT column banks which are in
    // the cold subgroup, i.e. GP2 bank group
    colBankID_gp2 = new unsigned short[GP2_NUM];
    for(int i=0; i<GP2_NUM; i++) {
        colBankID_gp2[i] = std::atoi(argv[i+1]);
    }

    shift_control_unit shiftCtrl(colBankID_gp2);
    cycle_sched main_sched(
        (FREQ_UNIT) 200, // 200 MHz
        (CYCLE_UNIT) 0 // Preloaded cycle count=0
    );

    main_sched.sysTick -> set_cycle_watermark(20);
    main_sched.main_loop();

    
    return 0;
}