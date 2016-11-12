//------------------------------------------------------------------------
// Instruction Memory
//   Stores up to 32 instructions
//   PC picks which instruction to do next
//------------------------------------------------------------------------

module instructionmemory
#(
    parameter len_instr = 32,
    parameter num_instr = 32,
    parameter len_addr = 5
)
(
    input clk,
    input[len_instr*num_instr-1:0] instructions,
    input[len_addr-1:0] address,
    output reg[len_instr-1:0] dataOut
);
    reg[len_instr*num_instr-1:0] memory;
    reg[31:0] temp;

    always @(posedge clk) begin
      memory <= instructions;
      dataOut <= memory[(address << 3) + 31 -: len_instr];
    end
endmodule
