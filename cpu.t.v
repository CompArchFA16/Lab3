//------------------------------------------------------------------------
// Control unit LUT test bnch
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "cpu.v"
`include "alu.v"
`include "control_unit_lut.v"
`include "datamemory.v"
`include "decoders.v"
`include "instructionmemory.v"
`include "jump_shifter.v"
`include "multiplexers.v"
`include "regfile.v"
`include "signextend.v"

module testcpu();

    reg clk; 


    cpu dut(clk);

    // initial begin
    // end

endmodule

