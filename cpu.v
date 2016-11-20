// Basics.
`include "gates.v"
`include "dff.v"
`include "mux_2.v"
`include "adder.v"
`include "sign_extend.v"
`include "left_2_shifter.v"

// Pipeline gates.
`include "gate_IF_ID.v"
`include "gate_ID_EX.v"
`include "gate_EX_MEM.v"
`include "gate_MEM_WB.v"

// Controls.
`include "opcodes.v"
`include "control_unit.v"
`include "jump_unit.v"

// Large components.
`define _aluAsLibrary
`include "alu/alu.v"
`define _regfileAsLibrary
`include "regfile/regfile.v"

module CPU (
  output [31:0] instruction_addr,
  output [31:0] dataMemAddress,
  output [31:0] dataOut,
  output        toMemWriteEnable,
  input         clk,
  input  [31:0] instruction,
  input  [31:0] dataIn,
  input         resetPC
);

  // IF - Instruction Fetch ====================================================

  // Controls.
  wire pcSource;

  // Data.
  wire [31:0] pcBranch_MEM;
  wire [31:0] prePC;
  wire [31:0] pcPlus4_IF;
  wire [31:0] pre_PC_post_jump;

  mux_2 #(32) mux_pc_src (
    .out(prePC),
    .address(pcSource),
    .input0(pcPlus4_IF),
    .input1(pcBranch_MEM)
  );

  dff #(32) pc_dff (
    .out(instruction_addr),
    .clk(clk),
    .in(pre_PC_post_jump),
    .reset(resetPC)
  );

  adder adder_4 (
    .out(pcPlus4_IF),
    .left(instruction_addr),
    .right(32'h4)
  );

  // ID - Instruction Decode ===================================================

  wire regWrite_WB;

  wire [31:0] instruction_ID;
  wire [31:0] pcPlus4_ID;
  wire [4:0]  writeReg_WB;
  wire [31:0] result_WB;

  gate_IF_ID the_gate_IF_ID (
    .instruction_ID(instruction_ID),
    .pcPlus4_ID(pcPlus4_ID),

    .clk(clk),

    .instruction_IF(instruction),
    .pcPlus4_IF(pcPlus4_IF)
  );

  // Outputs of control unit.
  wire regWrite_ID;
  wire memToReg_ID;
  wire memWrite_ID;
  wire branch_ID;
  wire [2:0] aluControl_ID;
  wire aluSrc_ID;
  wire regDst_ID;

  control_unit the_control_unit (
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

  wire [31:0] reg_write_data;
  wire [4:0]  reg_write_register;
  wire        reg_write_enable;

  regfile the_regfile (
    .ReadData1(readData1Out),
    .ReadData2(readData2Out),
    .Clk(clk),
    .WriteData(reg_write_data),
    .ReadRegister1(instruction_ID[25:21]),
    .ReadRegister2(instruction_ID[20:16]),
    .WriteRegister(reg_write_register),
    .RegWrite(reg_write_enable)
  );

  jump_unit the_jump_unit (
    .pc_out(pre_PC_post_jump),
    .regfile_data_in_post_jal(reg_write_data),
    .regfile_addr_post_jal(reg_write_register),
    .regfile_we_post_jal(reg_write_enable),
    .pc_original(prePC),
    .pc_from_regfile(readData1Out),
    .instruction_IF(instruction),
    .instruction_ID(instruction_ID),
    .regfile_data_in(result_WB),
    .regfile_addr(writeReg_WB),
    .regfile_we(regWrite_WB)
  );

  wire [31:0] signExtendOut;

  sign_extend the_sign_extend (
    .out(signExtendOut),
    .in(instruction_ID[15:0])
  );

  // EX - Execute ==============================================================

  // Controls.
  wire        regWrite_EX;
  wire        memToReg_EX;
  wire        memWrite_EX;
  wire        branch_EX;
  wire [2:0]  aluControl_EX;
  wire        aluSrc_EX;
  wire        regDst_EX;

  // Data.
  wire [31:0] readData1_EX;
  wire [31:0] readData2_EX;
  wire [4:0]  rT_EX;
  wire [4:0]  rD_EX;
  wire [31:0] signImm_EX;
  wire [31:0] pcPlus4_EX;

  gate_ID_EX the_gate_ID_EX (
    .regWrite_EX(regWrite_EX),
    .memToReg_EX(memToReg_EX),
    .memWrite_EX(memWrite_EX),
    .branch_EX(branch_EX),
    .aluControl_EX(aluControl_EX),
    .aluSrc_EX(aluSrc_EX),
    .regDst_EX(regDst_EX),

    .readData1Out_EX(readData1_EX),
    .readData2Out_EX(readData2_EX),

    .instruction_Rt_EX(rT_EX),
    .instruction_Rd_EX(rD_EX),

    .signExtendOut_EX(signImm_EX),
    .pcPlus4_EX(pcPlus4_EX),

    .clk(clk),

    .regWrite_ID(regWrite_ID),
    .memToReg_ID(memToReg_ID),
    .memWrite_ID(memWrite_ID),
    .branch_ID(branch_ID),
    .aluControl_ID(aluControl_ID),
    .aluSrc_ID(aluSrc_ID),
    .regDst_ID(regDst_ID),

    .readData1Out_ID(readData1Out),
    .readData2Out_ID(readData2Out),

    .instruction_Rt_ID(instruction_ID[20:16]),
    .instruction_Rd_ID(instruction_ID[15:11]),

    .signExtendOut_ID(signExtendOut),
    .pcPlus4_ID(pcPlus4_ID)
  );

  wire [31:0] shiftOut;

  left_2_shifter the_left_2_shifter (
    .out(shiftOut),
    .in(signImm_EX)
  );

  wire [4:0] writeReg_EX;

  //The leftmost mux in the EX phase.
  mux_2 #(5) mux_reg_dst (
    .out(writeReg_EX),
    .address(regDst_EX),
    .input0(rT_EX),
    .input1(rD_EX)
  );

  wire [31:0] srcB_EX;

  // The right-er mux in the EX phase.
  mux_2 #(32) mux_alu_src (
    .out(srcB_EX),
    .address(aluSrc_EX),
    .input0(readData2_EX),
    .input1(signImm_EX)
  );

  wire [31:0] aluOut_EX;
  wire zero_EX;

  // The uppermost ALU (labeled ALU) in the EX phase.
  ALU the_alu (
    .result(aluOut_EX),
    .operandA(readData1_EX),
    .operandB(srcB_EX),
    .zero(zero_EX),
    .command(aluControl_EX)
  );

  wire [31:0] pcBranch_EX;

  // The bottom-most ALU in the EX phase which does addition.
  adder adder_pc_branch (
    .out(pcBranch_EX),
    .left(shiftOut),
    .right(pcPlus4_EX)
  );

  // MEM - Memory Access =======================================================

  // Controls.
  wire regWrite_MEM;
  wire memToReg_MEM;
  wire branch_MEM;

  // Data.
	wire        zero_MEM;
	wire [4:0]  writeReg_MEM;
  wire [31:0] aluOut_MEM;

  assign dataMemAddress = aluOut_MEM;

	gate_EX_MEM the_gate_EX_MEM (
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.memWrite_MEM(toMemWriteEnable),
		.branch_MEM(branch_MEM),

    .zero_MEM(zero_MEM),
    .aluOut_MEM(aluOut_MEM),
    .writeData_MEM(dataOut),
    .writeReg_MEM(writeReg_MEM),
    .pcBranch_MEM(pcBranch_MEM),

    .clk(clk),

		.regWrite_EX(regWrite_EX),
		.memToReg_EX(memToReg_EX),
    .memWrite_EX(memWrite_EX),
		.branch_EX(branch_EX),

    .zero_EX(zero_EX),
    .aluOut_EX(aluOut_EX),
    .writeReg_EX(writeReg_EX),
    .writeData_EX(readData2_EX),
    .pcBranch_EX(pcBranch_EX)
  );

  `AND (pcSource, branch_MEM, zero_MEM);

  // WB - Register Write Back ==================================================

  // Controls.
  wire memToReg_WB;

  // Data.
  wire [31:0] aluOut_WB;
  wire [31:0] readData_WB;

  gate_MEM_WB the_gate_MEM_WB (
    .regWrite_WB(regWrite_WB),
    .memToReg_WB(memToReg_WB),
    .aluOut_WB(aluOut_WB),
    .readData_WB(readData_WB),
    .writeReg_WB(writeReg_WB),
    .clk(clk),
    .regWrite_MEM(regWrite_MEM),
    .memToReg_MEM(memToReg_MEM),
    .aluOut_MEM(aluOut_MEM),
    .readData_MEM(dataIn),
    .writeReg_MEM(writeReg_MEM)
  );

  mux_2 #(32) mux_mem_to_reg (
    .out(result_WB),
    .address(memToReg_WB),
    .input0(aluOut_WB),
    .input1(readData_WB)
  );
endmodule
