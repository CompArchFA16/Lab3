`include "opcodes.v"

module jump_unit (
  output [31:0] pcOut,
  input  [31:0] pcOriginal,
  input  [31:0] instruction
);
  assign pcOut = instruction[31:26] === `CMD_j ? (instruction[25:0] << 2) : pcOriginal;
endmodule
