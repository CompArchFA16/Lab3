`include "opcodes.v"
`include "gate_ex_mem.v"
`include "gate_mem_wb.v"
`include "datamemory.v"
`include "mux2Input.v"
`include "instructionmemory.v"
`include "pcReg.v"
`include "addFour.v"
`include "gate_if_id.v"
`include "control_unit.v"
`define _regfileAsLibrary
`include "regfile/regfile.v"
`include "sign_extend.v"

`define AND and #330

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

	// MEM - Memory Access ====================================================

	wire regWrite_MEM;
	wire memToReg_MEM;
	wire memWrite_MEM;
	wire branch_MEM;

	wire zero_MEM;
	wire [31:0] aluOut_MEM;
	wire [31:0] writeData_MEM;
	wire writeReg_MEM;
	wire [31:0] pcBranch_MEM;

	wire pcSource;

	gate_EX_MEM gate_EX_MEM (
		.clk(clk),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.memWrite_MEM(memWrite_MEM),
		.branch_MEM(branch_MEM),
		.regWrite_EX(), // need regWrite_EX
		.memToReg_EX(), // need memToReg_EX
		.branch_EX(), // need branch_EX
		.zero_MEM(zero_MEM),
		.aluOut_MEM(aluOut_MEM),
		.writeData_MEM(writeData_MEM),
		.writeReg_MEM(writeReg_MEM),
		.pcBranch_MEM(pcBranch_MEM),
		.zero_EX(), // need zero_EX
		.aluOut_EX(), // need aluOut_EX
		.writeReg_EX(), // need writeReg_EX
		.writeData_EX(), // need writeData_EX
		.pcBranch_EX() // need pcBranch_EX
	);

	`AND (pcSource, branch_MEM, zero_MEM);

	wire [31:0] readData_MEM;

	datamemory datamemory(
		.clk(clk),
		.dataOut(readData_MEM),
		.address(aluOut_MEM),
		.writeEnable(memWrite_MEM),
		.dataIn(writeData_MEM)
	);

	// WB - Register Write Back ====================================================

	wire regWrite_WB;
		wire memToReg_WB;

	wire [31:0] aluOut_WB;
		wire [31:0] readData_WB;
		wire writeReg_WB;

	gate_MEM_WB gate_MEM_WB (
		.regWrite_WB(regWrite_WB),
		.memToReg_WB(memToReg_WB),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.aluOut_WB(aluOut_WB),
		.readData_WB(readData_WB),
		.writeReg_WB(writeReg_WB),
		.aluOut_MEM(aluOut_MEM),
		.readData_MEM(readData_MEM),
		.writeReg_MEM(writeReg_MEM)
	);

	wire [31:0] result_WB;

	mux2Input memToRegMux(
		.out(result_WB),
		.address(memToReg_WB),
		.input0(aluOut_WB),
		.input1(readData_WB)
	);

	wire[31:0] prePC;
	wire[31:0] pcPlus4F;

	mux2Input regWriteMux(
		.out(prePC),
		.address(pcSource),
		.input0(pcPlus4F),
		.input1(pcBranch_MEM)
	);

	pcReg pcReg(
		.clk(clk),
		.pc(pc),
		.prePC(prePC)
	);

	addFour addFour (
		.clk(clk),
		.pcPlus4F(pcPlus4F),
		.pc(pc)
	);

	wire[31:0] instructionMemOut;

	instructionmemory instrmem(
		.clk(clk),
		.address(pc),
		.dataOut(instructionMemOut)
	);

endmodule