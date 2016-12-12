// Contains the 1-bit, 4-bit, and 32-bit ALUs

module ALU_1bit  // Computes all ALU operations for 1-bit operands
(
    output      result,
    output      carryout,
    input       operandA,
    input       operandB,
    input[2:0]  muxIndex,
    input       carryin,
    input       invertB,
    input       othercontrolsignal
);

    // Inverts B, if flag is on
    wire notB, trueB;
    not #10 not0(notB, operandB);
    mux_1bit mux_invertB(trueB, invertB, operandB, notB);

    // Instantiates gates for each ALU operation
    wire wAddSub, wXor, wNandAnd, wNorOr;
    adder_1bit adder(wAddSub, carryout, operandA, trueB, carryin);
    xor_1bit xor_gate(wXor, operandA, operandB);
    nand_and_1bit nand_and_gate(wNandAnd, operandA, operandB, othercontrolsignal);
    nor_or_1bit nor_or_gate(wNorOr, operandA, operandB, othercontrolsignal);

    // Result is selected by a MUX (depends on muxIndex)
    mux_alu mainMux(result, muxIndex[0], muxIndex[1], muxIndex[2], wAddSub, wXor, wNandAnd, wNorOr, 0);
endmodule

module ALU_4bit  // Strings together four 1-bit ALUs
(
    output[3:0]     result,
    output          carryout,
    output          zero,
    output          overflow,
    input[3:0]      operandA,
    input[3:0]      operandB,
    input[2:0]      command
);

    // Instantiates the control LUT
    wire[2:0] muxIndex;
    wire invertB, othercontrolsignal;
    ALUcontrolLUT controlLUT(muxIndex, invertB, othercontrolsignal, command);

    // First bit of the ALU
    wire[2:0] int_carryout; // intermediate carryouts
    wire resultFirst;
    ALU_1bit aluFirst(resultFirst, int_carryout[0], operandA[0], operandB[0], muxIndex, invertB, invertB, othercontrolsignal);

    // Middle bits of the ALU
    genvar i;
    generate
      for (i=1; i<3; i=i+1) begin : ALU4
        ALU_1bit _alu(result[i], int_carryout[i], operandA[i], operandB[i], muxIndex, int_carryout[i-1], invertB, othercontrolsignal);
      end
    endgenerate

    // Last bit of the ALU
    wire resultLast;
    ALU_1bit aluLast(result[3], carryout, operandA[3], operandB[3], muxIndex, int_carryout[2], invertB, othercontrolsignal);

    // Calculates overflow
    xor_1bit xor_overflow(overflow, int_carryout[2], carryout);

    // Failsafe adder for the last bit (since SLT sets almost everything to 0)
    wire sub_b, sub_sumleft, sub_carryout;
    not gen_sub_b(sub_b, operandB[3]);
    adder_1bit aluSub(sub_sumleft, sub_carryout, operandA[3], sub_b, int_carryout[2]);

    // Calculates SLT
    wire sltValue;
    xor_1bit xor_slt(sltValue, sub_sumleft, overflow);
    mux_1bit sltOut(result[0], muxIndex[2], resultFirst, sltValue);

    // Calculates zero (4-input NOR)
    nor #40 nor_zero(zero, result[0], result[1], result[2], result[3]);
endmodule

module ALU // 32-bit ALU
(
    output[31:0]    result,
    output          carryout,
    output          zero,
    output          overflow,
    input[31:0]     operandA,
    input[31:0]     operandB,
    input[2:0]      command
);

    // Instantiates the control LUT
    wire[2:0] muxIndex;
    wire invertB, othercontrolsignal;
    ALUcontrolLUT controlLUT(muxIndex, invertB, othercontrolsignal, command);

    // First bit of the ALU
    wire[30:0] int_carryout;
    wire resultFirst;
    ALU_1bit aluFirst(resultFirst, int_carryout[0], operandA[0], operandB[0], muxIndex, invertB, invertB, othercontrolsignal);

    // Middle bits of the ALU
    genvar i;
    generate
      for (i=1; i < 31; i=i+1) begin : ALU32
        ALU_1bit _alu(result[i], int_carryout[i], operandA[i], operandB[i], muxIndex, int_carryout[i-1], invertB, othercontrolsignal);
      end
    endgenerate

    // Last bit of the ALU
    wire resultLast;
    ALU_1bit aluLast(result[31], carryout, operandA[31], operandB[31], muxIndex, int_carryout[30], invertB, othercontrolsignal);

    // Calculates overflow
    xor_1bit xor_overflow(overflow, int_carryout[30], carryout);

    // Failsafe adder for the last bit (since SLT sets almost everything to 0)
    wire sub_b, sub_sumleft, sub_carryout;
    not gen_sub_b(sub_b, operandB[31]);
    adder_1bit aluSub(sub_sumleft, sub_carryout, operandA[31], sub_b, int_carryout[30]);

    // Calculates SLT
    wire sltValue;
    xor_1bit xor_slt(sltValue, sub_sumleft, overflow);
    mux_1bit sltOut(result[0], muxIndex[2], resultFirst, sltValue);

    // Calculates zero (32-input NOR)
    nor #320 nor_zero(zero, result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7]
                          , result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                          , result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23]
                          , result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]);
endmodule

// Notation Simplification for ALU Commands
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module ALUcontrolLUT // Converts the commands to a more convenient format
(
    output reg[2:0]     muxindex,
    output reg  invertB,
    output reg  othercontrolsignal,
    input[2:0]  ALUcommand
);

    always @(ALUcommand) begin
      case (ALUcommand)
        `ADD:  begin muxindex = 0; invertB=0; othercontrolsignal = 0; end
        `SUB:  begin muxindex = 0; invertB=1; othercontrolsignal = 0; end
        `XOR:  begin muxindex = 1; invertB=0; othercontrolsignal = 0; end
        `NAND: begin muxindex = 2; invertB=0; othercontrolsignal = 0; end
        `AND:  begin muxindex = 2; invertB=0; othercontrolsignal = 1; end
        `NOR:  begin muxindex = 3; invertB=0; othercontrolsignal = 0; end
        `OR:   begin muxindex = 3; invertB=0; othercontrolsignal = 1; end
        `SLT:  begin muxindex = 4; invertB=1; othercontrolsignal = 0; end
      endcase
    end
endmodule
