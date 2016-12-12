module adder_1bit // 1-bit full adder
(
    output sum,       // 1 bit sum of a and b and carryin
    output carryout,  // Carryout of the summation of a and b and carryin
    input a,          // 1 bit input a
    input b,          // 1 bit input b
    input carryin     // 1 bit input carryin
);

    // intermediate wires
    wire xor_ab, nand_ab, and_ab, nand_xor_ab_c, and_xor_ab_c, nco;

    xor_1bit xor_1(xor_ab, a, b);
    xor_1bit xor_2(sum, xor_ab, carryin);
    nand #20 nand_1 (nand_ab, a, b);
    not  #10 not1 (and_ab, nand_ab);
    nand #20 nand_2 (nand_xor_ab_c, carryin, xor_ab);
    not  #10 not2 (and_xor_ab_c, nand_xor_ab_c);
    nor  #20 nor_1 (nco, and_xor_ab_c, and_ab);
    not  #10 not_3 (carryout, nco);
endmodule
