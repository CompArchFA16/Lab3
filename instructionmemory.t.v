//------------------------------------------------------------------------
// Instruction Memory Test Bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

module test_instructionmemory ();
    reg[31:0] PC;
    wire[31:0] dataOut;

    instructionmemory dut(PC, dataOut);

    reg             dutpassed;

    initial begin
    // $dumpfile("instructionmemory.vcd");
    // $dumpvars();

    dutpassed = 1;
    $display("        PC | Loaded instruction");

    // Go through first 3 instructions in asmtest/jay_paul_tj/basic.dat
    PC = 0; #10
    if (dataOut != 32'h0c000006) begin
        dutpassed = 0;
        $display("Test 1 failed: line 1 is mismatched");
    end

    PC = PC + 4; #10
    if (dataOut != 32'h08000003) begin
        dutpassed = 0;
        $display("Test 2 failed: line 2 is mismatched");
    end

    PC = PC + 4; #10
    if (dataOut != 32'h08000005) begin
        dutpassed = 0;
        $display("Test 3 failed: line 3 is mismatched");
    end

    // Skip to the 6th instruction
    PC = 20; #10
    if (dataOut != 32'h150a0013) begin
        dutpassed = 0;
        $display("Test 4 failed: line 5 is mismatched");
    end

    // Skip to the 11th instruction
    PC = 40; #10
    if (dataOut != 32'h380c0020) begin
        dutpassed = 0;
        $display("Test 5 failed: line 10 is mismatched");
    end

    $display("dutpassed: %b",  dutpassed);

    end
endmodule
