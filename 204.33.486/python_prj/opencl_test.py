import pyopencl as cl
import numpy as np

cntxt = cl.create_some_context()
queue = cl.CommandQueue(cntxt)

# Create some data array to five as input to Kernel and get output
num1 = np.array(range(10), dtype=np.int32)
num2 = np.array(range(10), dtype=np.int32)
out = np.empty(num1.shape, dtype=np.int32)

# Create the buffers to hold the values of the input
num1_buf = cl.Buffer(cntxt, cl.mem_flags.READ_ONLY | cl.mem_flags.COPY_HOST_PTR, hostbuf=num1)
num2_buf = cl.Buffer(cntxt, cl.mem_flags.READ_ONLY | cl.mem_flags.COPY_HOST_PTR, hostbuf=num2)

# Create output buffer
out_buf = cl.Buffer(cntxt, cl.mem_flags.WRITE_ONLY, out.nbytes)


# Kernel Program
code = """
__kernel void frst_prog(__global int *num1, __global int *num2, __global int *out)
{
    int i = get_global_id(0);
    out[i] = num1[i]*num1[i]+num2[i]*num2[i];
}
"""

# Build the Kernel
bld = cl.Program(cntxt, code).build()
# Kernel is now launched
launch = bld.frst_prog(queue, num1.shape, num1_buf, num2_buf, out_buf)
# Wait till the process completes
launch.wait()

cl.enqueue_read_buffer(queue, out_buf, out).wait()
print("Number_1:", num1)
print("Number_2:", num2)
print("Output:", out)
