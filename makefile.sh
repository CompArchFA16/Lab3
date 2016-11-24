#! /bin/bash
iverilog -o scpu singlecyclecpu.t.v
./scpu
iverilog -Wall -o alu alu.t.v
./alu
iverilog -o pc pc.t.v
./pc
iverilog -Wall -o mux mux.t.v
./mux
iverilog -Wall -o se signExtend.t.v
./se
iverilog -Wall -o instrT instrTest.t.v
./instrT
iverilog -Wall -o reggie regfile.t.v
./reggie
