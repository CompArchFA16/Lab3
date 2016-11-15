// 2:1 Multiplexer
module mux_1bit
(
    output result,
    input sel0,
    input in0,
    input in1
);
    // Intermediate wires
    wire nand_in1com, and_in1com, ncom, nand_in0ncom, and_in0ncom, nor_wire;

    nand #20 nand_1(nand_in1com, in1, sel0);
    not  #10 not_1(and_in1com, nand_in1com);
    not  #10 not_2(ncom, sel0);
    nand #20 nand_2(nand_in0ncom, in0, ncom);
    not  #10 not_3(and_in0ncom, nand_in0ncom);
    nor  #20 nor_1(nor_wire, and_in0ncom, and_in1com);
    not  #10 not_4(result, nor_wire);
endmodule

module mux_3bit
(
  output[31:0] result,
  input[1:0] sel,
  input[31:0] in1, in2, in3
)
  wire[31:0] muxtomux; // from the first mux to the second
  wire[31:0] out; // output form the second mux

  mux_1bit mux1(muxtomux, sel[1], in1, in2);
  mux_1bit mux2(out, sel[0], muxtomux, in3);

endmodule
// 5:1 Multiplexer
module mux_alu
(
    output result,
    input sel0,
    input sel1,
    input sel2,
    input in0,
    input in1,
    input in2,
    input in3,
    input in4
);

    wire w0, w1, w2;

    mux_1bit mux00(w0, sel0, in0, in1);
    mux_1bit mux01(w1, sel0, in2, in3);
    mux_1bit mux1(w2, sel1, w0, w1);
    mux_1bit mux2(result, sel2, w2, in4);
endmodule

// 32:1 Multiplexer
module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);

  assign out = inputs[address];
endmodule

// 32:1x32 Multiplexer
//  32 bits wide, 32 inputs deep
module mux32to1by32
(
output[31:0]    out,
input[4:0]      address,
input[31:0]     input0, input1, input2, input3, input4, input5, input6, input7,
                input8, input9, input10, input11, input12, input13, input14, input15,
                input16, input17, input18, input19, input20, input21, input22, input23,
                input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[0] = input0;       // Connect the sources of the array
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;
  assign mux[30] = input30;
  assign mux[31] = input31;

  assign out = mux[address];    // Connect the output of the array
endmodule
