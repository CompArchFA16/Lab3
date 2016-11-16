// ALU testbench
`include "submodules/alu.v"

// Define ALU command codes
`define CMD_ADD  3'd0
`define CMD_SUB  3'd1
`define CMD_XOR  3'd2
`define CMD_SLT  3'd3
`define CMD_AND  3'd4
`define CMD_NAND 3'd5
`define CMD_NOR  3'd6
`define CMD_OR   3'd7
`define N 32'd2147483647
`define M 32'd8566325

module testALU();
  reg[31:0] a, b;       // Stored inputs to adder
  reg[2:0] cmd;         // Command for ALU
  reg dutpassed;
  wire[31:0] res;       // Output display options
  wire cout;            // Carry out from ALU
  wire ofl;             // Overflow from ALU
  wire zero;            // Whether the result is zero

  ALU alu(
    .res    (res),
    .cout   (cout),
    .ofl    (ofl),
    .zero   (zero),
    .a      (a),
    .b      (b),
    .cmd    (cmd)
  );

  initial begin
    // $dumpfile("waveforms/testALU.vcd");
    // $dumpvars(0, testALU);

    dutpassed = 1;

    cmd=`CMD_ADD;

    a=0; b=0; #10;
    if (res  != 0 &&
        cout != 0 &&
        ofl  != 0 &&
        zero != 1) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 1");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000000  C: 0  O: 0  Z: 1");
    end

    a=1; b=1; #10;
    if (res  != 32'd2 &&
        cout != 0 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 2");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000010  C: 0  O: 0  Z: 0");
    end

    a=1073741823; b=1073741824; #10;
    if (res  != 32'd2147483648 &&
        cout != 0 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 3");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10000000 00000000 00000000 00000000  C: 0  O: 0  Z: 0");
    end

    a=-1717986919; b=286331153; #10;
    if (res  != -32'd1431655766 && // 10101010 10101010 10101010 10101010
        cout != 0 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 4");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10101010 10101010 10101010 10101010  C: 0  O: 0  Z: 0");
    end

    a=-1073741824; b=-1073741824; #10;
    if (res  != -32'd2147483648 && // 10000000 00000000 00000000 00000000
        cout != 1 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 5");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10000000 00000000 00000000 00000000  C: 1  O: 0  Z: 0");
    end

    a=-1; b=-1; #10;
    if (res  != -2 && // 11111111 11111111 11111111 11111110
        cout != 1 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 6");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 11111111 11111111 11111111 11111110  C: 1  O: 0  Z: 0");
    end

    a=1717986918; b=-1; #10;
    if (res  != 32'd1717986917 && // 01100110 01100110 01100110 01100101
        cout != 1 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 7");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 01100110 01100110 01100110 01100101  C: 1  O: 0  Z: 0");
    end

    a=1073741824; b=-1073741824; #10;
    if (res  != 32'd0 && // 00000000 00000000 00000000 00000000
        cout != 1 &&
        ofl  != 0 &&
        zero != 1) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 8");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000000  C: 1  O: 0  Z: 1");
    end

    a=1073741824; b=1073741824; #10;
    if (res  != 32'd2147483648 && // 10000000 00000000 00000000 00000000
        cout != 0 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 9");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10000000 00000000 00000000 00000000  C: 0  O: 1  Z: 0");
    end

    a=2147483647; b=2147483647; #10;
    if (res  != 32'b11111111111111111111111111111110 && // 11111111 11111111 11111111 11111110
        cout != 0 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 10");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 11111111 11111111 11111111 11111110  C: 0  O: 1  Z: 0");
    end

    a=1717986918; b=2147483647; #10;
    if (res  != 32'b11100110011001100110011001100101 &&
        cout != 0 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 11");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 11100110 01100110 01100110 01100101  C: 0  O: 1  Z: 0");
    end

    a=1431655765; b=1717986918; #10;
    if (res  != 32'b10111011101110111011101110111011 &&
        cout != 0 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 12");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10111011 10111011 10111011 10111011  C: 0  O: 1  Z: 0");
    end

    a=-2147483648; b=-2147483648; #10;
    if (res  != 32'd0 &&
        cout != 1 &&
        ofl  != 1 &&
        zero != 1) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 13");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000000  C: 1  O: 1  Z: 1");
    end

    a=-2147483648; b=-1; #10;
    if (res  != 32'b01111111111111111111111111111111 &&
        cout != 1 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 14");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 01111111 11111111 11111111 11111111  C: 1  O: 1  Z: 0");
    end

    a=-1431655766; b=-1717986919; #10;
    if (res  != 32'b01000100010001000100010001000011 &&
        cout != 1 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 15");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 01000100 01000100 01000100 01000011  C: 1  O: 1  Z: 0");
    end

    a=-1145324613; b=-1431655766; #10;
    if (res  != 32'b01100110011001100110011001100101 &&
        cout != 1 &&
        ofl  != 1 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 16");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 01100110 01100110 01100110 01100101  C: 1  O: 1  Z: 0");
    end

    cmd=`CMD_SUB;

    a=0; b=0; #10;
    if (res  != 32'd0 &&
        cout != 1 &&
        ofl  != 0 &&
        zero != 1) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 17");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000000  C: 1  O: 0  Z: 1");
    end

    a=1; b=1; #10;
    if (res  != 32'd0 &&
        cout != 1 &&
        ofl  != 0 &&
        zero != 1) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 18");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 00000000 00000000 00000000 00000000  C: 1  O: 0  Z: 1");
    end

    a=2147483647; b=1; #10;
    if (res  != 32'b01111111111111111111111111111110 &&
        cout != 1 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 19");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 01111111 11111111 11111111 11111110  C: 1  O: 0  Z: 0");
    end

    a=1; b=2147483647; #10;
    if (res  != 32'b10000000000000000000000000000010 &&
        cout != 0 &&
        ofl  != 0 &&
        zero != 0) begin
        dutpassed = 0;
        $display("ALU: FAILED ADD TEST 20");
        $display("  ACT | R: %b %b %b %b  C: %b  O: %b  Z: %b", res[31:24], res[23:16], res[15:8], res[7:0], cout, ofl, zero);
        $display("  EXP | R: 10000000 00000000 00000000 00000010  C: 0  O: 0  Z: 0");
    end

    if (dutpassed) begin
        $display("ALU: PASSED");
    end

  end

endmodule
