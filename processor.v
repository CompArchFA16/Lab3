///// Pipeline CPU Assembly /////

`include "submodules/alu.v"
`include "submodules/controller.v"
`include "submodules/datamemory.v"
`include "submodules/dff.v"
`include "submodules/registerfile.v"
`include "submodules/shifter.v"
`include "submodules/signextender.v"
`include "submodules/transphaseregister.v"

module cpu
(
	input clk
);

///// Wires /////

// Controller
wire regWriteD;
wire memToRegD;
wire BranchD;
wire ALUControlD;
wire ALUSrcD;
wire RegDstD;

// Sign Extender
wire [15:0] signExtendOut;

// ALU
wire [31:0] resA;
wire coutA;
wire oflA;
wire zeroA;

// Datamemory
wire dataOutM;

// Registerfile
wire [31:0] readData1R;
wire [31:0] readData2R;


///// INSTRUCTION FETCH PHASE /////
wire [31:0] pc_addr, pc_input, pc_plus_fourI, instructionI, jump;
wire [31:0] pc_plus_fourD, instructionD;

mux_32_bit plus_four_or_imm(.out(pc_4_imm), .a(pc_plus_fourI), .b(jump_addrM), .addr(take_branch));
mux_32_bit plus_four_or_imm(.out(pc_4_imm_j), .a(pc_4_imm), .b(jump), .addr(pc_jump));
mux_32_bit plus_four_or_imm(.out(pc_input), .a(pc_4_imm_j), .b(reg_read1E), .addr(pc_regE));

dFF pc(clk, pc_addr, pc_write, pc_input);

datamemory instruction_memory(.clk(clk), .dataOut(instructionD), .address(pc_addr[6:0]), .writeEnable() , .dataIn());

