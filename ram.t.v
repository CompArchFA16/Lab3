`include "ram.v"

module testRAM ();

  reg dutPassed;

  wire [31:0] readData1;
  wire [31:0] readData2;
  reg         clk;
  reg  [31:0] address1;
  reg  [31:0] address2;
  reg  [31:0] dataIn;
  reg         writeEnable;

  RAM dut (
    .readData1(readData1),
    .readData2(readData2),
    .clk(clk),
    .address1(address1),
    .address2(address2),
    .dataIn(dataIn),
    .writeEnable(writeEnable)
  );

  initial clk = 0;
  always #1 clk = !clk;

  initial begin

    $dumpfile("ram.vcd");
    $dumpvars;
    dutPassed = 1;

    #1;

    dataIn      = 32'h15090002;
    address2     = 32'd0;
    writeEnable = 1'b1;
    #2;
    writeEnable = 1'bZ;
    #2;
    if (readData2 !== 32'h15090002) begin
      $display("Loading failed.");
      dutPassed = 0;
    end

    $display(">>> TEST ram ....... %b", dutPassed);
    $finish;
  end
endmodule
