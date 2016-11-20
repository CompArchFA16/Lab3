`include "opcodes.v"
`include "reg_addr.v"

module jump_unit (
  output [31:0] pc_out,
  output [31:0] regfile_data_in_post_jal,
  output [4:0]  regfile_addr_post_jal,
  output        regfile_we_post_jal,
  input  [31:0] pc_original,
  input  [31:0] pc_from_regfile,
  input  [31:0] instruction_IF,
  input  [31:0] instruction_ID,
  input  [31:0] regfile_data_in,
  input  [4:0]  regfile_addr,
  input         regfile_we
);
  wire [31:0] pc_checkpoint_j;
  wire [31:0] instruction_ID;

  // Handle J.
  assign pc_checkpoint_j = instruction_IF[31:26] === `CMD_j ?
    instruction_IF[25:0] << 2 :
    pc_original;

  // Handle JAL and JR.
  assign pc_out = instruction_ID[31:26] === `CMD_jal ?
    pc_original + 8 :
    instruction_ID[31:26] === `CMD_jr ?
      pc_from_regfile :
      pc_checkpoint_j;

  assign regfile_data_in_post_jal = instruction_ID[31:26] === `CMD_jal ?
    pc_original + 4 :
    regfile_data_in;

  assign regfile_addr_post_jal = instruction_ID[31:26] === `CMD_jal ?
    `R_RA :
    regfile_addr;

  assign regfile_we_post_jal = instruction_ID[31:26] === `CMD_jal ?
    1'b1 :
    regfile_we;
endmodule
