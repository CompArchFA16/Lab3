//------------------------------------------------------------------------
// Control unit LUT test bnch
//------------------------------------------------------------------------
`timescale 1ns / 1ps

`include "control_unit_lut.v"

module testlut();

    wire        WrEn_Reg;
    wire        WrEn_DM;
    wire[1:0]   WrAddr_Reg_Mux;
    wire        ALU_input;
    wire[5:0]   ALUcommand;
    wire[1:0]   Reg_Data_Src_Mux;
    wire        Jump;
    wire[1:0]   Jump_Target_Mux;
    wire        Branch;
    reg[5:0]    controlUnitCommand;
    reg[5:0]    funct;


    LUTcaller dut(WrEn_Reg, WrEn_DM, WrAddr_Reg_Mux,
                   ALU_input, ALUcommand, Reg_Data_Src_Mux,
                   Jump, Jump_Target_Mux, Branch, controlUnitCommand,
                   funct);

    initial begin
    	// Your Test Code
        $dumpfile("controlUnitLUT.vcd");
        $dumpvars();

        #2
        // I type command testing
        controlUnitCommand = 6'd05; #0 //bne
        #2
        controlUnitCommand = 6'd35; #2 //lw
        controlUnitCommand = 6'd43; #2 //sw

        // J type testing
        controlUnitCommand = 6'd02; #2 //j
        controlUnitCommand = 6'd03; #2 //jal

        // R type testing
        controlUnitCommand = 6'd00; #2 //r type
        
        // R type funct testing
        funct = 6'd38; #2                //xor
        funct = 6'd32; #2                //add
        funct = 6'd34; #2                //sub
        funct = 6'd42; #2                //slt  
        funct = 6'd8;  #2                //jr   
        $finish;
    end

endmodule

