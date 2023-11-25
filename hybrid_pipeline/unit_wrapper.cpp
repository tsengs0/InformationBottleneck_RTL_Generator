#include "../inc/ca_sched.hpp"

extern COL_ADDR *colBankID_gp2;

shiftCtrlUnit_wrapper::shiftCtrlUnit_wrapper()
{
    // To set the "shift control unit" as DUT
    shiftCtrl = new shift_control_unit(colBankID_gp2);
//    shiftCtrl -> show_regfile();

    // To initialise all requestors that are registered, to IDLE state
    std::memset(rqst_fsm, IDLE, sizeof(rqst_fsm));

    // Requestor IDs start from 0, 1, ...
    for(int i=0; i<PIPELINE_STAGE_NUM; i++) rqst_id[i] = i;
}