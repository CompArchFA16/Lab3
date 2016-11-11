// Define ALU command codes
`define CMD_ADD  3'd0
`define CMD_SUB  3'd1
`define CMD_XOR  3'd2
`define CMD_SLT  3'd3
`define CMD_AND  3'd4
`define CMD_NAND 3'd5
`define CMD_NOR  3'd6
`define CMD_OR   3'd7

// define gates with delays
`define NAND nand #20
`define NOR nor #20
`define NOT not #10
`define AND and #30
`define NAND32 nand #320
`define OR or #30
`define XNOR xnor #60
`define XOR xor #60

// Define the ALU look up table to return the control signals which determine
// the behavior of the ALU
module alu_cmd_lut
(
output reg[2:0] muxindex,
output reg      invert_b,
output reg      cin,
output reg      invert_res,
input[2:0]      cmd
);

  always @(cmd) begin
    case (cmd)
      `CMD_SLT:  begin muxindex = 0; invert_b = 1; cin = 1; invert_res = 0; end
      `CMD_XOR:  begin muxindex = 1; invert_b = 0; cin = 0; invert_res = 0; end
      `CMD_AND:  begin muxindex = 2; invert_b = 0; cin = 0; invert_res = 1; end
      `CMD_NAND: begin muxindex = 2; invert_b = 0; cin = 0; invert_res = 0; end
      `CMD_NOR:  begin muxindex = 3; invert_b = 0; cin = 0; invert_res = 0; end
      `CMD_OR:   begin muxindex = 3; invert_b = 0; cin = 0; invert_res = 1; end
      `CMD_ADD:  begin muxindex = 4; invert_b = 0; cin = 0; invert_res = 0; end
      `CMD_SUB:  begin muxindex = 4; invert_b = 1; cin = 1; invert_res = 0; end
    endcase
  end
endmodule

// ADDER

module adder_1_bit
(
    output sum,
    output cout,
    input a,
    input b,
    input cin
);
  wire AxorB;
  wire AandB;
  wire AxorBandCin;

  `XOR xorgate0(AxorB, a, b);
  `XOR xorgate1(sum, AxorB, cin);

  `AND andgate0(AandB, a, b);
  `AND andgate1(AxorBandCin, AxorB, cin);
  `OR orgate(cout, AandB, AxorBandCin);
endmodule

module adder_8_bit
(
  output[7:0] sum,
  output cout,
  input[7:0] a,
  input[7:0] b,
  input cin
);
  adder_1_bit a0(.sum(sum[0]), .cout(cout0), .a(a[0]), .b(b[0]), .cin(cin));
  adder_1_bit a1(.sum(sum[1]), .cout(cout1), .a(a[1]), .b(b[1]), .cin(cout0));
  adder_1_bit a2(.sum(sum[2]), .cout(cout2), .a(a[2]), .b(b[2]), .cin(cout1));
  adder_1_bit a3(.sum(sum[3]), .cout(cout3), .a(a[3]), .b(b[3]), .cin(cout2));
  adder_1_bit a4(.sum(sum[4]), .cout(cout4), .a(a[4]), .b(b[4]), .cin(cout3));
  adder_1_bit a5(.sum(sum[5]), .cout(cout5), .a(a[5]), .b(b[5]), .cin(cout4));
  adder_1_bit a6(.sum(sum[6]), .cout(cout6), .a(a[6]), .b(b[6]), .cin(cout5));
  adder_1_bit a7(.sum(sum[7]), .cout(cout), .a(a[7]), .b(b[7]), .cin(cout6));
endmodule

module adder_32_bit
(
  output[31:0] sum,
  output cout,
  output ofl,
  input[31:0] a,
  input[31:0] b,
  input cin
);
  adder_8_bit a0(.sum(sum[7:0]), .cout(cout0), .a(a[7:0]), .b(b[7:0]), .cin(cin));
  adder_8_bit a1(.sum(sum[15:8]), .cout(cout1), .a(a[15:8]), .b(b[15:8]), .cin(cout0));
  adder_8_bit a2(.sum(sum[23:16]), .cout(cout2), .a(a[23:16]), .b(b[23:16]), .cin(cout1));
  adder_8_bit a3(.sum(sum[31:24]), .cout(cout), .a(a[31:24]), .b(b[31:24]), .cin(cout2));
  // Overflow has occured if:
  //   The result of adding two positive numbers is negative
  //   The result of adding two negative numbers is positive
  wire same_sign, switched;
  `XNOR xnor0(same_sign, a[31], b[31]);
  `XOR xor0(switched, sum[31], a[31]);
  `AND and0(ofl, same_sign, switched);
