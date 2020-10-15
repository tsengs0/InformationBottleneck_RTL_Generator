#!/bin/bash

dot -Tfig $1.gv -o $1.fig;
dot -Tps $1.gv -o $1.ps && ps2pdf ./$1.ps;
evince ./$1.pdf
