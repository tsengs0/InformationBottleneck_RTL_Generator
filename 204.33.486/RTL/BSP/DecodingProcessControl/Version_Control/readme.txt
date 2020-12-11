1. sys_control_unit.1_cyele_of_cnu_rd.v
As regarding to the first design, the symmetry of CNU, VNU and DNU strutures was not taken into account. Therefore, the all cnu_rd of Q-bit are asserted in a left-shift manner (same as vnu_rd and dnu_rd). That is, the assertion state of any two adjocent bits is just one clock cycle apart from each other.

After redsigning the above structure, each pair of adjocent bits is asserted once every three clock cycles where one symmetric 2-LUT takes three clock cycles.

However, such three clock cycle latency is just designed in a relatively conservative insight, where the routing congestion during synthesis process is further considered. Perhaps one clock cycle propogation delay is enough for one symmetric 2-LUT. Accordingly, this assumption ought to be further confirmed afterwards.
