//Tom Lisa Anisha so hawt
`timescale 1 ns / 1 ps
`include "pc.v"
`include "memory.v"
`include "instrFetch.v"
`include "regfile.v"

//`include "ctrl_unit.v"
//`include "instrdecode.v"
//`include "mux.v"

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
wire [15:0] Imm;

wire [31:0] RD1D;
wire [31:0] RD2D;
wire [31:0] resultW;
wire [4:0] WriteRegW;
wire PCSrcM;
wire seImm;

InstrFetchUnit instrFetch(instrD, Op, Funct, A1, A2, RtED, RdED, Imm);
regfile regfilemodule(RD1D, RD2D, resultW, A1, A2, WriteRegW, PCSrcM, clk);
assign seImm = {Imm, 16'b0000000000000000};

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