endmodule

// INVERTER

module inverter_1_bit
(
  output out,
  input in
);
  `NOT not0(out, in);
endmodule

module inverter_8_bit
(
  output[7:0] out,
  input[7:0] in
);
  inverter_1_bit inv0(.out(out[0]), .in(in[0]));
  inverter_1_bit inv1(.out(out[1]), .in(in[1]));
  inverter_1_bit inv2(.out(out[2]), .in(in[2]));
  inverter_1_bit inv3(.out(out[3]), .in(in[3]));
  inverter_1_bit inv4(.out(out[4]), .in(in[4]));
  inverter_1_bit inv5(.out(out[5]), .in(in[5]));
  inverter_1_bit inv6(.out(out[6]), .in(in[6]));
  inverter_1_bit inv7(.out(out[7]), .in(in[7]));
endmodule

module inverter_32_bit
(
  output[31:0] out,
  input[31:0] in
);
  inverter_8_bit inv0(.out(out[7:0]), .in(in[7:0]));
  inverter_8_bit inv1(.out(out[15:8]), .in(in[15:8]));
  inverter_8_bit inv2(.out(out[23:16]), .in(in[23:16]));
  inverter_8_bit inv3(.out(out[31:24]), .in(in[31:24]));
endmodule

// XOR

module xor_1_bit
(
  output out,
  input a,
  input b
);
  `XOR xor0(out, a, b);
endmodule

module xor_8_bit
(
  output[7:0] out,
  input[7:0] a,
  input[7:0] b
);
  xor_1_bit xor0(.out(out[0]), .a(a[0]), .b(b[0]));
  xor_1_bit xor1(.out(out[1]), .a(a[1]), .b(b[1]));
  xor_1_bit xor2(.out(out[2]), .a(a[2]), .b(b[2]));
  xor_1_bit xor3(.out(out[3]), .a(a[3]), .b(b[3]));
  xor_1_bit xor4(.out(out[4]), .a(a[4]), .b(b[4]));
  xor_1_bit xor5(.out(out[5]), .a(a[5]), .b(b[5]));
  xor_1_bit xor6(.out(out[6]), .a(a[6]), .b(b[6]));
  xor_1_bit xor7(.out(out[7]), .a(a[7]), .b(b[7]));
endmodule

module xor_32_bit
(
  output[31:0] out,
  input[31:0] a,
  input[31:0] b
);
  xor_8_bit xor0(.out(out[7:0]),   .a(a[7:0]),   .b(b[7:0]));
  xor_8_bit xor1(.out(out[15:8]),  .a(a[15:8]),  .b(b[15:8]));
  xor_8_bit xor2(.out(out[23:16]), .a(a[23:16]), .b(b[23:16]));
  xor_8_bit xor3(.out(out[31:24]), .a(a[31:24]), .b(b[31:24]));
endmodule

// NAND

