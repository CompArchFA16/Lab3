//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------


// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]  out,
input   enable,
input[4:0]  address
);

    assign out = enable<<address;

endmodule

// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg  q,
input   d,
input   wrenable,
input   clk
);

  always @(posedge clk) begin
    if(wrenable) begin
      q = d;
    end
  end

endmodule

module register32
(
output reg[31:0]  q,
input[31:0]       d,
input             wrenable,
input             clk
);

  always @(posedge clk) begin
    if(wrenable) begin
      q = d;
    end
  end

endmodule

module register32zero
(
output wire[31:0]  q,
input[31:0]       d,
input             wrenable,
input             clk
);
  assign q = 32'b0;
endmodule

module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);
  assign out=inputs[address];
endmodule

module mux32to1by32
(
output[31:0]    out,
input[4:0]      address,
input[31:0]
  input0,  input1,  input2,  input3,  input4,  input5,  input6,  input7,
  input8,  input9,  input10, input11, input12, input13, input14, input15,
  input16, input17, input18, input19, input20, input21, input22, input23,
  input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];         // Create a 2D array of wires
  assign mux[0]  = input0;       // Connect the sources of the array
  assign mux[1]  = input1;
  assign mux[2]  = input2;
  assign mux[3]  = input3;
  assign mux[4]  = input4;
  assign mux[5]  = input5;
  assign mux[6]  = input6;
  assign mux[7]  = input7;

  assign mux[8]  = input8;
  assign mux[9]  = input9;
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




