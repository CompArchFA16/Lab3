`include "ram.v"

module testRAM ();

  reg dutPassed;

  wire [31:0] dataOut;
  reg         clk;
  reg  [31:0] address;
  reg         writeEnable;
  reg  [31:0] dataIn;

  RAM dut (
    .dataOut(dataOut),
    .clk(clk),
    .address(address),
    .writeEnable(writeEnable),
    .dataIn(dataIn)
  );

  initial clk = 0;
  always #1 clk = !clk;

  initial begin

    $dumpfile("ram.vcd");
    $dumpvars;
    dutPassed = 1;

    #1;

    dataIn      = 32'h15090002;
    address     = 32'd0;
    writeEnable = 1'b1;
    #2;
    writeEnable = 1'bZ;
    #2;
    if (dataOut !== 32'h15090002) begin
      $display("Loading failed.");
      dutPassed = 0;
    end

    $display("dutPassed: %b", dutPassed);
    $finish;
  end
endmodule
