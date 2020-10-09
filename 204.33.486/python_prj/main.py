import fib
import subprocess
subprocess.call(["cython", "-a", "fib.pyx"])
fib.fib(2000)
