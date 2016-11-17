//single cycle CPU
//Tom Lisa Anisha so hawt
`timescale 1 ns / 1 ps
`include "pc.v"
`include "memory.v"
`include "instrFetch.v"
`include "regfile.v"
//`include "ctrl_unit.v"
//`include "instrdecode.v"
`include "mux.v"
`include "alu.v"

module singlecycleCPU
(
    input clk
    );

wire PCenable; //should be controlled by control unit
wire [31:0] PCin;
wire [31:0] PCaddr ;
wire [31:0] nextPC;

pc peecee(clk, PCenable, PCin, PCaddr, nextPC);

wire [31:0] InstrOut;
Instr_memory iMem(PCaddr, InstrOut);

wire [5:0] Op;
wire [5:0] Funct;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] Rt;
wire [4:0] Rd;
wire [15:0] Imm;
InstrFetchUnit iFetch(InstrOut, Op, Funct, A1, A2, Rt, Rd, Imm);

wire RegDst; //set this with control unit
wire [4:0] WriteReg;
mux2to15bits muxrtrd(Rt, Rd, RegDst, WriteReg);

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

mux32to1by1small muxpcinput(nextPC, (nextPC + seImm), PCsrc, PCin);

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
