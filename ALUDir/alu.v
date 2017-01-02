`include "adder.v"
`include "mux.v"
`include "lut.v"

`define AND and #30
`define OR or #30
`define NOT not #10
`define XOR xor #50
`define NAND nand #20
`define NOR nor #20

module bitSliceALU
(
    output outAdder,
    output outAnd,
    output outNand,
    output outNor,
    output outOr,
    output outXor,
    output carryout,
    input a,
    input b,
    input carryin,
    input invert
);
    wire a, b, carryin, invert;

    wire [7:0] outputs;
    wire invertB;

    `XOR xorgate1 (invertB, invert, b);
    fullAdder adder0 (outAdder, carryout, a, invertB, carryin);
    `AND andgate0 (outAnd,  a, b);
    `NAND nandgate0 (outNand, a, b);
    `NOR norgate0 (outNor, a, b);
    `OR orgate0 (outOr, a, b);
    `XOR xorgate0 (outXor, a, b);

endmodule


module ALU
(
    output [31:0] result,
    output carryout,
    output zero,
    output overflow,
    input [31:0] operandA,
    input [31:0] operandB,
    input [2:0] command
);

    wire [31:0] carryoutSlice;
    wire [31:0] outBase;

    wire [2:0] sel;
    wire invert;
    wire initialOverflow;
    wire sltOp;
    aluLUT lut0 (sel, invert, command);

    wire [31:0] outAdder;
    wire [31:0] outAnd;
    wire [31:0] outNand;
    wire [31:0] outNor;
    wire [31:0] outOr;
    wire [31:0] outXor;
    wire [31:0] outSlt;

    bitSliceALU _alu(outAdder[0], outAnd[0], outNand[0],
                     outNor[0], outOr[0], outXor[0],
                     carryoutSlice[0], operandA[0], operandB[0], 
                     invert, invert); // Carry-in at first is invert

    aluMUX _mux(result[0], sel, outAdder[0], outAnd[0], outNand[0],
                                      outNor[0], outOr[0], outXor[0], outSlt[0], 1'b0);

    genvar i;
    generate
        for (i=1; i < 32; i=i+1) begin : aluSlices
            bitSliceALU _alu(outAdder[i], outAnd[i], outNand[i], 
                             outNor[i], outOr[i], outXor[i],
                             carryoutSlice[i], operandA[i], operandB[i], 
                             carryoutSlice[i-1], invert);
            aluMUX _mux(result[i], sel, outAdder[i], outAnd[i], outNand[i],
                                      outNor[i], outOr[i], outXor[i], 1'b0, 1'b0);
        end
    endgenerate

    // Handle overflow logic
    `XOR xorgate0 (initialOverflow, carryoutSlice[30], carryoutSlice[31]);
    
    // Only propagate carryout and overflow if an add or subtract
    wire [2:0] notSel;
    `NOT (notSltOp, sltOp); // TODO: DO THESE NEED NAMES?
    `NOT (notSel[0], sel[0]);
    `NOT (notSel[1], sel[1]);
    `NOT (notSel[2], sel[2]);
    `AND (carryout, carryoutSlice[31], notSel[0], notSel[1], notSel[2]);
    `AND (overflow, initialOverflow, notSel[0], notSel[1], notSel[2]);

    // Overflow is used to determine SLT
    `XOR (outSlt[0], initialOverflow, outAdder[31]);

    // Zero flag
    wire [30:0] ors;
    `OR (ors[0], result[0], result[1]);
    generate
        for (i=0; i < 30; i=i+1) begin : calcZero
            `OR (ors[i+1], result[i+1], ors[i]);
        end
    endgenerate
    `NOT (zero, ors[30]);

endmodule
