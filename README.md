# A software-based simulation to verify the feasibility of the proposed "Hybrid Pipeline Scheduling" for the shared memory scheme

This branch is to simulate the hybrid pipeline scheduling in which a skid buffer mechanism is inserted.

![Alt text](https://github.com/tsengs0/InformationBottleneck_RTL_Generator/blob/memShare_hybridPipeline_sim/sim_design_spec_21.Nov.2023.png)

# Work record - 14, Jan., 2024
- src/ca_sched.cpp
  - Temporary change of update_read_pointer() revoking condition
```c++
            // To update the read pointer of message-pass buffer for precedent constraint
            if(shiftCtrl_sim_wrapper->rqst_fsm[i] == COL_ADDR_ARRIVAL) {
                //14, Jan., 2023 -> if(shiftCtrl_sim_wrapper->worst_sol.rqst_arrival_cnt==1)
                    shiftCtrl_sim_wrapper->worst_sol.update_read_pointer();
            }
```
# Work record - 20, Jan., 2024
- commit: daf2c5c4a7db9eee9b7cc5341d291f13ddc8f9a3
 - To finish the implementation of skid buffer unit with unit test (passed)

# Work record - 18, Feb., 2024
- commit: 767febdf24385b14549e3e5eb97165eac396da1b
 - Work summary: first implementation of the design rule 1, 2 and 3 (ongoing)
 - Concern 1: the isColAddr_skid pin is either SKID or NOSKID, the strategy is no longer just given by the current value of isGtr. Instead, the skid control strategy have to be reconsidered
 - Concern 2: the reset control of the deltaFF have to be reconsidered 

# Cheat sheet about Git commands
<pre>
> git push -u origin origin/memShare_hybridPipeline_skidBuffer_sim # To push the latest commit onto the detached HEAD (but the remote branch is still unchanged)
> git push origin HEAD:memShare_hybridPipeline_skidBuffer_sim # To push the current detached HEAD onto the remote branch
> git pull origin memShare_hybridPipeline_skidBuffer_sim # To pull down all the changes from the remote branch
</pre>