module nand_1_bit
(
  output out,
  input a,
  input b
);
  `NAND nand0(out, a, b);
endmodule

module nand_8_bit
(
  output[7:0] out,
  input[7:0] a,
  input[7:0] b
);
  nand_1_bit nand0(.out(out[0]), .a(a[0]), .b(b[0]));
  nand_1_bit nand1(.out(out[1]), .a(a[1]), .b(b[1]));
  nand_1_bit nand2(.out(out[2]), .a(a[2]), .b(b[2]));
  nand_1_bit nand3(.out(out[3]), .a(a[3]), .b(b[3]));
  nand_1_bit nand4(.out(out[4]), .a(a[4]), .b(b[4]));
  nand_1_bit nand5(.out(out[5]), .a(a[5]), .b(b[5]));
  nand_1_bit nand6(.out(out[6]), .a(a[6]), .b(b[6]));
  nand_1_bit nand7(.out(out[7]), .a(a[7]), .b(b[7]));
endmodule

module nand_32_bit
(
  output[31:0] out,
  input[31:0] a,
  input[31:0] b
);
  nand_8_bit nand0(.out(out[7:0]),   .a(a[7:0]),   .b(b[7:0]));
  nand_8_bit nand1(.out(out[15:8]),  .a(a[15:8]),  .b(b[15:8]));
  nand_8_bit nand2(.out(out[23:16]), .a(a[23:16]), .b(b[23:16]));
  nand_8_bit nand3(.out(out[31:24]), .a(a[31:24]), .b(b[31:24]));
endmodule

// NOR

module nor_1_bit
(
  output out,
  input a,
  input b
);
  `NOR nor0(out, a, b);
endmodule

module nor_8_bit
(
  output[7:0] out,
  input[7:0] a,
  input[7:0] b
);
  nor_1_bit nor0(.out(out[0]), .a(a[0]), .b(b[0]));
  nor_1_bit nor1(.out(out[1]), .a(a[1]), .b(b[1]));
  nor_1_bit nor2(.out(out[2]), .a(a[2]), .b(b[2]));
  nor_1_bit nor3(.out(out[3]), .a(a[3]), .b(b[3]));
  nor_1_bit nor4(.out(out[4]), .a(a[4]), .b(b[4]));
  nor_1_bit nor5(.out(out[5]), .a(a[5]), .b(b[5]));
  nor_1_bit nor6(.out(out[6]), .a(a[6]), .b(b[6]));
  nor_1_bit nor7(.out(out[7]), .a(a[7]), .b(b[7]));
endmodule

module nor_32_bit
(
  output[31:0] out,
  input[31:0] a,
  input[31:0] b
);
  nor_8_bit nor0(.out(out[7:0]),   .a(a[7:0]),   .b(b[7:0]));
  nor_8_bit nor1(.out(out[15:8]),  .a(a[15:8]),  .b(b[15:8]));
  nor_8_bit nor2(.out(out[23:16]), .a(a[23:16]), .b(b[23:16]));
  nor_8_bit nor3(.out(out[31:24]), .a(a[31:24]), .b(b[31:24]));
endmodule

// 32:1 NAND

