//all logic timing
`define AND and #30 //2 input AND
`define AND4 and #50 //4 input AND
`define OR or #30 //2 input OR
`define OR8 or #90 //8 input OR
`define NOT not #10

//all devices located in adder32.v file
`include "adder32.v"

module ALU
(
output[31:0]    result,
output          carryout,
output          zero,
output          overflow,
input[31:0]     a,
input[31:0]     b,
input[2:0]      command
);

//make all wire buses
wire [31:0]resultand;
wire [31:0]resultor;
wire [31:0]resultxor;
wire [31:0]resultsub;
wire [31:0]resultadd;
wire [31:0]resultslt;
wire [31:0]resultnor;
wire [31:0]resultnand;
wire [31:0]out0;
wire [31:0]out1;
wire [31:0]out2;
wire [31:0]out3;
wire [31:0]out4;
wire [31:0]out5;
wire [31:0]out6;
wire [31:0]out7;
wire overflowadd;
wire carryoutadd;
wire overflowsub;
wire carryoutsub;
wire nS0;
wire nS1;
wire nS2;

//Call all modules to compute result
Full32Add adder(overflowadd, carryoutadd,  resultadd, a, b, 0,0); //ADD MODULE
Full32Add subtractor(overflowsub, carryoutsub, resultsub, a, b, 1,1); //SUBTRACT MODULE
XORfunction xorer(resultxor, a, b); //XOR MODULE
SLTfunction slter(resultslt, a, b); //SLT MODULE
ANDfunction ander(resultand, a, b); //AND MODULE
NANDfunction nander(resultnand, a, b); //NAND MODULE
NORfunction norer(resultnor, a, b); //NOR MODULE
ORfunction orer(resultor, a, b); //OR MODULE

//loop through bit by bit
genvar i;
generate
for (i=0; i < 32; i=i+1)
begin : ALUMUX

//to make all possible inputs 000-111
`NOT S0inv(nS0, command[0]);
`NOT S1inv(nS1, command[1]);
`NOT S2inv(nS2, command[2]);

//multiplexer with 3 select - therefore 8 4 input AND gates
`AND4 andgate0(out0[i], resultadd[i], nS2, nS1, nS0);  //000
`AND4 andgate1(out1[i], resultsub[i], nS2, nS1, command[0]);//100
`AND4 andgate2(out2[i], resultxor[i], nS2, command[1], nS0); //010
`AND4 andgate3(out3[i], resultslt[i], nS2, command[1], command[0]); //110
`AND4 andgate4(out4[i], resultand[i], command[2], nS1, nS0); //001
`AND4 andgate5(out5[i], resultnand[i], command[2], nS1, command[0]);//101
`AND4 andgate6(out6[i], resultnor[i],command[2], command[1], nS0);//110
`AND4 andgate7(out7[i], resultor[i], command[2], command[1], command[0]);//111

`OR8 orgate8(result[i], out0[i], out1[i], out2[i], out3[i], out4[i], out5[i], out6[i], out7[i]);

end
endgenerate

//Check if result is = 0. If so, raise zeroflag
FlagZero flagzero(zero, result);

// Carryout and overflow
wire [7:0] overflows;
wire [7:0] carryouts;

//MUX overflow results. select with same address as above.
`AND4 andgate8(overflows[0], overflowadd, nS2, nS1, nS0);  // adder 000
`AND4 andgate9(carryouts[0], carryoutadd, nS2, nS1, nS0);  // adder 000
`AND4 andgate10(overflows[1], overflowsub, nS2, nS1, command[0]);//sub 001
`AND4 andgate11(carryouts[1], carryoutsub, nS2, nS1, command[0]);//sub 001
`AND4 andgate12(overflows[2], 0,nS2, command[1], nS0); //xor 010
`AND4 andgate13(carryouts[2], 0, nS2, command[1], nS0); //xor 010
`AND4 andgate14(overflows[3],0, nS2, command[1], command[0]); //slt 110
`AND4 andgate15(carryouts[3], 0, nS2, command[1], command[0]); //slt 110
`AND4 andgate16(overflows[4], 0, command[2], nS1, nS0); //and 001
`AND4 andgate17(carryouts[4], 0, command[2], nS1, nS0); //and 001
`AND4 andgate18(overflows[5], 0, command[2], nS1, command[0]);//nand101
`AND4 andgate19(carryouts[5], 0,  command[2], nS1, command[0]);//nand101
`AND4 andgate20(overflows[6], 0, command[2], command[1], nS0);//nor110
`AND4 andgate21(carryouts[6], 0, command[2], command[1], nS0);//nor110
`AND4 andgate22(overflows[7], 0,  command[2], command[1], command[0]);//or111
`AND4 andgate23(carryouts[7], 0, command[2], command[1], command[0]);//or111

`OR8 orgate8ovf(overflow, overflows[0], overflows[1], overflows[2], overflows[3], overflows[4], overflows[5], overflows[6], overflows[7]);//mux out the overflow
`OR8 orgate8carry(carryout, carryouts[0], carryouts[1], carryouts[2], carryouts[3], carryouts[4], carryouts[5], carryouts[6], carryouts[7]); //mux out correct carryout


endmodule
