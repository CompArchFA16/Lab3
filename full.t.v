//------------------------------------------------------------------------------
// This test bench simply runs all the test benches for the individual modules. 
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
`include "instructionmem.t.v"
`include "signextend.t.v"
//`include "control.t.v"
`include "cpu.t.v"

module fulltestbenchharness();
  alutestbenchharness alu(); //tests alu and alucontrol
  datamemtestbenchharness datamem(); //tests data memory
  instructionmemtestbenchharness inst();
  setestbenchharness se(); //tests signextend
  //controltestbenchharness control();

endmodule
