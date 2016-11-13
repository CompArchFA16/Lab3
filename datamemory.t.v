
// Decoder testbench
`timescale 1 ns / 1 ps
`include "datamemory.v"

module testInstructionMem ();
    reg                           clk;
    reg [31*2 : 0] instructionSet;
    reg [31 : 0]   PC;
    wire [31:0]      instruction;
    

    //behavioralDecoder decoder (out0,out1,out2,out3,addr0,addr1,enable);
    instructionMem dut (clk, PC, instruction); // Swap after testing

    initial begin
    $dumpfile("instruction.vcd");
    $dumpvars(0,testInstructionMem);
    $display("instruction    PC");
    clk = 0; #10 clk = 1;
    PC = 32'd32; #1000 
    $display("%b  %h  ", instruction, PC);
    end

endmodule