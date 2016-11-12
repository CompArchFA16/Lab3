// Set Less Than circuit
`timescale 1 ns/1 ps

// define gates with delays
`define AND and #30
`define OR or #30
`define XOR xor #50

`include "adder.v"

module SLTcircuit
(
    output overflow,
    output carryout,
    output sum,
    input a,
    input b,
    input carryin
);
    wire a, b, invb;
    wire carryin, carryout, sum;

    not notgate(invb, b);
    fullAdder addmod(sum, carryout, a, invb, carryin);
    xor xorgate(overflow, carryin, carryout);

endmodule
