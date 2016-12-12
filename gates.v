// 2-input gates for various components of the ALU

module nor_or_1bit // Computes NOR/OR (muxed by othercontrolsignal)
(
    output result,
    input a,
    input b,
    input othercontrolsignal
);

    wire nor_ab, or_ab;  // intermediate wires

    nor #20 nor0(nor_ab, a, b);
    not #10 not0(or_ab, nor_ab);

    mux_1bit mux0(result, othercontrolsignal, nor_ab, or_ab);
endmodule

module nand_and_1bit // Computes NAND/AND (muxed by othercontrolsignal)
(
    output result,
    input a,
    input b,
    input othercontrolsignal
);

    wire nand_ab, and_ab;  // intermediate wires

    nand #20 nand0(nand_ab, a, b);
    not  #10 not0(and_ab, nand_ab);

    mux_1bit mux0(result, othercontrolsignal, nand_ab, and_ab);
endmodule

module xor_1bit // Computes XOR
(
    output result,
    input a,
    input b
);

    wire nand_ab, nor_ab, or_ab, nxor_ab;  // intermediate wires

    nand #20 nand0(nand_ab, a, b);
    nor  #20 nor0(nor_ab, a, b);
    not  #10 not0(or_ab, nor_ab);
    nand #20 nand1(nxor_ab, or_ab, nand_ab);
    not  #10 not1(result, nxor_ab);
endmodule
