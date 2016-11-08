module cpu
(

);

// TODO : add clock

// control signals
wire [2:0] sel_pc;
wire sgn, sel_b;
wire [1:0] sel_aluop;
wire wd_en, sel_din, rf_wen, rf_seladr, sel_bne;

finitestatememory fsm(sel_pc, sgn, sel_b, sel_aluop, wd_en, sel_din, rf_wen, rf_seladr, sel_bne); // keep track of state

wire [4:0] rs, rt, rd;

wire [31:0] ds, dt;

wire [31:0] rf_din; //data in for register

// INSTRUCTION MEMORY
wire [31:0] pc; //program counter
wire [31:0] instr; //instruction
instructionmemory im(pc, instr); // this may internally be datamemory with w_en always 0

// INSTRUCTION DECODER
wire instr, opcode, rs, rt, rd, shamt, func, imm, jadr;
instructiondecoder id(instr, opcode, rs, rt, rd, shamt, funct, imm, jadr); // convenience module

mux m2(rf_din, {pc+4, dm_dout, alu_res}, rf_seladr);

regiterfile rf(ds, dt, rs, rt, rf_seladr, r_we, r_din);

extender ext(opb_imm, imm, sgn); //sign / unsigned extend

// ALU
wire [31:0] operandA, operandB;
wire [2:0] alucontrol;
wire [31:0] opb_imm, opb_mem; // candidate for operand B

assign opb_mem = dt; // alias
mux m0(operandB, {opb_imm, opb_mem}, sel_b); // select immediate when sel_b is high
mux m1(operandA, {pc+4, ds}, sel_bne); // when bne, take pc+4

wire [31:0] alu_res;
alu a(alu_res, operandA, operandB, alucontrol);

/// DATA MEMORY
wire [31:0] dm_adr;
wire dm_wen;
wire [31:0] dm_din;
wire [31:0] dm_dout;
assign dm_adr = alu_res; // alias
datamemory dm(dm_adr, dm_wen, dm_din, dm_dout);

endmodule
