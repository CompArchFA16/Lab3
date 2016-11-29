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
wire [31:0] resA;
wire coutA;
wire oflA;
wire zeroA;

// Datamemory
wire dataOutM;

// Registerfile
wire [31:0] readData1R;
wire [31:0] readData2R;

///// Modules /////

// Sign Extender
signextender(clk, IMM CONNECTION, signExtendOut);

// ALU
ALU(resA, coutA, oflA, zeroA, A CONNECTION, B CONNECTION, CMD CONNECTION);

// Controller


// Registerfile
registerfile(readData1R, readData2R, WRITEDATA CONNECTION, READREG1 CONNECTION, READREG2 CONNECTION, WRITEREG CONNECTION, REGWRITE CONNECTION, clk);
