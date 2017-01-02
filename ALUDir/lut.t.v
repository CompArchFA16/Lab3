`timescale 1 ns / 1 ps
`include "lut.v"

module testLUT();
    reg [2:0] cmd;

    wire [2:0] sel;
    wire invert;

    aluLUT aluLUT0 (sel, invert, cmd);

    initial begin
        $display("cmd | sel inv | sel inv (expected)");
        cmd = `ADD; #1000
        $display("%b |   %d   %b | 0   0", cmd, sel, invert);
        cmd = `SUB; #1000
        $display("%b |   %d   %b | 0   1", cmd, sel, invert);
        cmd = `AND; #1000
        $display("%b |   %d   %b | 1   0", cmd, sel, invert);
        cmd = `NAND; #1000
        $display("%b |   %d   %b | 2   0", cmd, sel, invert);
        cmd = `NOR; #1000
        $display("%b |   %d   %b | 3   0", cmd, sel, invert);
        cmd = `OR; #1000
        $display("%b |   %d   %b | 4   0", cmd, sel, invert);
        cmd = `XOR; #1000
        $display("%b |   %d   %b | 5   0", cmd, sel, invert);
        cmd = `SLT; #1000
        $display("%b |   %d   %b | 6   0", cmd, sel, invert);
    end
endmodule