module nand_32_to_1
(
  output out,
  input[31:0] in
);
  `NAND32 nand0(out,
    in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7],
    in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15],
    in[16], in[17], in[18], in[19], in[20], in[21], in[22], in[23],
    in[24], in[25], in[26], in[27], in[28], in[29], in[30], in[31]
  );
endmodule

// SLT

module byte_to_zero
(
  output[7:0] out
);
  `OR or0(out[0], 0, 0);
  `OR or1(out[1], 0, 0);
  `OR or2(out[2], 0, 0);
  `OR or3(out[3], 0, 0);
  `OR or4(out[4], 0, 0);
  `OR or5(out[5], 0, 0);
  `OR or6(out[6], 0, 0);
  `OR or7(out[7], 0, 0);
endmodule

module or_1_to_32
(
  output[31:0] out,
  input in
);
  `OR or0(out[0], 0, in);
  `OR or1(out[1], 0, 0);
  `OR or2(out[2], 0, 0);
  `OR or3(out[3], 0, 0);
  `OR or4(out[4], 0, 0);
  `OR or5(out[5], 0, 0);
  `OR or6(out[6], 0, 0);
  `OR or7(out[7], 0, 0);

  byte_to_zero byte_or0(out[15:8]);
  byte_to_zero byte_or1(out[23:16]);
  byte_to_zero byte_or2(out[31:24]);
endmodule

// MUX

module mux_1_bit
(
  output out,
  input a,
  input b,
  input s
);
  wire not_s, a_and_not_s, b_and_s;
  `NOT not0(not_s, s);
  `AND and0(a_and_not_s, a, not_s);
  `AND and1(b_and_s, b, s);
  `OR or0(out, a_and_not_s, b_and_s);
endmodule

module mux_8_bit
(
  output[7:0] out,
  input[7:0] a,
  input[7:0] b,
  input s
);
  mux_1_bit mux0(.out(out[0]), .a(a[0]), .b(b[0]), .s(s));
  mux_1_bit mux1(.out(out[1]), .a(a[1]), .b(b[1]), .s(s));
  mux_1_bit mux2(.out(out[2]), .a(a[2]), .b(b[2]), .s(s));
  mux_1_bit mux3(.out(out[3]), .a(a[3]), .b(b[3]), .s(s));
  mux_1_bit mux4(.out(out[4]), .a(a[4]), .b(b[4]), .s(s));
  mux_1_bit mux5(.out(out[5]), .a(a[5]), .b(b[5]), .s(s));
  mux_1_bit mux6(.out(out[6]), .a(a[6]), .b(b[6]), .s(s));
  mux_1_bit mux7(.out(out[7]), .a(a[7]), .b(b[7]), .s(s));
endmodule

module mux_32_bit
(
  output[31:0] out,
  input[31:0] a,
  input[31:0] b,
  input s
);
  mux_8_bit mux0(.out(out[7:0]), .a(a[7:0]), .b(b[7:0]), .s(s));
  mux_8_bit mux1(.out(out[15:8]), .a(a[15:8]), .b(b[15:8]), .s(s));
  mux_8_bit mux2(.out(out[23:16]), .a(a[23:16]), .b(b[23:16]), .s(s));
  mux_8_bit mux3(.out(out[31:24]), .a(a[31:24]), .b(b[31:24]), .s(s));
endmodule

// 5 way mux

module mux_1_bit_5_way
(
  output out,
  input a,
  input b,
  input c,
  input d,
  input e,
  input[2:0] sel
);
  wire a_or_b, c_or_d, top_or_bottom;
  // 4 bit to 2 bit
  mux_1_bit mux0(.out(a_or_b), .a(a), .b(b), .s(sel[0]));
  mux_1_bit mux1(.out(c_or_d), .a(c), .b(d), .s(sel[0]));
  // 2 bit to 1 bit
  mux_1_bit mux2(.out(top_or_bottom), .a(a_or_b), .b(c_or_d), .s(sel[1]));
  // 0-4 or 5
  mux_1_bit mux3(.out(out), .a(top_or_bottom), .b(e), .s(sel[2]));
endmodule

module mux_8_bit_5_way
(
  output[7:0] out,
  input[7:0] a,
  input[7:0] b,
  input[7:0] c,
  input[7:0] d,
  input[7:0] e,
  input[2:0] sel
);
  mux_1_bit_5_way mux0(.out(out[0]), .a(a[0]), .b(b[0]), .c(c[0]), .d(d[0]), .e(e[0]), .sel(sel));
  mux_1_bit_5_way mux1(.out(out[1]), .a(a[1]), .b(b[1]), .c(c[1]), .d(d[1]), .e(e[1]), .sel(sel));
  mux_1_bit_5_way mux2(.out(out[2]), .a(a[2]), .b(b[2]), .c(c[2]), .d(d[2]), .e(e[2]), .sel(sel));
  mux_1_bit_5_way mux3(.out(out[3]), .a(a[3]), .b(b[3]), .c(c[3]), .d(d[3]), .e(e[3]), .sel(sel));
  mux_1_bit_5_way mux4(.out(out[4]), .a(a[4]), .b(b[4]), .c(c[4]), .d(d[4]), .e(e[4]), .sel(sel));
  mux_1_bit_5_way mux5(.out(out[5]), .a(a[5]), .b(b[5]), .c(c[5]), .d(d[5]), .e(e[5]), .sel(sel));
  mux_1_bit_5_way mux6(.out(out[6]), .a(a[6]), .b(b[6]), .c(c[6]), .d(d[6]), .e(e[6]), .sel(sel));
  mux_1_bit_5_way mux7(.out(out[7]), .a(a[7]), .b(b[7]), .c(c[7]), .d(d[7]), .e(e[7]), .sel(sel));
endmodule

module mux_32_bit_5_way
(
  output[31:0] out,
  input[31:0] a,
  input[31:0] b,
  input[31:0] c,
  input[31:0] d,
  input[31:0] e,
  input[2:0] sel
);
  mux_8_bit_5_way mux0(.out(out[7:0]),   .a(a[7:0]),   .b(b[7:0]),   .c(c[7:0]),   .d(d[7:0]),   .e(e[7:0]),   .sel(sel));
  mux_8_bit_5_way mux1(.out(out[15:8]),  .a(a[15:8]),  .b(b[15:8]),  .c(c[15:8]),  .d(d[15:8]),  .e(e[15:8]),  .sel(sel));
  mux_8_bit_5_way mux2(.out(out[23:16]), .a(a[23:16]), .b(b[23:16]), .c(c[23:16]), .d(d[23:16]), .e(e[23:16]), .sel(sel));
  mux_8_bit_5_way mux3(.out(out[31:24]), .a(a[31:24]), .b(b[31:24]), .c(c[31:24]), .d(d[31:24]), .e(e[31:24]), .sel(sel));
endmodule

// IS ZERO

module is_zero
(
  output out,
  input[31:0] num
);
  wire[31:0] not_num;
  wire not_and_not_num;
  inverter_32_bit inv0(.out(not_num), .in(num));
  nand_32_to_1 nand0(.out(not_and_not_num), .in(not_num));
  `NOT not0(out, not_and_not_num);
