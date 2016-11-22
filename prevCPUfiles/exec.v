`timescale 1 ns / 1 ps
`include "alu.v"
`include "mux.v"

module EXEC
(
input [31:0] rd1,
input [31:0] rd2,
input [4:0] rtE,
input [4:0] rdE,
input RegDstE,
input ALUSrcE,
input [2:0] ALUCtrlE,
input [31:0] seImm,
input pcaddr,
output [31:0] aluout,
output writedatae,
output [4:0] writeregE,
output pcbranch,
output zero
);

wire overflow;
wire carryout;
wire zero;
wire [31:0] SrcBE;

//insert mux between rte and rde
mux2to15bits muxRE(rtE,rdE,RegDstE, writeregE);

//insert bitshifting before adding
assign pcbranch = (seImm <<2) + pcaddr;

//insert mux between rd2 and sign extendedx imm
mux32to1by1 muxwritedata(rd2, seImm, ALUSrcE, SrcBE);

//insert alu
ALU aluex(aluout,carryout,zero,overflow, rd1,SrcBE,ALUCtrlE);

endmodule
