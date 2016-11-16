//Tom Lisa Anisha so hawt
`timescale 1 ns / 1 ps
`include "pc.v"
`include "memory.v"
`include "instrFetch.v"
`include "regfile.v"
//`include "ctrl_unit.v"
//`include "instrdecode.v"
`include "mux.v"

module pipelineCPU
(
    input clk,
    output [31:0] whatever
);


// Instruction Fetch

reg enable = 1;
wire [31:0] PCaddr;
reg regWE = 0;
wire [31:0] InstrOut;
wire [31:0] instrD;
wire [31:0] PCplus4D;
reg wrenable = 1;

pc programcounter(clk, enable, PCaddr);
Instr_memory iMem(PCaddr, InstrOut);
registerIF rif(wrenable, clk, InstrOut, PCaddr, instrD, PCplus4D);

// Instruction Decode
wire [5:0] Op;
wire [5:0] Funct;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] RtED;
wire [4:0] RdED;
wire [4:0] RtEE;
wire [4:0] RdEE;
wire [15:0] Imm;

wire [31:0] RD1D;
wire [31:0] RD2D;
wire [31:0] RD2E;
wire [31:0] SrcAE;
wire [31:0] SrcBE;
wire [31:0] resultW = 32'b00000000111111110000000011111111;
wire [4:0] WriteRegW = 5'b01010;
wire RegWriteW = 1;
wire [31:0] SignImmE;

wire RegWriteD;
wire MemtoRegD;
wire MemWriteD;
wire BranchD;
wire [2:0] ALUControlD;
wire ALUSrcD;
wire RegDstD;
wire RegWriteE;
wire MemtoRegE;
wire MemWriteE;
wire BranchE;
wire [2:0] ALUControlE;
wire ALUSrcE;
wire RegDstE;
wire [31:0] PCPlus4E;

InstrFetchUnit instrFetch(instrD, Op, Funct, A1, A2, RtED, RdED, Imm);
//ctrl_unit ctrlunit(Op, Funct, clk, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD);
regfile regfilemodule(RD1D, RD2D, resultW, A1, A2, WriteRegW, RegWriteW, clk);
signExtend se(Imm, SignImmE);

registerID rid(clk, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD, RD1D, RD2D, RtED, RdED, SignImmE, PCplus4D, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUControlE, ALUSrcE, RegDstE, SrcAE, RD2E, RtEE, RdEE, SignImmE, PCPlus4E);

// Execute phase
wire [4:0] WriteRegE;
mux2to15bits mux1(RtEE, RdEE, RegDstE, WriteRegE);
mux32to1by1small mux2(RD2E, SignImmE, ALUSrcE, SrcBE);


endmodule




module registerIF
(
	input wrenable,
    input       clk,
    input [31:0] d1,
    input [31:0] d2,
    output reg [31:0] q1,
    output reg [31:0] q2
    );
    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
    end
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

module registerID
(
    input       clk,
    input       d1,
    input       d2,
    input       d3,
    input       d4,
    input [2:0] d5,
    input       d6,
    input       d7,
    input [31:0]d8,
    input [31:0]d9,
    input  [4:0]d10,
    input  [4:0]d11,
    input [31:0]d12,
    input [31:0]d13,
    output reg  q1,
    output reg  q2,
    output reg  q3,
    output reg  q4,
    output reg [2:0]  q5,
    output reg  q6,
    output reg   q7,
    output reg [31:0] q8,
    output reg [31:0] q9,
    output reg [4:0] q10,
    output reg [4:0] q11,
    output reg [31:0] q12,
    output reg [31:0] q13
    );

    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
            q5 = d5;
            q6 = d6;
            q7 = d7;
            q8 = d8;
            q9 = d9;
            q10 = d10;
            q11 = d11;
            q12 = d12;
            q13 = d13;
    end
endmodule