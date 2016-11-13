`include "opcodes.v"
`include "gate_ID_EX.v"
`define _aluAsLibrary
`include "alu/alu.v"
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

  wire      pcPlus4_EX;
  wire      regWrite_EX;
  wire      memtoReg_EX;
  wire      memWrite_EX;
  wire      branch_EX;
  wire[2:0] aLUControl_EX;
  wire      aLUSrc_EX;
  wire      regDst_EX;
  wire[4:0] instruction_Rt_EX;
  wire[4:0] instruction_Rd_EX;

  reg [4:0] instruction_Rt_ID;
  reg [4:0] instruction_Rd_ID;


  gate_ID_EX the_gate_id_ex (
    .regWrite_EX(regWrite_EX),
    .memtoReg_EX(memtoReg_EX),
    .memWrite_EX(memWrite_EX),
    .branch_EX(branch_EX),
    .aLUControl_EX(aLUControl_EX),
    .aLUSrc_EX(aLUSrc_EX),
    .regDst_EX(regDst_EX),
    .readData1Out_EX(readData1Out),
    .readData2Out_EX(readData2Out),
    .instruction_Rt_EX(instruction_Rt_EX),
    .instruction_Rd_EX(instruction_Rd_EX),
    .signExtendOut_EX(signExtendOut),
    .pcPlus4_EX(pcPlus4_EX),
    .clk(clk),
    .regWrite_ID(regWrite_ID),
    .memToReg_ID(memToReg_ID),
    .memWrite_ID(memWrite_ID),
    .branch_ID(branch_ID),
    .aLUControl_ID(aluControl_ID),
    .aLUSrc_ID(aluSrc_ID),
    .regDst_ID(regDst_ID),
    .readData1Out_ID(readData1Out),
    .readData2Out_ID(readData2Out),
    .instruction_Rt_ID(instruction_Rt_ID),
    .instruction_Rd_ID(instruction_Rd_ID),
    .signExtendOut_ID(signExtendOut),
    .pcPlus4_ID(pcPlus4_EX)
  );



  wire [31:0] shiftOut;

  shiftTwo the_shifting_of_two (
    .out(shiftOut),
    .in(signExtendOut)
  );



  wire writeReg_EX;

  //The leftmost mux in the EX phase.
  mux2Input the_mux(
    .out(writeReg_EX),
    .address(regDst_EX),
    .input0(instruction_Rt_EX),
    .input1(instruction_Rd_EX)
  );

  //The right-er mux in the EX phase.
  wire [31:0] srcB_EX;
  mux2Input the_other_mux(
    .out(srcB_EX),
    .address(aLUSrc_EX),
    .input0(readData2Out),
    .input1(signExtendOut)
  );



  //The uppermost ALU (labeled ALU) in the EX phase.
  wire [31:0] srcA_EX;
  ALU the_alu(
    .result(aluOut_EX), //Assuming Bonnie will declare aluOut_EX as a wire when she makes her EXMEM gate here.
    .operandA(srcA_EX), //LEFT OUT CARRYOUT, ZERO, and OVERFLOW.
    .operandB(srcB_EX),
    .command(aLUControl_EX)
  );


//The bottom-most ALU in the EX phase which does addition.
ALU the_other_alu(
  .result(pcBranch_EX),
  .operandA(shiftOut),
  .operandB(pcPlus4_EX),
  .command(ADD) //RETURN TO THIS TO INPUT REAL ADD COMMAND. ****
  );









  // MEM - Data Memory =========================================================
  // WB - Writeback ============================================================
endmodule
