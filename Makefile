run: run-cpu run-ram

run-cpu: build-cpu
	@./cpu.o | make exclude

build-cpu:
	@iverilog -Wall -o cpu.o cpu.t.v

run-ram: build-ram
	@./ram.o | make exclude

build-ram:
	@iverilog -Wall -o ram.o ram.t.v

exclude:
	@grep -v "VCD info: dumpfile"

clean:
	@rm *.o *.vcd
