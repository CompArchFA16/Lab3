`ifndef __CPU_V__
`define __CPU_V__

`include "utils.v"
`include "mux.v"
`include "alu.v"
`include "Controller.v"
`include "DataMemory.v"
`include "InstructionMemory.v"
`include "InstructionDecoder.v"
`include "mux.v"
`include "regfile/regfile.v"
`include "signextend/signextend.v"

module cpu
(
  input clk
);

// TODO : add clock
// TODO : change PC+4 to reasonable module output

//// =============== WIRE DECLARATIONS ==================
// CONTROLLER
wire [2:0] sel_pc;
wire sgn, sel_b;
wire [1:0] sel_aluop;

wire dm_wen;
wire [1:0] rf_seldin;
wire [1:0] rf_selwadr;
wire rf_wen, sel_bne;

// INSTRUCTION MEMORY
wire [31:0] pc; //program counter
wire [31:0] instr; //instruction

// INSTRUCTION DECODER
// instr provided by instruction memory
wire [5:0] opcode;
wire [4:0] rs, rt, rd, shamt;
wire [5:0] funct;
wire [15:0] imm;
wire [25:0] jadr;
wire [31:0] jumpaddress;

// REGISTER FILE
// rs,rt,rd provided by instruction decoder
wire [31:0] ds, dt;
wire [31:0] rf_din; //data in for register
// rf_selwadr, rf_seldin, rf_wen; : control signal

// ALU
wire [31:0] operandA, operandB;
wire [2:0] alucontrol;
wire [31:0] opb_imm, opb_mem; // candidate for operand B

// DATA MEMORY
wire [31:0] dm_adr;
wire [31:0] dm_din;
wire [31:0] dm_dout;
//wire dm_wen; : control signal

///// ============== MODULE DECLARATIONS ==================

// CONTROLLER
controller ctrl(opcode, funct, sel_pc, sgn, sel_b, sel_aluop, dm_wen, rf_wen, rf_wadr, rf_selwadr, rf_seldin, sel_bne); // control signals based on operation

// INSTRUCTION MEMORY
instructionMemory im(pc, instr); // this may internally be datamemory with w_en always 0

// INSTRUCTION DECODER
instructionDecoder id(instr, opcode, rs, rt, rd, shamt, funct, imm, jadr); // convenience module
assign jumpaddress = jadr; //{(PC+4)[31:28], jadr, 2'b00}

// REGISTER FILE
mux #(.WIDTH(2), .CHANNELS(3)) m2(rf_din, {alu_res, dm_dout, pc+4}, rf_seldin); //00 = pc+4, 01 = dm_dout, 10 = alu_res
mux #(.WIDTH(3), .CHANNELS(3)) m4(rf_wadr,{rd, 5'd31, rt}, rf_selwadr); // rd=10, 31=01, rt=00
regfile rf(ds, dt, rs, rt, rf_wadr, rf_we, rf_din);

// EXTENDER
signextend ext(opb_imm, imm, sgn); // sign / ~unsigned extend

// ALU
assign opb_mem = dt; // alias
mux #(.WIDTH(32), .CHANNELS(2)) m0(operandB, {opb_imm, opb_mem}, sel_b); // select immediate when sel_b is high
mux #(.WIDTH(32), .CHANNELS(2)) m1(operandA, {pc+4, ds}, sel_bne); // when bne, take pc+4

wire [31:0] alu_res;
mux #(.WIDTH(6), .CHANNELS(2)) m5(alucontrol,{func, {4'b0000,sel_aluop}}, sel_aluop); // TODO : Fix this mux, this logically correct but won't work in impl.

alu a(alu_res, operandA, operandB, alucontrol);

// DATA MEMORY
assign dm_adr = alu_res; // alias
assign dm_din = dt; // happens to be the only one used

datamemory dm(dm_adr, dm_wen, dm_din, dm_dout);

endmodule
`endif
