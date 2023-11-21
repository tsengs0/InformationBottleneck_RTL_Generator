#ifndef __ACCESS_REQUEST_H
#define __ACCESS_REQUEST_H

#include "../inc/common.hpp"
#include "../inc/shift_ctrl.hpp"

class msgBuffer_requestor {
    private:
        shiftCtrl_state fsm_state;
        bool is_active;

    public:
        msgBuffer_requestor();
        bool rqst_dispatch();
};
#endif // __ACCESS_REQUEST_H