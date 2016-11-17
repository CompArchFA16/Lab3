//------------------------------------------------------------------------------
// Test harness tests control
//------------------------------------------------------------------------------
//`include "register.v"
//`include "alu.v"
//`include "alucontrol.v"
//`include "cpu.v"
//`include "instMem.v"
//`include "pc.v"
//`include "register.v"
//`include "signExtend.v"
`include "control.v"
//`include "datamemory.v"

module controltestbenchharness();

  wire clk;
  wire [5:0] instruction; //instruction[31:26]

  wire [1:0] RegDst; //Mux for Register_WriteRegister_in
  wire Branch; //AND with ALU_Zero_out to get PCSrc
  wire MemRead; //read data from data memory
  wire [1:0] MemtoReg; //Mux for selecting between DataMemory_ReadData_out
  wire [2:0] ALUOp; //for ALU control
  wire MemWrite; //write data to data memory
  wire ALUSrc; //goes to ALU control
  wire RegWrite;
  wire [1:0] Jump;


  reg		begintest;	// Set High to begin testing instMem
  wire		dutpassed;	// Indicates whether instMem passed tests

control controltest
(
  .clk(clk),
  .instruction(instruction),
  .RegDst(RegDst),
  .Branch(Branch),
  .MemRead(MemRead),
  .MemtoReg(MemtoReg),
  .ALUOp(ALUOp),
  .MemWrite(MemWrite),
  .ALUSrc(ALUSrc),
  .RegWrite(RegWrite),
  .Jump(Jump)
);

  // Instantiate test bench to test the DUT
  controltestbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .clk(clk),
    .instruction(instruction),
    .RegDst(RegDst),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump)
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
    $display("Control passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Control test bench
//   Generates signals to drive control and passes them back up one
//   layer to the test harness.
//
//   Once 'begintest' is asserted, begin testing control.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module controltestbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// ALU DUT connections
  output reg clk,
  output reg [5:0] instruction, //instruction[31:26]

  input [1:0] RegDst, //Mux for Register_WriteRegister_in
  input Branch, //AND with ALU_Zero_out to get PCSrc
  input MemRead, //read data from data memory
  input [1:0] MemtoReg, //Mux for selecting between DataMemory_ReadData_out
  input [2:0] ALUOp, //for ALU control
  input MemWrite, //write data to data memory
  input ALUSrc, //goes to ALU control
  input RegWrite,
  input [1:0] Jump
  );


  // Initialize register driver signals
  initial begin
    clk = 0;
    instruction = 0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   Instruction = 6'b100000. Ensure the correct control signals are generated. 
    instruction = 6'b100000;
  #5 clk=1; #5 clk=0; // Generate single clock pulse
  #10
     // Verify expectations and report test result
  if((RegDst != 2'b00) |
      (RegWrite != 1) | //check
      (ALUSrc != 0) |
      (MemWrite != 0) |
      (MemRead != 0) |
      (MemtoReg != 2'b00) |
      (Branch != 0) |
      (Jump != 2'b00) |
      (ALUOp != 3'b001)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Data Mem: Test Case 1 Failed");
  end

  // Test Case 2: 
  //   Instruction = 6'b100010. Ensure the correct control signals are generated. 
    instruction = 6'b100010;
  #5 clk=1; #5 clk=0; // Generate single clock pulse
  #10
     // Verify expectations and report test result
  if((RegDst != 2'b00) |
      (RegWrite != 1) | //check
      (ALUSrc != 0) |
      (MemWrite != 0) |
      (MemRead != 0) |
      (MemtoReg != 2'b00) |
      (Branch != 0) |
      (Jump != 2'b00) |
      (ALUOp != 3'b010)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Data Mem: Test Case 2 Failed");
  end


  // Test Case 3: 
  //   Instruction = 6'b001110. Ensure the correct control signals are generated. 
    instruction = 6'b001110;
  #5 clk=1; #5 clk=0; // Generate single clock pulse
  #10
     // Verify expectations and report test result
  if((RegDst != 2'b01) |
      (RegWrite != 1) | //check
      (ALUSrc != 1) |
      (MemWrite != 0) |
      (MemRead != 0) |
      (MemtoReg != 2'b00) |
      (Branch != 0) |
      (Jump != 2'b00) |
      (ALUOp != 3'b100)) begin
    dutpassed = 0;  // Set to 'false' on failure
    $display("Data Mem: Test Case 3 Failed");
  end

// If it does those ones fine, it's almost certainly sending the signals we told it to.

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;
end

endmodule