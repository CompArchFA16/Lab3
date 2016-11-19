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
    reg dutpassed;

    cpu dut(clk);

    always begin
    #15000 clk = ~clk;
    //#6 peripheralClkEdge= ~peripheralClkEdge;
    end

    initial begin
        dutpassed = 1;




        display("dutpassed: %b",  dutpassed);
    end

    // initial begin
    // end

endmodule

