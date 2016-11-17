//------------------------------------------------------------------------------
// Test harness validates alutestbench by connecting it to alu, and verifying that it works
//------------------------------------------------------------------------------
//`include "register.v"
//`include "alu.v"
//`include "alucontrol.v"
//`include "cpu.v"
//`include "instMem.v"
//`include "pc.v"
//`include "register.v"
//`include "signExtend.v"
//`include "control.v"
//`include "datamemory.v"
`include "alu.t.v"
`include "datamem.t.v"
//`include "instructionmem.t.v"
`include "signextend.t.v"

module fulltestbenchharness();


  wire   begintest;  // Set High to begin testing alu
  wire    dutpassed;  // Indicates whether alu passed tests

alutestbenchharness alu();
datamemtestbenchharness datamem();
//instructionmemtestbenchharness inst();
setestbenchharness se();

endmodule
