#! /bin/bash
iverilog -Wall -o alu alu.t.v
./alu
iverilog -Wall -o pc pc.t.v
./pc
iverilog -Wall -o mux mux.t.v
./mux
iverilog -Wall -o instrT instrTest.t.v
./instrT
# insert Tom's regfile.t.v here
iverilog -o scpu singlecyclecpu.t.v
./scpu
