#/bin/sh

mkdir -p work && cd work
ghdl-llvm -i --workdir=. ../*.vhd
# Register new top level entities/tests here
ghdl-llvm -m --workdir=. Micro16_tb

