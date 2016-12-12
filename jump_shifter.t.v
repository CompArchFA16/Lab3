//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "jump_shifter.v"

module testjump_shifter();

    reg             clk;
    reg[25:0]       immediate;
    reg[3:0]        pc_bits;
    wire[31:0]      extended_imm;

    
    // Instantiate with parameter width = 8
    jump_shifter dut(immediate, pc_bits,extended_imm);
    always begin
    #1 clk = ~clk;
    end

    initial begin

        clk=1; 
        pc_bits = 4'b0101;
        immediate = 26'b11111111111111111111111111; #0


        $display("  immediate               |     Ext      ");
        $display("    %b      |   %b   ",  immediate, extended_imm);
 
        immediate = 26'b01111111111111111111111111; #0


        $display("  immediate               |     Ext      ");
        $display("    %b      |   %b   ",  immediate, extended_imm);       

        #2 $finish;
    end

endmodule
