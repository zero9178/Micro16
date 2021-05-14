# Micro16

This repository contains an VHDL implementation of the Micro16, a very minimal CPU used for teaching purposes at the technical university of Vienna. 
As my very first VHDL project I chose this CPU for its simplicity and familiarity.
A very broad overview of it's instructions and capability can be viewed here
https://vowi.fsinf.at/wiki/TU_Wien:Technische_Grundlagen_der_Informatik_VU_(Kastner)/Kapitel_Micro16 (German)


The project is written in VHDL 1993, inside of Intel Quartus 20.1 as well as ghdl. For debugging I mostly used Modelsim Altera, for executing all regression tests I used ghdl.
My target FPGA is a 10M16SAU169C8G, on a Arrow MAX 1000 board.

Also check out my C subset compiler for the Micro 16 I wrote in F# from scratch:
https://github.com/zero9178/Micro16C
