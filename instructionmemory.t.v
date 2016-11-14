//------------------------------------------------------------------------
// Instruction Memory Test Bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

module test_instructionmemory();
    reg[9:0] PC;
    wire[31:0] dataOut;

    instructionmemory dut(PC, dataOut);

    // Test sequence
    initial begin
        $dumpfile("instructionmemory.vcd");
        $dumpvars();

        $display("  PC | Loaded instruction");
        // Go through first three instructions sequentially
        PC = 0;
        $display("%d | %h                 ", PC, dataOut);
        PC = 1;
        $display("%d | %h                 ", PC, dataOut);
        PC = 4;
        $display("%d | %h                 ", PC, dataOut);
        PC = 7;
        $display("%d | %h                 ", PC, dataOut);
        PC = 12;
        $display("%d | %h                 ", PC, dataOut);

        $finish;
    end

endmodule
