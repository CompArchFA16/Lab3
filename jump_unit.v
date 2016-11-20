`include "opcodes.v"

module jump_unit (
  output [31:0] pc_out,
  input  [31:0] pc_original,
  input  [31:0] pc_from_regfile,
  input  [31:0] instruction_IF,
  input  [31:0] instruction_ID
);
  wire [31:0] pc_checkpoint_j;
  wire [31:0] instruction_ID;

  // Handle J.
  assign pc_checkpoint_j = instruction_IF[31:26] === `CMD_j ?
                             (instruction_IF[25:0] << 2) :
                             pc_original;

  // Handle JAL and JR.
  assign pc_out = instruction_ID[31:26] === `CMD_jal ?
                     pc_original + 8 :
                     instruction_ID[31:26] === `CMD_jr ?
                       pc_from_regfile :
                       pc_checkpoint_j;
endmodule
