CC=iverilog
OUT=run.out

all:
	echo "make {alu, id, se, reg}"

cpu: cpu.v cpu.t.v
	$(CC) -o $(OUT) cpu.t.v && ./$(OUT)

alu: alu.v alu.t.v
	$(CC) -o $(OUT) alu.t.v && ./$(OUT)

id: instructionDecoder.v instructionDecoder.t.v
	$(CC) -o $(OUT) instructionDecoder.t.v && ./$(OUT)

se: signExtend.v signExtend.t.v
	$(CC) -o $(OUT) signExtend.t.v && ./$(OUT)

reg: regfile.v regfile.t.v
	$(CC) -o $(OUT) regfile.t.v && ./$(OUT)

memory: memory.v memory.t.v
	$(CC) -o $(OUT) memory.t.v && ./$(OUT)

mux32: mux32.t.v mux.v
	$(CC) -o $(OUT) mux32.t.v && ./$(OUT)

signExtend: signExtend.v signExtend.t.v
	$(CC) -o $(OUT) signExtend.t.v && ./$(OUT)

clean:
	rm -r $(OUT)
