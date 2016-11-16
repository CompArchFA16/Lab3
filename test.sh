rm -rf build
rm -rf waveforms
mkdir build
mkdir waveforms
# iverilog -o ./build/test_datamemory ./tests/datamemory.t.v
# iverilog -o ./build/test_registerfile ./tests/registerfile.t.v
# iverilog -o ./build/test_signextender ./tests/signextender.t.v
iverilog -o ./build/test_alu ./tests/alu.t.v
# iverilog -o ./build/test_controller ./tests/controller.t.v
# ./build/test_datamemory
# ./build/test_registerfile
# ./build/test_signextender
./build/test_alu
# ./build/test_controller