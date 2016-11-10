run-cpu: build-cpu
	./cpu.o

build-cpu:
	iverilog -Wall -o cpu.o cpu.t.v

build-gate_ex_mem: 
	iverilog -Wall -o gate_ex_mem.o gate_ex_mem.v

build-gate_mem_wb: 
	iverilog -Wall -o gate_mem_wb.o gate_mem_wb.v

clean:
	rm *.o *.vcd
