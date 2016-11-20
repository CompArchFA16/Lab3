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
    reg start = 0;
    reg dutpassed;

    cpu dut(clk, start);

    always begin
        #15000 clk = ~clk;
        if (~start) start = 1;
    end

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars;

        clk = 1;

        #700000

        dutpassed = 1;
        $display("dutpassed: %b",  dutpassed);

        $finish;
    end

endmodule
