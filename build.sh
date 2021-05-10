#/bin/sh

mkdir -p work && cd work
ghdl-llvm -i --workdir=. ../*.vhd
ghdl-llvm -m --workdir=. Micro16_tb

