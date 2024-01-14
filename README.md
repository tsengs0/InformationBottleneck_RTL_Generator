# A software-based simulation to verify the feasibility of the proposed "Hybrid Pipeline Scheduling" for the shared memory scheme

![Alt text](https://github.com/tsengs0/InformationBottleneck_RTL_Generator/blob/memShare_hybridPipeline_sim/sim_design_spec_21.Nov.2023.png)

# Work record - 14, Jan., 2023
- src/ca_sched.cpp
  - Temporary change of update_read_pointer() revoking condition
```c++
            // To update the read pointer of message-pass buffer for precedent constraint
            if(shiftCtrl_sim_wrapper->rqst_fsm[i] == COL_ADDR_ARRIVAL) {
                //14, Jan., 2023 -> if(shiftCtrl_sim_wrapper->worst_sol.rqst_arrival_cnt==1)
                    shiftCtrl_sim_wrapper->worst_sol.update_read_pointer();
            }
```

# Cheat sheet about Git commands
<pre>
> git push -u origin origin/memShare_hybridPipeline_sim # To push the latest commit onto the detached HEAD (but the remote branch is still unchanged)
> git push origin HEAD:memShare_hybridPipeline_sim # To push the current detached HEAD onto the remote branch
> git pull origin memShare_hybridPipeline_sim # To pull down all the changes from the remote branch
</pre>
