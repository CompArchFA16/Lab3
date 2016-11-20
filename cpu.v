`ifndef __CPU_V__
`define __CPU_V__

`include "utils.v"
`include "mux.v"
`include "alu.v"
`include "controller.v"
`include "data_memory.v"
`include "instruction_memory.v"
`include "instruction_decoder.v"
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
wire [1:0] sel_pc;
wire sgn, sel_b;

wire dm_wen;
wire [1:0] rf_seldin;
wire [1:0] rf_selwadr;
wire rf_wen, sel_bne;

// INSTRUCTION MEMORY
reg [31:0] pc = 0; //program counter
wire [31:0] pc4;
assign pc4 = pc+32'd4;
wire [31:0] next_pc;
wire [31:0] instr; //instruction

// INSTRUCTION DECODER
// instr provided by instruction memory
wire [5:0] opcode;
wire [4:0] rs, rt, rd, shamt;
wire [5:0] funct;
wire [15:0] imm;
wire [25:0] jadr;
wire [31:0] jumpaddress;
wire [31:0] branchaddress;

// REGISTER FILE
// rs,rt,rd provided by instruction decoder
wire [31:0] ds, dt;
wire [31:0] rf_din; //data in for register
wire [4:0] rf_wadr;
// rf_selwadr, rf_seldin, rf_wen; : control signal

// ALU
wire [31:0] operandA, operandB;
wire [5:0] alucontrol_large;
wire [2:0] alucontrol;
wire [31:0] opb_imm, opb_mem; // candidate for operand B

// DATA MEMORY
wire [31:0] dm_adr;
wire [31:0] dm_din;
wire [31:0] dm_dout;
//wire dm_wen; : control signal

///// ============== MODULE DECLARATIONS ==================

// CONTROLLER
controller ctrl(opcode, funct, sel_pc, sgn, sel_b, aluop, dm_wen, rf_wen, rf_selwadr, rf_seldin, sel_bne); // control signals based on operation

// INSTRUCTION MEMORY
instructionMemory im(clk, writeEnable, pc, instr); // this may internally be datamemory with w_en always 0

// INSTRUCTION DECODER
instructionDecoder id(instr, opcode, rs, rt, rd, shamt, funct, imm, jadr); // convenience module

assign jumpaddress = {pc4[31:28], jadr, 2'b00};
assign branchaddress = pc4 + (opb_imm << 2); // opb_imm should be sign extended

// REGISTER FILE
mux #(.WIDTH(32), .CHANNELS(4)) m2(rf_din, {32'dx, alu_res, dm_dout, pc4}, rf_seldin); //00 = pc+4, 01 = dm_dout, 10 = alu_res
mux #(.WIDTH(5), .CHANNELS(4)) m4(rf_wadr,{5'dx, rd, 5'd31, rt}, rf_selwadr); // rd=10, 31=01, rt=00
regfile rf(ds, dt, rf_din, rs, rt, rf_wadr, rf_wen, clk);

// EXTENDER
signextend ext(opb_imm, imm, sgn); // sign / ~unsigned extend

// ALU
assign opb_mem = dt; // alias
mux #(.WIDTH(32), .CHANNELS(2)) m0(operandB, {opb_imm, opb_mem}, sel_b); // select immediate when sel_b is high
mux #(.WIDTH(32), .CHANNELS(2)) m1(operandA, {pc4, ds}, sel_bne); // when sel_bne is high, take ds

wire [31:0] alu_res;
//mux #(.WIDTH(6), .CHANNELS(2)) m5(alucontrol_large,{funct, {4'b0000,sel_aluop}}, (sel_aluop == 2'b10) ); // choose funct when sel_aluop == 2'b10

assign alucontrol = alucontrol_large[2:0];

wire carryout, zero, overflow;

alu a(alu_res, carryout, zero, overflow, operandA, operandB, aluop);

// DATA MEMORY
assign dm_adr = alu_res; // alias
assign dm_din = dt; // happens to be the only one used

datamemory dm(clk, dm_wen, dm_din, dm_din, dm_dout);

mux #(.WIDTH(32), .CHANNELS(4)) m6(next_pc, {branchaddress,jumpaddress,ds,pc4}, sel_pc);

always @(posedge clk) begin
	pc <= next_pc;
end

endmodule
`endif
