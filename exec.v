
`include "alu.v"
module mux32to1by1
(
    input [31:0] input1,
    input [31:0] input2,
    input select,
    output reg [31:0] out
);

  always @(input1, input2, select) begin
  if (select) begin
      assign out = input2;
  end
  else begin
      assign out = input1;
  end
  end
endmodule


module EXEC
(
input [31:0] rd1,
input [31:0] rd2,
input [31:0] rtE,
input [31:0] rdE,
input RegDstE,
input ALUSrcE,
input [2:0] ALUCtrlE,
input [31:0] seImm,
input pcaddr,
output [31:0] aluout,
output writedatae,
output [31:0] writeregE,
output pcbranch
);

wire overflow;
wire carryout;
wire zero;
wire [31:0] SrcBE;

//insert mux between rte and rde
mux32to1by1 muxRE(rtE,rdE,RegDstE, writeregE);

//insert bitshifting before adding
assign pcbranch = (seImm <<2) + pcaddr;

//insert mux between rd2 and sign extendedx imm
mux32to1by1 muxwritedata(rd2, seImm, ALUSrcE, SrcBE);



//insert alu
ALU aluex(aluout,carryout,zero,overflow, rd1,SrcBE,ALUCtrlE);

endmodule
