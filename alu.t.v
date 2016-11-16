//------------------------------------------------------------------------------
// Test harness validates alutestbench by connecting it to alucontrol
//    and sending the control signals generated to the alu,
//    then verifying that it works as intended.
//------------------------------------------------------------------------------
//`include "register.v"
`include "alu.v"
`include "alucontrol.v"
//`include "cpu.v"
//`include "instMem.v"
//`include "pc.v"
//`include "register.v"
//`include "signExtend.v"
//`include "control.v"
//`include "datamemory.v"

module alutestbenchharness();

  wire [31:0]	aluRes;	// alu result output
  wire zero;	// alu output (if output is zero = 1)
  wire [31:0]	a, b;	// the two 31-bit inputs to be operated on
  //wire	clk;		// Clock (Positive Edge Triggered)

  wire [1:0] ALUop; // 2-bit control signal for alucontrol
  wire [5:0] instruction; // 6-bit instruction input to alucontrol
  wire [2:0] ALUcontrol; // 3-bit alu control input, output of alucontrol

  reg		begintest;	// Set High to begin testing alu
  wire		dutpassed;	// Indicates whether alu passed tests

alucontrol ALUcontroltest
(
  //.clk(clk),
  .ALUop(ALUop),
  .instruction(instruction),
  .ALUcontrol(ALUcontrol)
  );

alu ALUtest
(
  .aluRes(aluRes),
  .zero(zero),
  .alucontrol(ALUcontrol),
  .a(a),
  .b(b)
  //,
//  .clk(clk
//)
);


  // Instantiate test bench to test the DUT
  alutestbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .aluRes(aluRes),
    .zero(zero),
    .ALUcontrol(ALUcontrol),
    .a(a),
    .b(b),
    // .clk(clk),
    .ALUop(ALUop),
    .instruction(instruction)
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
    $display("ALU passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// ALU test bench
//   Generates signals to drive alu and passes them back up one
//   layer to the test harness.
//
//   Once 'begintest' is asserted, begin testing the alu.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module alutestbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// ALU DUT connections
  input [31:0] aluRes,
  input zero,
  input [2:0] ALUcontrol,
  output reg [31:0] a, b,
  // output reg clk,
  output reg [1:0] ALUop,
  output reg [5:0] instruction
);

  // Initialize register driver signals
  initial begin
    instruction=6'b00_1110;
    ALUop = 2'b0;
    a=32'd0;
    b=32'd0;
    // clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  //   Add 'a' and 'b': a = 30, b = 1.
  //   To pass, aluRes = 31.
    ALUop = 2'b00; //add, sub, or slt signal
    instruction=6'b10_0000; //add instruction
    a=32'd30;
    b=32'd1;
    #100
  // #5 clk=1; #5 clk=0;	// Generate two clock pulses
  // #5 clk=1; #5 clk=0;
  // Verify expectations and report test result
  if((aluRes != 31) || (zero != 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1: Addition Failed");
  end

  // Test Case 2:
  //   Subtract 'b' from 'a', a = 45, b = 5.
  //   To pass, aluRes = 40, zero = 0.
    ALUop = 2'b00; //add, sub, or slt signal
    instruction = 6'b10_0010; //subtraction instruction
    a=32'd45;
    b=32'd5;
    #100
  // #5 clk=1; #5 clk=0; // Generate two clock pulses
  // #5 clk=1; #5 clk=0;
  if((aluRes != 40) || (zero != 0)) begin
    dutpassed = 0;
    $display("Test Case 2: Subtraction Failed");
  end

  // Test Case 3:
  //   Select-less-than a and b. a = 5, b = 6.
  //   To pass, aluRes = 1.
    ALUop = 2'b00; //add, sub, or slt signal
    instruction = 6'b10_1010; //slt instruction
    a=32'd5;
    b=32'd6;
  // #5 clk=1; #5 clk=0; // Generate two clock pulses
  // #5 clk=1; #5 clk=0;
  #10
  if((aluRes != 1) || (zero != 0)) begin
    dutpassed = 0;
    $display("Test Case 3: SLT Failed");
  end

  // Test Case 4:
  //   Xori a and b. a = 5, b = 6.
  //   To pass, aluRes = 3
    ALUop = 2'b10; //xori signal
    instruction = 6'b00_1110; //xori instruction
    a=32'd5;
    b=32'd6;
  // #5 clk=1; #5 clk=0; // Generate two clock pulses
  // #5 clk=1; #5 clk=0;
  #10
  if((aluRes != 3) || (zero != 0)) begin
    dutpassed = 0;
    $display("Test Case 4: Xori Failed");
  end

    ALUop = 2'b00;
    instruction = 6'b00_0000; //non-ALU instruction
    a=32'd5;
    b=32'd6;
  // #5 clk=1; #5 clk=0; // Generate two clock pulses
  // #5 clk=1; #5 clk=0;
    #10
  if((aluRes != 0) || (zero != 1)) begin
    dutpassed = 0;
    $display("Test Case 5: zeros Failed");
    $display(ALUcontrol);
    $display(aluRes);
    $display(zero);
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
