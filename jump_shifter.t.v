//------------------------------------------------------------------------
// Jump shifter test bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "jump_shifter.v"

module testjump_shifter();

    reg             clk;
    reg[25:0]       immediate;
    reg[3:0]        pc_bits;
    wire[31:0]      extended_imm;

    reg             dutpassed;
    
    // Instantiate with parameter width = 8
    jump_shifter dut(extended_imm, immediate, pc_bits);
    always begin
    #1 clk = ~clk;
    end


    initial begin

        dutpassed = 1;

        clk=1; 
        pc_bits = 4'b0101;
        immediate = 26'b11111111111111111111111111; #0

        if(extended_imm != 32'b01011111111111111111111111111100) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 1 Failed: MSB in imm 1 implementation failed");
        end
        else begin
            $display("Test Case 1 Passed");
        end
        #2


        // $display("  immediate               |     Ext      ");
        // $display("    %b      |   %b   ",  immediate, extended_imm);
 
        immediate = 26'b01111111111111111111111111; #2
        if(extended_imm != 32'b01010111111111111111111111111100) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 2 Failed: MSB in imm 0 implementation failed");
        end
        else begin
            $display("Test Case 2 Passed");
        end


        // $display("  immediate               |     Ext      ");
        // $display("    %b      |   %b   ",  immediate, extended_imm);       


        $display("dutpassed: %b",  dutpassed);
        #2 $finish;
    end

endmodule
