//------------------------------------------------------------------------
// Sign Extender test bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "signextend.v"

module testsignextend();

    reg             clk;
    reg[15:0]       immediate;
    wire[31:0]      extended_imm;

    reg dutpassed;

    
    // Instantiate with parameter width = 8
    signextend dut(extended_imm, immediate);
    always begin
    #1 clk = ~clk;
    //#6 peripheralClkEdge= ~peripheralClkEdge;
    end

    initial begin
    	// Your Test Code
        // $dumpfile("signextend.vcd");
        // $dumpvars();

        dutpassed =1;

        clk=1; 
        immediate = 16'b1010101010101010; #0
        if(extended_imm != 32'b11111111111111111010101010101010) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 1 Failed: MSB in imm 1 implementation failed");
        end
        else begin
            $display("Test Case 1 Passed");
        end
        #2


        // $display("  immediate               |     Ext      ");
        // $display("    %b      |   %b   ",  immediate[15:0], extended_imm);

        immediate = 16'b0010101010101010; #0

        if(extended_imm != 32'b00000000000000000010101010101010) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 2 Failed: MSB in imm 0 implementation failed");
        end
        else begin
            $display("Test Case 2 Passed");
        end
        #2

        $display("dutpassed: %b",  dutpassed);


        // $display("  immediate               |     Ext      ");
        // $display("    %b      |   %b   ",  immediate[15:0], extended_imm);

        #2 $finish;
    end

endmodule
