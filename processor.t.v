`include "processor.v"

module testProcessor();

   reg clk;
   cpu CPU(clk);
   
   initial clk=0;
   always #50 clk = !clk;

   initial begin
      $dumpfile("testProcessor.vcd");
      $dumpvars();
      $display("Testing processor.");

      #100000

      $finish;
   end
endmodule
