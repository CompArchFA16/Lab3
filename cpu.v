`include "opcodes.v"
`include "gate_if_id.v"
`include "control_unit.v"
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

  wire RegWriteD;
  wire MemToRegD;
  wire MemWriteD;
  wire BranchD;
  wire ALUControlD;
  wire ALUSrcD;
  wire RegDstD;

  controlUnit the_controlUnit (
    .RegWriteD(RegWriteD),
    .MemToRegD(MemToRegD),
    .MemWriteD(MemWriteD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .RegDstD(RegDstD),
    .Op(instruction_ID[31:26]),
    .Funct(instruction_ID[5:0])
  );

  wire [31:0] readData1Out;
  wire [31:0] readData2Out;

  regfile the_regfile (
    .ReadData1(readData1Out),
    .ReadData2(readData2Out),
    .Clk(clk),
    .WriteData(), // TODO: Complete.
    .ReadRegister1(instruction_ID[25:21]),
    .ReadRegister2(instruction_ID[20:16]),
    .WriteRegister(), // TODO: Complete.
    .RegWrite() // TODO: Complete.
  );

  // EX - Execute ==============================================================
  // MEM - Data Memory =========================================================
  // WB - Writeback ============================================================
endmodule
