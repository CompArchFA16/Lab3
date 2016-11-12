//------------------------------------------------------------------------
// Sign Extender test bench
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "signextend.v"

module testsignextend();

    reg             clk;
    reg[15:0]       immediate;
    wire[31:0]      extended_imm;

    
    // Instantiate with parameter width = 8
    signextend dut(immediate, extended_imm);
    always begin
    #1 clk = ~clk;
    //#6 peripheralClkEdge= ~peripheralClkEdge;
    end

    initial begin
    	// Your Test Code
        $dumpfile("signextend.vcd");
        $dumpvars();

        clk=1; 
        immediate = 16'b1010101010101010; #0

        $display("  immediate               |     Ext      ");
        $display("    %b      |   %b   ",  immediate[15:0], extended_imm);

        immediate = 16'b0010101010101010; #0

        $display("  immediate               |     Ext      ");
        $display("    %b      |   %b   ",  immediate[15:0], extended_imm);

        #2 $finish;
    end

endmodule

// module testsignextend_26();

//     reg             clk;
//     reg[25:0]       immediate;
//     wire[31:0]      extended_imm;

    
//     // Instantiate with parameter width = 8
//     signextend_26 dut(immediate, extended_imm);
//     always begin
//     #1 clk = ~clk;
//     end

//     initial begin
//         // Your Test Code
//         $dumpfile("signextend.vcd");
//         $dumpvars();

//         clk=1; 
        
//         immediate = 26'b11111111111111111111111111; #0


//         $display("  immediate               |     Ext      ");
//         $display("    %b      |   %b   ",  immediate, extended_imm);
 
//         immediate = 26'b01111111111111111111111111; #0


//         $display("  immediate               |     Ext      ");
//         $display("    %b      |   %b   ",  immediate, extended_imm);       

//         #2 $finish;
//     end

// endmodule
