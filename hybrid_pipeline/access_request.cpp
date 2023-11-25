#include "../inc/access_request.hpp"

msgBuffer_requestor::msgBuffer_requestor()
{
    fsm_state = IDLE;
    is_active = false;
}

bool msgBuffer_requestor::rqst_dispatch()
{
    is_active = true;
    return is_active;
}