ALU alu_pc_plus_four(
  .res    (pc_plus_fourI),
  .cout   (),
  .ofl    (),
  .zero   (),
  .a      (pc_addr),
  .b      (32'd4),
  .cmd    (3'b000)
);

transphaseregister I(
  .a_out(instructionD),
  .b_out(pc_plus_fourD),
  .c_out(),
  .d_out(),
  .e_out(),
  .f_out(),
  .reg_write_out(),
  .mem_to_reg_out(),
  .mem_write_out(),
  .branch_out(),
  .alu_control_out(),
  .alu_src_out(),
  .reg_dst_out(),
  .pc_reg_out(),
  .a(instructionI),
  .b(pc_plus_fourI),
  .c(),
  .d(),
  .e(),
  .f(),
  .reg_write(),
  .mem_to_reg(),
  .mem_write(),
  .branch(),
  .alu_control(),
  .alu_src(),
  .reg_dst(),
  .pc_reg()
);

///// INSTRUCTION DECODE PHASE /////

wire [31:0] pc_plus_eight, write_data, write_addr, reg_read1D, reg_read2D, signex_immD;
wire [31:0] reg_read1E, reg_read2E, signex_immE, pc_plus_fourE;
// Larger control signals
wire [2:0] alu_controlD;
wire [2:0] alu_controlE;
// Control signals passing through transphase registers
wire reg_writeD, mem_to_regD, mem_writeD, branchD, alu_srcD, reg_dstD, pc_regD;
wire reg_writeE, mem_to_regE, mem_writeE, branchE, alu_srcE, reg_dstE, pc_regE, rtE, rdE;
// Control signals not passing through registers
wire link, pc_jump, pc_write;

mux_32_bit write_back_or_pc_plus_eight(.out(write_data), .a(write_back), .b(pc_plus_eight), .addr(link));
mux_32_bit write_back_or_jal31(.out(write_addr), .a(reg_addrW), .b(32'd31), .addr(link));

ALU alu_pc_plus_eight(
  .res    (pc_plus_eight),
  .cout   (),
  .ofl    (),
  .zero   (),
  .a      (pc_plus_fourD),
  .b      (32'd4),
  .cmd    (3'b000)
);

controller ctrl(
  .reg_write(reg_writeD),
  .mem_to_reg(mem_to_regD),
  .mem_write(mem_writeD),
  .branch(branchD),
  .alu_control(alu_controlD),
  .alu_src(alu_srcD),
  .reg_dst(reg_dstD),
  .pc_write(pc_write),
  .pc_jump(pc_jump),
  .pc_reg(pc_regD),
  .link(link),
  .clk(clk),
  .op(instructionD[31:26]),
  .funct(instructionD[5:0])
);

concatenator concat(
  .out(jump),
  .a(pc_plus_fourD[31:28]),
  .b(instructionD[25:0])
);

signextender signex(
  .signextendOut(signex_immD),
  .clk(clk),
  .imm(instructionD[15:0])
);

registerfile regfile(
  .ReadData1(reg_read1D),
  .ReadData2(reg_read2D),
  .WriteData(write_data),
  .ReadRegister1(instructionD[25:21]),
  .ReadRegister2(instructionD[20:16]),
  .WriteRegister(write_addr),
  .RegWrite(pc_regE),
  .Clk(clk)
);

transphaseregister D(
  .a_out(reg_read1E),
  .b_out(reg_read2E),
  .c_out(rtE),
  .d_out(rdE),
  .e_out(signex_immE),
  .f_out(pc_plus_fourE),
  .reg_write_out(reg_writeE),
  .mem_to_reg_out(mem_to_regE),
  .mem_write_out(mem_writeE),
  .branch_out(branchE),
  .alu_control_out(alu_controlE),
  .alu_src_out(alu_srcE),
  .reg_dst_out(reg_dstE),
  .pc_reg_out(pc_regE),
  .a(reg_read1D),
  .b(reg_read2D),
  .c(instructionD[20:16]),
  .d(instructionD[15:11]),
  .e(signex_immD),
  .f(pc_plus_fourD),
  .reg_write(reg_writeD),
  .mem_to_reg(mem_to_regD),
  .mem_write(mem_writeD),
  .branch(branchD),
  .alu_control(alu_controlD),
  .alu_src(alu_srcD),
  .reg_dst(reg_dstD),
  .pc_reg(pc_regD)
);
///// EXECUTE PHASE /////

wire [31:0] shifted, resultE, reg_addrE;
wire [31:0] resultM, reg_addrM, reg_read2M;

wire jump_addrE, is_zeroE;
wire jump_addrM, is_zeroM;

shift_by_two shifter(.out(shifted), .in(signex_immE));

mux_32_bit imm_or_read2(.out(reg_read2_or_imm), .a(reg_read2E), .b(signex_immE), .addr(alu_srcE));
mux_32_bit write_back_or_jal31(.out(reg_addrE), .a(rtE), .b(rdE), .addr(reg_dstE));

ALU imm_plus_pc_plus_four(
  .res    (jump_addrE),
  .cout   (),
  .ofl    (),
  .zero   (),
  .a      (shifted),
  .b      (pc_plus_fourE),
  .cmd    (3'b000)
);

ALU main(
  .res    (resultE),
  .cout   (),
  .ofl    (),
  .zero   (is_zeroE),
  .a      (reg_read1E),
  .b      (reg_read2_or_imm),
  .cmd    (alu_controlE)
);

transphaseregister E(
  .a_out(is_zeroM),
  .b_out(resultM),
  .c_out(reg_read2M),
  .d_out(reg_addrM),
  .e_out(jump_addrM),
  .f_out(),
  .reg_write_out(reg_writeM),
  .mem_to_reg_out(mem_to_regM),
  .mem_write_out(mem_writeM),
  .branch_out(branchM),
  .alu_control_out(),
  .alu_src_out(),
  .reg_dst_out(),
  .pc_reg_out(),
  .a(is_zeroE),
  .b(resultE),
  .c(reg_read2E),
  .d(reg_addrE),
  .e(jump_addrE),
  .f(),
  .reg_write(reg_writeE),
  .mem_to_reg(mem_to_regE),
  .mem_write(mem_writeE),
  .branch(branchE),
  .alu_control(),
  .alu_src(),
  .reg_dst(),
  .pc_reg()
);
///// MEMORY PHASE /////

wire [31:0] mem_readM;
wire [31:0] mem_readW, resultW, reg_addrW;

wire take_branch;
wire reg_writeW, mem_to_regW;

and should_branch(take_branch, is_zeroM, branchM);

datamemory data_memory(
  .clk(clk),
  .dataOut(mem_readM),
  .address(resultM[6:0]),
  .writeEnable(mem_writeM),
  .dataIn(reg_read2M)
);

transphaseregister M(
  .a_out(resultW),
  .b_out(mem_readW),
  .c_out(reg_addrW),
  .d_out(),
  .e_out(),
  .f_out(),
  .reg_write_out(reg_writeW),
  .mem_to_reg_out(mem_to_regW),
  .mem_write_out(),
  .branch_out(),
  .alu_control_out(),
  .alu_src_out(),
  .reg_dst_out(),
  .pc_reg_out(),
  .a(resultM),
  .b(mem_readM),
  .c(reg_addrM),
  .d(),
  .e(),
  .f(),
  .reg_write(reg_writeM),
  .mem_to_reg(mem_to_regM),
  .mem_write(),
  .branch(),
  .alu_control(),
  .alu_src(),
  .reg_dst(),
  .pc_reg()
);
///// WRITE BACK PHASE /////

wire [31:0] write_back;

mux_32_bit write_back_data(.out(write_back), .a(resultW), .b(mem_readW), .addr(mem_to_regW));

endmodule