//------------------------------------------------------------------------
// Instruction Memory Test Bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

module test_instructionmemory();
    parameter len_instr = 32;
    parameter num_instr = 5;
    parameter len_addr = 5;

    reg clk;
    reg[len_instr*num_instr-1:0] instructions;
    reg[len_addr-1:0] PC;
    wire[len_instr-1:0] dataOut;

    instructionmemory #(len_instr, num_instr, len_addr) dut(clk, instructions, PC, dataOut);

    // Test sequence
    initial begin
        $dumpfile("instructionmemory.vcd");
        $dumpvars();

        instructions = 0;
        instructions[len_instr  -1:          0] = 32'haaaaaaaa;
        instructions[len_instr*2-1:len_instr  ] = 32'hbbbbbbbb;
        instructions[len_instr*3-1:len_instr*2] = 32'hcccccccc;
        instructions[len_instr*4-1:len_instr*3] = 32'hdddddddd;
        instructions[len_instr*5-1:len_instr*4] = 32'heeeeeeee;

        $display("Pre-loaded instruction |  PC | Loaded instruction");
        // Go through first three instructions sequentially
        PC = 5'b00000;
        clk = 0; #5 clk = 1; #5 clk = 0; #5 clk = 1; #5
        $display(" %h              |  %d | %h                 ",  instructions[len_instr-1:0], PC, dataOut);
        PC = PC + 4;
        clk = 0; #5 clk = 1; #5 clk = 0; #5 clk = 1; #5
        $display(" %h              |  %d | %h                 ",  instructions[len_instr*2-1:len_instr], PC, dataOut);
        PC = PC + 4;
        clk = 0; #5 clk = 1; #5 clk = 0; #5 clk = 1; #5
        $display(" %h              |  %d | %h                 ",  instructions[len_instr*3-1:len_instr*2], PC, dataOut);

        // Jump to 5th instruction
        PC = 16;
        clk = 0; #5 clk = 1; #5 clk = 0; #5 clk = 1; #5
        $display(" %h              |  %d | %h                 ",  instructions[len_instr*5-1:len_instr*4], PC, dataOut);

        // Return to 4th instruction
        PC = 12;
        clk = 0; #5 clk = 1; #5 clk = 0; #5 clk = 1; #5
        $display(" %h              |  %d | %h                 ",  instructions[len_instr*4-1:len_instr*3], PC, dataOut);

        $finish;
    end

endmodule
