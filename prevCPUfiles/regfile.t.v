/*Expand the provided test bench to classify the following register files:

A fully perfect register file. Return True when this is detected, false for all others.
Write Enable is broken / ignored – Register is always written to.
Decoder is broken – All registers are written to.
Register Zero is actually a register instead of the constant value zero.
Port 2 is broken and always reads register 17.
These will be graded by instantiating intentionally broken register files with your tester. Your tester must return true (works!) or false (broken!) as appropriate.

It is to your advantage to test more than just these cases to better ensure that your good register file is actually good.  */

//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------
 `include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests
  wire      endtest;

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );


  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
    if (dutpassed) begin
        $display("Passed Perfectly");
    end
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    $dumpfile("regfiletest.vcd");
    $dumpvars();
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  if((ReadData1 != 42) || (ReadData2 != 42)) begin
    dutpassed = 0;
    $display();
    $display("Test Case 1 Failed");
  end
  if ((ReadData1 == 42) & (ReadData2 == 42)) begin
  dutpassed= 1;
  $display("Test Case 1 Passed");
  end

  // Test Case 2:
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 != 15) || (ReadData2 != 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed");
  end
  if ((ReadData1 == 15 & ReadData2 == 15)) begin
  dutpassed = 1;
  $display("Test Case 2 Passed");
  end

  //Test Case 3
  // See if enable is broken or ignored, try to write to register 3 and verify with Read Ports 1 and 2 that it didn't write.
  WriteRegister = 5'd3;
  WriteData = 32'd26;
  RegWrite = 0; //Enable is LOW
  ReadRegister1 = 5'd3;
  ReadRegister2 = 5'd3;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 == 26) || (ReadData2 == 26)) begin //if it wrote anyway
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3 Failed");
  end
  else begin
  dutpassed = 1;
  $display("Test Case 3 Passed");
  end

  //Test Case 4
  //Decoder is broken – All registers are written to.
  //if a register is set to the same number as it is now, it will fail this test case without reason. It will look like the decoder also wrote to that register
  WriteRegister = 5'd4;
  WriteData = 32'd23;
  RegWrite = 1;
  ReadRegister1 = 5'd4;
  ReadRegister2 = 5'd5;
  #5 Clk=1; #5 Clk=0;
  if (ReadData1 == ReadData2 )begin
    dutpassed = 0;
    $display("Test Case 4 Failed");
    $display("%b %b", ReadData1, ReadData2);
  end
  else begin
    dutpassed = 1;
    $display("Test Case 4 Passed");
  end


  //Test Case 5
  //Is register 0 ever a number besides 0
  WriteRegister = 5'd0; //try to write to address 0
  WriteData = 32'd19;
  RegWrite = 1;
  ReadRegister1 = 5'd0; //read address 0 with read register 1
  ReadRegister2 = 5'd0; //read address 0 with read register 2
  #5 Clk=1; #5 Clk=0;

  if ((ReadData1 == 0) && (ReadData2 ==0)) begin
  dutpassed = 1; //Pass because they both read 0
  $display("Test Case 5 Passed");
  end
  else begin
  $display("Test Case 5 Failed");
  dutpassed = 0;
  end

  //Test Case 6
  //Port 2 always reads 17?
  WriteRegister = 5'd2;
  WriteData = 32'd17;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  //Set them both to 17?
  if((ReadData1 != 17) || (ReadData2 != 17)) begin
  dutpassed = 0;
  end

  WriteRegister = 5'd2;
  WriteData = 32'd31;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;
  //Set it to 31

    if ((ReadData1 == 31) || (ReadData2 == 31)) begin
        dutpassed = 1;
        $display("Test Case 6 Passed");
    end
  else begin
  dutpassed = 0;
  $display("Test Case 6 Failed");
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;
end
endmodule
