`include "opcodes.v"
`include "gate_ID_EX.v"
`define _aluAsLibrary
`include "alu/alu.v"

module CPU (
  output [31:0] pc,
  input         clk,
  input  [31:0] instruction
);
endmodule