module registerfile
(
output[31:0]  ReadData1,  // Contents of first register read
output[31:0]  ReadData2,  // Contents of second register read
input[31:0] WriteData,  // Contents to write to register
input[4:0]  ReadRegister1,  // Address of first register to read
input[4:0]  ReadRegister2,  // Address of second register to read
input[4:0]  WriteRegister,  // Address of register to write
input   RegWrite, // Enable writing of register when High
input   Clk   // Clock (Positive Edge Triggered)
);

  // These two lines are clearly wrong.  They are included to showcase how the
  // test harness works. Delete them after you understand the testing process,
  // and replace them with your actual code.
  // assign ReadData1 = 42;
  // assign ReadData2 = 42;

  // Decoder for Write Enable
  wire[31:0] WriteEnable;
  decoder1to32 decoder0(WriteEnable, RegWrite, WriteRegister);

  // Registers
  wire[31:0] q[31:0];
  register32zero r0(.q(q[0]), .d(WriteData), .wrenable(WriteEnable[0]), .clk(Clk));
  register32 r1 (.q(q[1]), .d(WriteData), .wrenable(WriteEnable[1]), .clk(Clk));
  register32 r2 (.q(q[2]), .d(WriteData), .wrenable(WriteEnable[2]), .clk(Clk));
  register32 r3 (.q(q[3]), .d(WriteData), .wrenable(WriteEnable[3]), .clk(Clk));
  register32 r4 (.q(q[4]), .d(WriteData), .wrenable(WriteEnable[4]), .clk(Clk));
  register32 r5 (.q(q[5]), .d(WriteData), .wrenable(WriteEnable[5]), .clk(Clk));
  register32 r6 (.q(q[6]), .d(WriteData), .wrenable(WriteEnable[6]), .clk(Clk));
  register32 r7 (.q(q[7]), .d(WriteData), .wrenable(WriteEnable[7]), .clk(Clk));

  register32 r8 (.q(q[8]), .d(WriteData), .wrenable(WriteEnable[8]), .clk(Clk));
  register32 r9 (.q(q[9]), .d(WriteData), .wrenable(WriteEnable[9]), .clk(Clk));
  register32 r10(.q(q[10]), .d(WriteData), .wrenable(WriteEnable[10]), .clk(Clk));
  register32 r11(.q(q[11]), .d(WriteData), .wrenable(WriteEnable[11]), .clk(Clk));
  register32 r12(.q(q[12]), .d(WriteData), .wrenable(WriteEnable[12]), .clk(Clk));
  register32 r13(.q(q[13]), .d(WriteData), .wrenable(WriteEnable[13]), .clk(Clk));
  register32 r14(.q(q[14]), .d(WriteData), .wrenable(WriteEnable[14]), .clk(Clk));
  register32 r15(.q(q[15]), .d(WriteData), .wrenable(WriteEnable[15]), .clk(Clk));

  register32 r16(.q(q[16]), .d(WriteData), .wrenable(WriteEnable[16]), .clk(Clk));
  register32 r17(.q(q[17]), .d(WriteData), .wrenable(WriteEnable[17]), .clk(Clk));
  register32 r18(.q(q[18]), .d(WriteData), .wrenable(WriteEnable[18]), .clk(Clk));
  register32 r19(.q(q[19]), .d(WriteData), .wrenable(WriteEnable[19]), .clk(Clk));
  register32 r20(.q(q[20]), .d(WriteData), .wrenable(WriteEnable[20]), .clk(Clk));
  register32 r21(.q(q[21]), .d(WriteData), .wrenable(WriteEnable[21]), .clk(Clk));
  register32 r22(.q(q[22]), .d(WriteData), .wrenable(WriteEnable[22]), .clk(Clk));
  register32 r23(.q(q[23]), .d(WriteData), .wrenable(WriteEnable[23]), .clk(Clk));

  register32 r24(.q(q[24]), .d(WriteData), .wrenable(WriteEnable[24]), .clk(Clk));
  register32 r25(.q(q[25]), .d(WriteData), .wrenable(WriteEnable[25]), .clk(Clk));
  register32 r26(.q(q[26]), .d(WriteData), .wrenable(WriteEnable[26]), .clk(Clk));
  register32 r27(.q(q[27]), .d(WriteData), .wrenable(WriteEnable[27]), .clk(Clk));
  register32 r28(.q(q[28]), .d(WriteData), .wrenable(WriteEnable[28]), .clk(Clk));
  register32 r29(.q(q[29]), .d(WriteData), .wrenable(WriteEnable[29]), .clk(Clk));
  register32 r30(.q(q[30]), .d(WriteData), .wrenable(WriteEnable[30]), .clk(Clk));
  register32 r31(.q(q[31]), .d(WriteData), .wrenable(WriteEnable[31]), .clk(Clk));

  mux32to1by32 mux0(.out(ReadData1), .address(ReadRegister1),
    .input0(q[0]),  .input1(q[1]),  .input2(q[2]),  .input3(q[3]),
    .input4(q[4]),  .input5(q[5]),  .input6(q[6]),  .input7(q[7]),
    .input8(q[8]),  .input9(q[9]),  .input10(q[10]), .input11(q[11]),
    .input12(q[12]), .input13(q[13]), .input14(q[14]), .input15(q[15]),
    .input16(q[16]), .input17(q[17]), .input18(q[18]), .input19(q[19]),
    .input20(q[20]), .input21(q[21]), .input22(q[22]), .input23(q[23]),
    .input24(q[24]), .input25(q[25]), .input26(q[26]), .input27(q[27]),
    .input28(q[28]), .input29(q[29]), .input30(q[30]), .input31(q[31]));
  mux32to1by32 mux1(.out(ReadData2), .address(ReadRegister2),
    .input0(q[0]),  .input1(q[1]),  .input2(q[2]),  .input3(q[3]),
    .input4(q[4]),  .input5(q[5]),  .input6(q[6]),  .input7(q[7]),
    .input8(q[8]),  .input9(q[9]),  .input10(q[10]), .input11(q[11]),
    .input12(q[12]), .input13(q[13]), .input14(q[14]), .input15(q[15]),
    .input16(q[16]), .input17(q[17]), .input18(q[18]), .input19(q[19]),
    .input20(q[20]), .input21(q[21]), .input22(q[22]), .input23(q[23]),
    .input24(q[24]), .input25(q[25]), .input26(q[26]), .input27(q[27]),
    .input28(q[28]), .input29(q[29]), .input30(q[30]), .input31(q[31]));

endmodule