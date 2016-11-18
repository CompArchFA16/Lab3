#!/bin/bash

echo "compiling submodule test suite"
iverilog -o full.o full.t.v
echo "running submodule test suite: 1 = Pass, 0 = Fail"
./full.o

echo "compiling cpu test bench"
iverilog -o cputest.o cpu.t.v
echo "running CPU test"
./cputest.o

echo "compiling and running waveform generation test"
iverilog -o wavetest.o cputest.t.v
./wavetest.o

echo "opening gtkwave"
gtkwave cpu.vcd

rm *.o
