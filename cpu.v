module cpu
(

);

// TODO : add clock
// TODO : change PC+4 to reasonable module output

// CONTROLLER
wire [2:0] sel_pc;
wire sgn, sel_b;
wire [1:0] sel_aluop;
wire wd_en, rf_selradr, rf_wen, rf_seldin, sel_bne;

// INSTRUCTION MEMORY
wire [31:0] pc; //program counter
wire [31:0] instr; //instruction

// INSTRUCTION DECODER
wire instr, opcode, rs, rt, rd, shamt, func, imm, jadr;

// REGISTER FILE
wire [4:0] rs, rt, rd;
wire [31:0] ds, dt;
wire [31:0] rf_din; //data in for register

// ALU
wire [31:0] operandA, operandB;
wire [2:0] alucontrol;
wire [31:0] opb_imm, opb_mem; // candidate for operand B

// DATA MEMORY
wire [31:0] dm_adr;
wire dm_wen;
wire [31:0] dm_din;
wire [31:0] dm_dout;


// CONTROLLER
controller ctrl(opcode, sel_pc, sgn, sel_b, sel_aluop, wd_en, rf_wen, rf_wadr, rf_selwadr, rf_seldin, sel_bne); // control signals based on operation

// INSTRUCTION MEMORY
instructionmemory im(pc, instr); // this may internally be datamemory with w_en always 0

// INSTRUCTION DECODER
instructiondecoder id(instr, opcode, rs, rt, rd, shamt, funct, imm, jadr); // convenience module

// REGISTER FILE
mux m2(rf_din, {pc+4, dm_dout, alu_res}, rf_seldin);
mux m4(rf_wadr,{rd, 5'd31, rt}, rf_selwadr);
regiterfile rf(ds, dt, rs, rt, rf_wadr, rf_we, rf_din);

// EXTENDER
extender ext(opb_imm, imm, sgn); // sign / ~unsigned extend

// ALU
assign opb_mem = dt; // alias
mux m0(operandB, {opb_imm, opb_mem}, sel_b); // select immediate when sel_b is high
mux m1(operandA, {pc+4, ds}, sel_bne); // when bne, take pc+4

wire [31:0] alu_res;
alu a(alu_res, operandA, operandB, alucontrol);

// DATA MEMORY
assign dm_adr = alu_res; // alias
datamemory dm(dm_adr, dm_wen, dm_din, dm_dout);

endmodule
