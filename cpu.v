`include "opcodes.v"
`include "gate_if_id.v"
`define _regfileAsLibrary
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

  regfile the_regfile (
    .ReadData1(),	    // Contents of first register read
    .ReadData2(),	    // Contents of second register read
    .Clk(),		        // Clock (Positive Edge Triggered)
    .WriteData(),	    // Contents to write to register
    .ReadRegister1(), // Address of first register to read
    .ReadRegister2(), // Address of second register to read
    .WriteRegister(), // Address of register to write
    .RegWrite()	      // Enable writing of register when High
  );

  // EX - Execute ==============================================================
  // MEM - Data Memory =========================================================
  // WB - Writeback ============================================================
endmodule