endmodule

// MAIN ALU

module ALU
(
  output[31:0] res,
  output cout,
  output ofl,
  output zero,
  input[31:0] a,
  input[31:0] b,
  input[2:0] cmd
);
  wire[2:0] muxindex;
  wire invert_b, cin, invert_res;
  alu_cmd_lut lut(.muxindex(muxindex), .invert_b(invert_b), .cin(cin), .invert_res(invert_res), .cmd(cmd));

  // ADD, SUB, and SLT
  wire[31:0] not_b, adder_input, adder_output, slt_output, xor_output, nand_output, nor_output;
  inverter_32_bit inverter0(.out(not_b), .in(b));
  mux_32_bit mux0(.out(adder_input), .a(b), .b(not_b), .s(invert_b));
  adder_32_bit adder(.sum(adder_output[31:0]), .cout(cout), .ofl(ofl), .a(a[31:0]), .b(adder_input[31:0]), .cin(cin));

  or_1_to_32 slt(.out(slt_output), .in(adder_output[31]));

  xor_32_bit xor0(.out(xor_output), .a(a), .b(b));
  nand_32_bit nand0(.out(nand_output), .a(a), .b(b));
  nor_32_bit nor0(.out(nor_output), .a(a), .b(b));

  mux_32_bit_5_way big_mux(
    .out(pre_res[31:0]),
    .a(slt_output[31:0]),
    .b(xor_output[31:0]),
    .c(nand_output[31:0]),
    .d(nor_output[31:0]),
    .e(adder_output[31:0]),
    .sel(muxindex[2:0])
  );

  wire[31:0] not_res, pre_res;
  inverter_32_bit inverter1(.out(not_res), .in(pre_res));
  mux_32_bit mux1(.out(res), .a(pre_res), .b(not_res), .s(invert_res));

  is_zero zero0(.out(zero), .num(res[31:0]));
endmodule