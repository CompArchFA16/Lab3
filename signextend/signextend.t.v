// Test bench for sign extend immediate

`timescale 1 ns / 1 ps
`include "signextend.v"

module testsignextend ();
  wire[31:0] signextended;
  reg[15:0] immediate;
  reg       issigned;

  signextend se1 (signextended, immediate, issigned);

  initial begin
    $display("   Immediate   | issigned | signextended | PASS");
    immediate=16'hFFFF; issigned=1'b0; #1000
    $display("%b |    %b     | %b | %s", immediate, issigned, signextended, signextended == {16'b0, immediate}? "PASS" : "FAIL");
    immediate=16'hFFFF; issigned=1'b1; #1000
    $display("%b |    %b     | %b | %s", immediate, issigned, signextended, signextended == {~16'b0, immediate}? "PASS" : "FAIL");
    immediate=16'h0000; issigned=1'b0; #1000
    $display("%b |    %b     | %b | %s", immediate, issigned, signextended, signextended == {16'b0, immediate}? "PASS" : "FAIL");
    immediate=16'h0000; issigned=1'b1; #1000
    $display("%b |    %b     | %b | %s", immediate, issigned, signextended, signextended == {16'b0, immediate}? "PASS" : "FAIL");
  end

endmodule
