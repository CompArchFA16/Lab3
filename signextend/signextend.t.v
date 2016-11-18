// Test bench for sign extend immediate

`timescale 1 ns / 1 ps
`include "signextend.v"

module testsignextend ();
  wire[31:0] signextended;
  reg[15:0] immediate;
  reg       issigned;
  reg pass;
  signextend se1 (signextended, immediate, issigned);

  initial begin
  
    $dumpfile("signextended.vcd");
    $dumpvars(0,testsignextend);
    pass = 1;
    $display("SignExtended Test:");

    immediate=16'hFFFF; issigned=1'b0; #1000
    if(signextended != 32'd65535) begin
      $display("Test 1 Fail:");
      $display("signextended: %b", signextended);
    end
    
    immediate=16'hFFFF; issigned=1'b1; #1000
    if(signextended != 32'b11111111111111111111111111111111) begin
      $display("Test 2 Fail:");
      $display("signextended: %b", signextended);
    end

    immediate=16'h0000; issigned=1'b0; #1000
    if(signextended != 32'b0) begin
      $display("Test 3 Fail:");
      $display("signextended: %b", signextended);
    end

    immediate=16'h0000; issigned=1'b1; #1000
    if(signextended != 32'b0) begin
      $display("Test 4 Fail:");
      $display("signextended: %b", signextended);
    end
    
    if (pass == 1) begin
            $display("SignExtended Tests Passed");
        end
        else begin
            $display("SignExtended Tests Failed");
        end
  end

endmodule
