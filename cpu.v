`include "opcodes.v"
`include "gate_if_id.v"
`include "regfile/regfile.v"

module CPU (
  output [31:0] pc,
  input         clk,
  input  [31:0] instruction
);

  // IF - Instruction Fetch ====================================================

  wire [31:0] instruction_IF;
  wire        pcPlus4_IF;

  // ID - Instruction Decode ===================================================

  wire [31:0] instruction_ID;
  wire        pcPlus4_ID;

  gate_IF_ID the_gate_If_ID (
    .instruction_ID(instruction_ID),
    .pcPlus4_ID(pcPlus4_ID),
    .clk(clk),
    .instruction_IF(instruction_IF),
    .pcPlus4_IF(pcPlus4_IF)
  );

  // EX - Execute ==============================================================
  // MEM - Data Memory =========================================================
  // WB - Writeback ============================================================
endmodule
