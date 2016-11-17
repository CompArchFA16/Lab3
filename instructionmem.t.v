//------------------------------------------------------------------------------
// Test harness validates instructionmemtestbench by connecting it to instruction memory, and verifying that it works
//------------------------------------------------------------------------------
//`include "register.v"
//`include "alu.v"
//`include "alucontrol.v"
//`include "cpu.v"
`include "instMem.v"
//`include "pc.v"
//`include "register.v"
//`include "signExtend.v"
//`include "control.v"
//`include "datamemory.v"

module instructionmemtestbenchharness
#(  parameter addresswidth  = 32,
    //parameter depth         = 2**addresswidth,
    parameter depth = 10,
    parameter width         = 32);

  wire  clk;    // Clock (Positive Edge Triggered)
  wire [31:0]	PC;	// program counter
  wire [31:0] instruction;	// instruction


  reg		begintest;	// Set High to begin testing instMem
  wire		dutpassed;	// Indicates whether instMem passed tests

instMem instMemtest
(
  .clk(clk),
  .PC(PC),
  .instruction(instruction)
);

  // Instantiate test bench to test the DUT
  instmemtestbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .clk(clk),
    .PC(PC),
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
    $display("Instruction Mem passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Instruction Memory test bench
//   Generates signals to drive instruction memory and passes them back up one
//   layer to the test harness.
//
//   Once 'begintest' is asserted, begin testing the instruction memory.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module instmemtestbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// ALU DUT connections
  output reg  clk,    // Clock (Positive Edge Triggered)
  output reg [31:0] PC, // program counter
  input [31:0] instruction  // instruction
);

  // Initialize instruction driver signals
  initial begin
    PC=32'd0; 
    clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   PC = 0. To pass, instruction = 32'h2008000a, 
  //   which is instruction memory at 0. 
    PC=32'd0; 
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #10
  // Verify expectations and report test result
  if(instruction != 32'h2008000a) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1: PC = 0 Failed");
  end

  // Test Case 2: 
  //   PC = 4. To pass, instruction = 32'h2008000b, 
  //   which is instruction memory at 4. 
    PC=32'd4; 
  #5 clk=1; #5 clk=0;
  #10
  if(instruction != 32'h2008000b) begin
    dutpassed = 0;
    $display("Test Case 2: PC = 4 Failed");
  end

  // Test Case 3: 
  //   PC = 8. To pass, instruction = 32'h2008000c, 
  //   which is instruction memory at 8. 
    PC=32'd8; 
  #5 clk=1; #5 clk=0;
  #10
  if(instruction != 32'h2008000c) begin
    dutpassed = 0;
    $display("Test Case 3: PC = 8 Failed");
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;
end

endmodule