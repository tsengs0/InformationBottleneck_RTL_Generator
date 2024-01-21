# Handling timing of the skid buffer operation
On the design of shfit control unit, although the input of *SHFIT_GEN* state is from the *READ_COL_ADDR* state, the MUX of the skid buffer is controlled by the output the *SHIFT_GEN* state. Therefore, the simulation of the pipeline behaviour across the sequence: 
<pre>
rqst_flag_gen().input -> 
rqst_flag_gen().output/*regFile_IF.raddr_i assignment*/ -> 
skid_buffer.buffer_operate() -> 
shift_gen().input -> 
shift_gen().output
</pre> 
has to be implememented as the follows (the design sequence and the actual implementation sequence are different):
<pre>
rqst_flag_gen().input -> 
rqst_flag_gen().output/*assignment of the tentative regFile_IF.raddr_i */
shift_gen().output.step0/*isGtr is feedbacked to the 
                    upcoming skid_buffer process*/ -> 
skid_buffer.buffer_operate() -> 
shift_gen().input/*re-assignment of the real regFile_IF.raddr_i 
                   according to the result of the skid buffer*/ ->
shift_gen().output.step1
</pre>
