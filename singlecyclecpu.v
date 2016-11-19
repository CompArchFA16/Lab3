//single cycle CPU
//Tom Lisa Anisha so hawt
`timescale 1 ns / 1 ps
`include "pc.v"
`include "memory.v"
`include "instrFetch.v"
`include "tomreg/regfile.v"
`include "singlecyclectrl.v"
//`include "instrdecode.v"
`include "mux.v"
`include "alu.v"
`include "slowclk.v"

module singlecycleCPU
(
    input clk
);


singlecyclectrl ctrlunit(Op, Funct, clk, PCenable, RegWrite, ALUsrc, MemWrite, ALUop, MemtoReg, branch, JumpSelect, RegDst, JALselect, selectRegorJump, startPC);

wire PCenable; //should be controlled by control unit
wire [31:0] PCin;
wire [31:0] PCaddr;
wire [31:0] nextPC;
wire slower; 

slowclk slow(clk, slower);
pc peecee(slower, PCenable, PCin, PCaddr, nextPC);

wire [31:0] InstrOut;
Instr_memory iMem(PCaddr, InstrOut);

wire [5:0] Op;
wire [5:0] Funct;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] Rt;
wire [4:0] Rd;
wire [15:0] Imm;
wire [25:0] JumpAddr;
InstrFetchUnit iFetch(InstrOut, Op, Funct, A1, A2, Rt, Rd, Imm, JumpAddr);

wire RegDst; //set this with control unit
wire [4:0] WriteReg;
wire [4:0] rtrdout;
wire JALselect; // set with control unit
mux2to15bits muxrtrd(Rt, Rd, RegDst, rtrdout);
mux2to15bits muxrtrd31(rtrdout, 5'b11111, JALselect, WriteReg); // Saving to reg 31 for JAL

wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] WriteData;
wire RegWrite; //set this with w control unit
regfile reggie(ReadData1, ReadData2, WriteData, A1, A2, WriteReg, RegWrite, clk);

wire [31:0] seImm;
signExtend se(Imm, seImm);

wire ALUsrc; //set this with control unit
wire [31:0] ALUsrcB;
mux32to1by1small muxrd2seImm(ReadData2, seImm, ALUsrc, ALUsrcB);

wire [2:0] ALUop; //set this with control unit
wire overflow;
wire zero;
wire carryout;
wire [31:0] ALUresult;
ALU alu(ALUresult, carryout, overflow, zero, ReadData1, ALUsrcB, ALUop);

wire PCsrc;
wire branch; //set this with control unit
and andgate(PCsrc, branch, zero);
wire [31:0] pcbtwnmux;
wire [31:0] jumpAddrforpc;
wire JumpSelect; // set this with control unit
wire selectRegorJump; // set this with control unit
wire startPC; 
wire [31:0] PCinput;

mux32to1by1small muxpcbranchinput(nextPC, (nextPC + seImm), PCsrc, pcbtwnmux);
mux32to1by1small muxjumpaddr({6'b000000, JumpAddr}, ReadData1, selectRegorJump, jumpAddrforpc);
mux32to1by1small muxpcjumpinput(pcbtwnmux, jumpAddrforpc, JumpSelect, PCin);
//mux32to1by1small muxpcstart(PCinput, 32'b00000000000000000000000000000000, startPC, PCin);

wire MemWrite; //set this with control unit
wire [31:0] Dataout;
Data_memory DMEM(clk, MemWrite, ALUresult, ReadData2, Dataout);

wire MemtoReg; //set with control unit
mux32to1by1small muxwb(ALUresult, Dataout, MemtoReg, WriteData);

endmodule

module signExtend
(
	input [15:0] imm,
	output reg [31:0] seImm
);
always @(imm) begin
    if (imm[15] == 0) begin
    	seImm <= {16'b0000000000000000, imm};
    end
    else begin
    	seImm <= {16'b1111111111111111, imm};
    end
end
endmodule
