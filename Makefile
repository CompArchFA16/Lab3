run-cpu: build-cpu
	./cpu.o

build-cpu:
	iverilog -Wall -o cpu.o cpu.t.v

build-exmem_reg: 
	iverilog -Wall -o exmem_reg.o exmem_reg.v

build-memwb_reg: 
	iverilog -Wall -o memwb_reg.o memwb_reg.v

clean:
	rm *.o *.vcd
