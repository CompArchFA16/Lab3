///// Pipeline CPU Assembly /////

`include "submodules/alu.v"
`include "submodules/controller.v"
`include "submodules/datamemory.v"
`include "submodules/registerfile.v"
`include "submodules/signextender.v"

module cpu
(
	input clk;
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
wire [2:0] muxIndexA;
wire invertBA;
wire cinA;
wire invertResA;

// Datamemory
wire dataOutM;

///// Modules /////

// Sign Extender
signextender(clk, IMM CONNECTION, signExtendOut);

// ALU


// Controller
