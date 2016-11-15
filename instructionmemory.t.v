//------------------------------------------------------------------------
// Instruction Memory Test Bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

module test_instructionmemory();
    reg[31:0] PC;
    wire[31:0] dataOut;

    instructionmemory dut(PC, dataOut);

    // Test sequence
    initial begin
        $dumpfile("instructionmemory.vcd");
        $dumpvars();

        $display("        PC | Loaded instruction");
        // Go through first 3 instructions sequentially
        PC = 0; #10
        $display("%d | %h                 ", PC, dataOut);
        PC = PC + 4; #10
        $display("%d | %h                 ", PC, dataOut);
        PC = PC + 4; #10
        $display("%d | %h                 ", PC, dataOut);

        // Skip to the 5th instruction
        PC = 20; #10
        $display("%d | %h                 ", PC, dataOut);

        // Skip to the 10th instruction
        PC = 40; #10
        $display("%d | %h                 ", PC, dataOut);

        $finish;
    end

endmodule
