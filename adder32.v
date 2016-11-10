//Define gate timings
`define AND and #30 //2 input AND with unit 10 per input
`define AND3 and #40 //3 input AND with unit 10 per input
`define AND32 and #320 //32 input AND
`define OR or #30 //2 input OR
`define OR32 or #320 //32 input OR
`define NOT not #10 //1 input INV
`define XOR xor #60 //see lab report, timing derived from NAND gate version.
`define NAND nand #20 // 2 input nand, no hidden inverters
`define NOR nor #20 // 2 input nor, no hidden inverters
`define NOR32 nor #320 //32 input NOR
`define XOR32 xor #1080 //32 input XOR
`define NOT not #10 //inverter
`define NOR nor #20 //2 input NOR

module structuralFullAdder
//One bit adder/subtractor
(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin,
    input subtract
);

    // Create the wires
    wire AxorB;
    wire AandB;
    wire AxorBandCin;
    wire bos0;

    // calculate the sum
    `XOR xorgate3( bos0, subtract, b); //XOR gate for subtract
    `XOR xorgate1(AxorB, a,bos0);
    `XOR xorgate2(sum, AxorB, carryin);

    // calculate the carryout
    `AND andgate1(AandB, a, bos0);
    `AND andgate2(AxorBandCin, AxorB, carryin);
    `OR orgate(carryout, AandB, AxorBandCin);

endmodule


module Full32Add
//Loop through 1bit adder 32 times to get 32 bit result
(
    output overflow,
    output carryout,
    output [31:0] sum,
    input[31:0] a,
    input[31:0] b,
    input carryin,
    input subtract

);

//Find carryout between all answers
wire [31:0] carryoutarray;

//Set first, depending on subtract's input
structuralFullAdder singleadder(sum[0],carryoutarray[0],a[0],b[0],subtract,subtract);

//loop through the rest of the 32 bits.
genvar i;
generate
  for (i=1; i < 32; i=i+1)
  begin:bitadder
    structuralFullAdder singleadder(sum[i],carryoutarray[i],a[i],b[i],carryoutarray[i-1],subtract);
  end
endgenerate

//Set carryout
`OR orgatecarry(carryout, carryoutarray[31], 0);

//overflow calculation
`XOR ovfxor(overflow, carryout, carryoutarray[30]);

endmodule

module NANDfunction
/* This module is the 32-bit NAND functionality of the ALU
AND gate. Two 32-bit numbers results in a 32-bit number
that has a 0 in the position that the inputs match (high)*/
(
    output [31:0] result,
    input [31:0] a,
    input [31:0] b

);

	genvar i;
	generate
	  for (i=0; i < 32; i=i+1)
	  begin:NAND32
	    `NAND _nandgate(result[i], a[i], b[i]);
	  end
	endgenerate

endmodule

module NORfunction
/* This module is the 32-bit NOR functionality of the ALU
AND gate. Two 32-bit numbers results in a 32-bit number
that has a 1 in the position that both inputs do not include 1.*/
(
    output [31:0] result,
    input [31:0] a,
    input [31:0] b

);

	genvar i;
	generate
	  for (i=0; i < 32; i=i+1)
	  begin:NOR32gate
	    `NOR _norgate(result[i], a[i], b[i]);
	  end
	endgenerate

endmodule

module FlagZero
    /*This module figures out if a bit string is equal to 0, and raises a flag */
    (
        output zeroFlag,
        input [31:0] a
    );
    wire [30:0] comparisonbits;

    `OR orgate0(comparisonbits[0], a[0], a[1]);

    genvar i;
    generate
    for (i=0; i < 30; i=i+1)
    begin : OR
        `OR _orgate(comparisonbits[i+1], a[i+2], comparisonbits[i]);
        end
    endgenerate

    `NOT notgate(zeroFlag, comparisonbits[30]);

endmodule

module ANDfunction

    /* This module is the 32-bit AND functionality of the ALU
    AND gate. Two 32-bit numbers results in a 32-bit number
    that has a 1 in the position that the inputs match (high)*/

    (
        output [31:0] result,
        input [31:0] a,
        input [31:0] b
    );

    genvar i;
    generate
    for (i=0; i < 32; i=i+1)
    begin : AND32
        `AND _andgate(result[i], a[i], b[i]);
         end
    endgenerate

endmodule

module XORfunction

/*This module is the 32-bit XOR functionality of the ALU XOR gate.
Two 32-bit numbers result in a 32-bit number that is high if there is
an odd number of 1's between two positions (01 or 10, not 11)*/
(
    output [31:0] result,
    input [31:0] a,
    input [31:0] b

);

genvar i;
generate
  for (i=0; i < 32; i=i+1)
  begin:XOR
    `XOR _xorgate(result[i], a[i], b[i]);
  end
endgenerate

endmodule


module ORfunction

/*This module is the 32-bit OR functionality of the ALU OR gate.
Two 32-bit numbers result in a 32-bit number that is high if there is
an one or two 1's being compared (01, 10, 11, but not 00)*/

(
    output [31:0] result,
    input [31:0] a,
    input [31:0] b

);

genvar i;
generate
  for (i=0; i < 32; i=i+1)
  begin:OR32
    `OR _orgate(result[i], a[i], b[i]);
  end
endgenerate

endmodule

module SLTfunction
/*SLT = Set less than. This module outputs 1 if A is less than B  */
(
    output [31:0] result,
    input [31:0] a,
    input [31:0] b

);
	genvar i;
	generate
	  for (i=1; i < 32; i=i+1)
	  begin:NOTgate
	    `NOT _notgate(result[i], 1); // set all bits of result to 0
	  end
	endgenerate

	// How to find the SLT:
	// Find A-B
	// R = the most significant bit of (A-B)
	wire overflow;
	wire carryout;
	wire zero;
	wire[31:0] resultsub;

	Full32Add intermediateadder(overflow, carryout, resultsub, a, b, 1, 1);
	// set the lest
	`OR orgate(result[0], resultsub[31], 0);

endmodule
