//------------------------------------------------------------------------
// Instruction Memory
//   Stores up to 32 instructions
//   PC picks which instruction to do next
//------------------------------------------------------------------------

module instructionmemory
(
    input[9:0] address,
    output[31:0] dataOut
);

    reg[31:0] memory[1023:0];
    initial $readmemh("asmtest/jay_paul_tj/basic.dat", memory);
    assign dataOut = memory[address];
endmodule
