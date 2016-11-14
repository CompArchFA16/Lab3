// Basics.
`include "gates.v"
`include "dff.v"
`include "mux_2.v"
`include "addFour.v"
`include "sign_extend.v"
`include "shift_two.v"

// Pipeline gates.
`include "gate_IF_ID.v"
`include "gate_ID_EX.v"
`include "gate_EX_MEM.v"
`include "gate_MEM_WB.v"

// Controls.
`include "opcodes.v"
`include "control_unit.v"

// Large components.
`define _aluAsLibrary
`include "alu/alu.v"
`define _regfileAsLibrary
`include "regfile/regfile.v"
`include "ram.v"

module CPU (
  output [31:0] pc,
  input         clk,
  input  [31:0] instruction
);

  // IF - Instruction Fetch ====================================================

  // Controls.
  wire pcSource;

  // Data.
  wire [31:0] pcBranch_MEM;
  wire [31:0] prePC;
  wire [31:0] pc_IF;
  wire [31:0] pcPlus4_IF;
  wire [31:0] instruction_IF;

  mux_2 #(32) pcChoice (
    .out(prePC),
    .address(pcSource),
    .input0(pcPlus4_IF),
    .input1(pcBranch_MEM)
  );

  dff #(32) pcDFF (
    .out(pc_IF),
    .clk(clk),
    .in(prePC)
  );

  // TODO: Deprecate into the same memory.
  RAM instruction_memory (
    .dataOut(instruction_IF),
    .clk(clk),
    .address(pc_IF),
    .writeEnable(1'b0),
    .dataIn(32'b0)
  );

  addFour addFour (
    .pcPlus4F(pcPlus4_IF),
    .clk(clk),
    .pc(pc_IF)
  );

  // ID - Instruction Decode ===================================================

  wire [31:0] instruction_ID;
  wire        pcPlus4_ID;
  wire [4:0]  writeReg_WB;
  wire [31:0] result_WB;
  wire        regWrite_WB;

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
    .WriteData(result_WB),
    .ReadRegister1(instruction_ID[25:21]),
    .ReadRegister2(instruction_ID[20:16]),
    .WriteRegister(writeReg_WB),
    .RegWrite(regWrite_WB)
  );

  wire [31:0] signExtendOut;

  signExtend the_signExtend (
    .out(signExtendOut),
    .clk(clk),
    .in(instruction_ID[15:0])
  );

  // EX - Execute ==============================================================

  wire [31:0] pcPlus4_EX;
  wire        regWrite_EX;
  wire        memToReg_EX;
  wire        memWrite_EX;
  wire        branch_EX;
  wire [2:0]  aLUControl_EX;
  wire        aLUSrc_EX;
  wire        regDst_EX;
  wire[4:0]   instruction_Rt_EX;
  wire[4:0]   instruction_Rd_EX;

  reg [4:0] instruction_Rt_ID;
  reg [4:0] instruction_Rd_ID;

  wire [31:0] readData1_EX;
  wire [31:0] readData2_EX;

  gate_ID_EX the_gate_id_ex (
    .regWrite_EX(regWrite_EX),
    .memToReg_EX(memToReg_EX),
    .memWrite_EX(memWrite_EX),
    .branch_EX(branch_EX),
    .aLUControl_EX(aLUControl_EX),
    .aLUSrc_EX(aLUSrc_EX),
    .regDst_EX(regDst_EX),
    .readData1Out_EX(readData1_EX),
    .readData2Out_EX(readData2_EX),
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
    .clk(clk),
    .in(signExtendOut)
  );

  wire [4:0] writeReg_EX;

  //The leftmost mux in the EX phase.
  mux_2 #(5) the_mux (
    .out(writeReg_EX),
    .address(regDst_EX),
    .input0(instruction_Rt_EX),
    .input1(instruction_Rd_EX)
  );

  wire [31:0] srcB_EX;

  // The right-er mux in the EX phase.
  mux_2 #(32) alu_src_mux (
    .out(srcB_EX),
    .address(aLUSrc_EX),
    .input0(readData2_EX),
    .input1(signExtendOut)
  );

  wire [31:0] aluOut_EX;

  // The uppermost ALU (labeled ALU) in the EX phase.
  ALU the_alu (
    .result(aluOut_EX), //Assuming Bonnie will declare aluOut_EX as a wire when she makes her EXMEM gate here.
    .operandA(readData1_EX), //LEFT OUT CARRYOUT, ZERO, and OVERFLOW.
    .operandB(srcB_EX),
    .command(aLUControl_EX)
  );

  wire [31:0] pcBranch_EX;

  // The bottom-most ALU in the EX phase which does addition.
  // TODO: Having an ALU over here is so overkill.
  ALU full_adder (
    .result(pcBranch_EX),
    .operandA(shiftOut),
    .operandB(pcPlus4_EX),
    .command(3'b100) // Is this the add command we want? ****
  );

  // MEM - Memory Access =======================================================

  wire regWrite_MEM;
  wire memToReg_MEM;
  wire memWrite_MEM;
  wire branch_MEM;

  wire zero_MEM;
  wire [31:0] aluOut_MEM;
  wire [31:0] writeData_MEM;
  wire [4:0]  writeReg_MEM;

  // TODO: add EX wires as inputs
  gate_EX_MEM gate_EX_MEM (
    .regWrite_MEM(regWrite_MEM),
    .memToReg_MEM(memToReg_MEM),
    .memWrite_MEM(memWrite_MEM),
    .branch_MEM(branch_MEM),
    .zero_MEM(zero_MEM),
    .aluOut_MEM(aluOut_MEM),
    .writeData_MEM(writeData_MEM),
    .writeReg_MEM(writeReg_MEM),
    .pcBranch_MEM(pcBranch_MEM),
    .clk(clk),
    .regWrite_EX(regWrite_EX),
    .memToReg_EX(memToReg_EX),
    .memWrite_EX(memWrite_EX),
    .branch_EX(branch_EX),
    .zero_EX(), // TODO: Complete.
    .aluOut_EX(aluOut_EX),
    .writeReg_EX(writeReg_EX),
    .writeData_EX(readData2_EX), // TODO: Complete.
    .pcBranch_EX(pcBranch_EX)
  );

  `AND (pcSource, branch_MEM, zero_MEM);

  wire [31:0] readData_MEM;

  RAM data_memory (
    .clk(clk),
    .dataOut(readData_MEM),
    .address(aluOut_MEM),
    .writeEnable(memWrite_MEM),
    .dataIn(writeData_MEM)
  );

  // WB - Register Write Back ==================================================

  wire memToReg_WB;

  wire [31:0] aluOut_WB;
  wire [31:0] readData_WB;

  gate_MEM_WB gate_MEM_WB (
    .regWrite_WB(regWrite_WB),
    .memToReg_WB(memToReg_WB),
    .aluOut_WB(aluOut_WB),
    .readData_WB(readData_WB),
    .writeReg_WB(writeReg_WB),
    .clk(clk),
    .regWrite_MEM(regWrite_MEM),
    .memToReg_MEM(memToReg_MEM),
    .aluOut_MEM(aluOut_MEM),
    .readData_MEM(readData_MEM),
    .writeReg_MEM(writeReg_MEM)
  );

  mux_2 #(32) memToRegMux (
    .out(result_WB),
    .address(memToReg_WB),
    .input0(aluOut_WB),
    .input1(readData_WB)
  );
endmodule
