`include "opcodes.v"
`include "gate_if_id.v"
`include "control_unit.v"
`define _regfileAsLibrary
`include "regfile/regfile.v"
`include "sign_extend.v"

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

  wire regWrite_ID;
  wire memToReg_ID;
  wire memWrite_ID;
  wire branch_ID;
  wire aluControl_ID;
  wire aluSrc_ID;
  wire regDst_ID;

  controlUnit the_controlUnit (
    .regWrite_ID(regWrite_ID),
    .memToReg_ID(memToReg_ID),
    .memWrite_ID(memWrite_ID),
    .branch_ID(branch_ID),
    .aluControl_ID(aluControl_ID),
    .aluSrc_ID(aluSrc_ID),
    .regDst_ID(regDst_ID),
    .op(instruction_ID[31:26]),
    .funct(instruction_ID[5:0])
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

  wire [31:0] signExtendOut;

  signExtend the_signExtend (
    .out(signExtendOut),
    .clk(clk),
    .in(instruction_ID[15:0])
  );

  // EX - Execute ==============================================================
  // MEM - Data Memory =========================================================
  // WB - Writeback ============================================================
endmodule
