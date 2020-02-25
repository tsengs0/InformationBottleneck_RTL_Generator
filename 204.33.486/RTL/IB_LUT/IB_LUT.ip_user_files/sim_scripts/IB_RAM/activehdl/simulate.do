onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+IB_RAM -L xpm -L xil_defaultlib -L blk_mem_gen_v8_4_4 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.IB_RAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {IB_RAM.udo}

run -all

endsim

quit -force
