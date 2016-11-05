run-david-tests: build-david-tests
	./david_tests.o

build-david-tests:
	iverilog -Wall -o david_tests.o david_tests.t.v
