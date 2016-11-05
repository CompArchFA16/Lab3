run-cpu: build-cpu
	./cpu.o

build-cpu:
	iverilog -Wall -o cpu.o cpu.t.v

clean:
	rm *.o *.vcd
