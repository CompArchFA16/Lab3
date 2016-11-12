// Set Less Then testbench
`timescale 1 ns / 1 ps
`include "slt.v"

module testSLT();
    reg a, b, carryin;
    wire boolean, carryout;

    SLTcircuit setLessThan (overflow, carryout, sum, a, b, carryin);

    initial begin
    // $dumpfile("slt.vcd");
    // $dumpvars();
    $display("A B | Cin Cout | Overflow Sum");
    a=0; b=0; carryin=1; #1000
    $display( "%b %b | %b %b | %b %b", a, b, carryin, carryout, overflow, sum );
    a=1; b=0; carryin=1; #1000
    $display( "%b %b | %b %b | %b %b", a, b, carryin, carryout, overflow, sum );
    a=0; b=1; carryin=1; #1000
    $display( "%b %b | %b %b | %b %b", a, b, carryin, carryout, overflow, sum );
    a=1; b=1; carryin=1; #1000
    $display( "%b %b | %b %b | %b %b", a, b, carryin, carryout, overflow, sum );
    end
endmodule
