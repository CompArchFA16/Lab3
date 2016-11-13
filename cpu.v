`include "control.v"
`include "alu.v"
`include "alucontrol.v"
`include "register.v"
`include "pc.v"
`include "datamemory.v"
`include "signExtend.v"
`include "instMem.v"

`timescale 1ns / 1ps

// Two-input MUX 
module mux #(parameter W = 32)
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    assign out = (sel) ? in1 : in0;
endmodule


module add_pc
(
    input [31:0]   in,
    output [31:0]  out
);
    assign out = in + 4;
endmodule


module add_alu
(
    input [31:0]    in0,
    input [31:0]    in1,
    output [31:0]   out
);
    assign out = in0 + (in1<<2);
endmodule




module cpu
(
	input clk
);

wire [31:0] pc_in;
wire [31:0] pc_out;
wire [31:0] inst;

wire RegDst; //Mux for Register_WriteRegister_in
wire Branch; //AND with ALU_Zero_out to get PCSrc
wire MemRead; //read data from data memory
wire MemtoReg; //Mux for selecting between DataMemory_ReadData_out
wire [1:0] ALUop; //for ALU control
wire MemWrite; //write data to data memory
wire ALUsrc; //goes to ALU control
wire RegWrite;

wire [4:0] writeRegister;
wire [31:0] writeData;

wire [31:0] reg_readData1;
wire [31:0] reg_readData2;

wire [31:0] SEinst;
wire [31:0] ALU_in;
wire [2:0] ALUcontrol;
wire [31:0] ALUresult;
wire ALUzero;

wire [31:0] datamem_readData;
wire [31:0] pc4_out;
wire [31:0] addALUres;
//wire PCSrc;


pc cpuPC(.clk(clk), .pc_in(0), .pc_out(pc_out));
instMem cpuIM(.clk(clk), .PC(pc_out), .instruction(inst));
control cpuControl(.clk(clk), .instruction(inst[31:26]),
				   .RegDst(RegDst), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUop), .MemWrite(MemWrite), .ALUSrc(ALUsrc), .RegWrite(RegWrite));
mux #(5) mux5_inst_reg(.in0(inst[20:16]), .in1(insr[15:11]), .sel(RegDst), .out(writeRegister));
register cpuRegister(.clk(clk), .ra_addr(inst[25:21]), .rb_addr(instr[20:16]), .wrEn(RegWrite), .wd_addr(writeRegister), .wd(writeData), .ra(reg_readData1), .rb(reg_readData2));
signExtend cpuSE(.seIn(inst[15:0]), .seOut(SEinst));
mux mux_reg_alu(.in0(reg_readData2), .in1(SEinst), .sel(ALUsrc), .out(ALU_in));
alucontrol cpualucontrol(.clk(clk), .ALUop(ALUop), .instruction(inst[5:0]), .ALUcontrol(ALUcontrol));
alu cpuALU(.clk(clk), .alucontrol(ALUcontrol), .a(reg_readData1), .b(ALU_in), .aluRes(ALUresult), .zero(ALUzero));
datamemory cpu_dm(.clk(clk), .readData(datamem_readData), .address(ALUresult), .MemWrite(MemWrite), .MemRead(MemRead), .writeData(reg_readData2));
mux mux_datamem(.in0(ALUresult), .in1(datamem_readData), .sel(MemtoReg), .out(writeData));
add_pc cpu_add_pc(.in(pc_out), .out(pc4_out));
add_alu cpu_add_alu(.in0(pc4_out),.in1(SEinst), .out(addALUres));
mux mux_pc(.in0(pc4_out), .in1(addALUres), .sel(Branch & ALUzero), .out(pc_in));

endmodule