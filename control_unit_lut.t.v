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
    wire[2:0]   ALUcommand;
    wire[1:0]   Reg_Data_Src_Mux;
    wire        Jump;
    wire        Jump_Target_Mux;
    wire        Branch;
    reg[5:0]    controlUnitCommand;
    reg[5:0]    funct;

    reg             dutpassed;


    // ALU Translation
    `define ADD  3'd0
    `define SUB  3'd1
    `define XOR  3'd2
    `define SLT  3'd3
    `define AND  3'd4
    `define NAND 3'd5
    `define NOR  3'd6
    `define OR   3'd7



    LUTcaller dut(WrEn_Reg, WrEn_DM, WrAddr_Reg_Mux,
                   ALU_input, ALUcommand, Reg_Data_Src_Mux,
                   Jump, Jump_Target_Mux, Branch, controlUnitCommand,
                   funct);

    initial begin
    	// Your Test Code
        $dumpfile("controlUnitLUT.vcd");
        $dumpvars();

        dutpassed = 1;

        #2
        // I type command testing
        funct = 6'd14; #1                //xor

        controlUnitCommand = 6'd05; #2 //bne
        if((ALU_input != 1'b1)||(Branch != 1'b1)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b00)
            ||(WrAddr_Reg_Mux!=2'b00)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b0)
            ||(ALUcommand != `SUB)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 1 Failed: BNE implementation failed");
        end
        else begin
            $display("Test Case 1 Passed");
        end
        #1



        controlUnitCommand = 6'd35; #2 //lw
        if((ALU_input != 1'b0)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b00)
            ||(WrAddr_Reg_Mux!=2'b00)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 2 Failed: LW implementation failed");
        end
        else begin
            $display("Test Case 2 Passed");
        end

        controlUnitCommand = 6'd43; #2 //sw
        if((ALU_input != 1'b0)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b00)
            ||(WrAddr_Reg_Mux!=2'b00)||(WrEn_DM!=1'b1)||(WrEn_Reg!=1'b0)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 3 Failed: SW implementation failed");
        end
        else begin
            $display("Test Case 3 Passed");
        end

        // J type testing
        controlUnitCommand = 6'd02; #2 //j
        if((ALU_input != 1'b0)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b1)||(Reg_Data_Src_Mux!=2'b00)
            ||(WrAddr_Reg_Mux!=2'b00)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b0)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 4 Failed: J implementation failed");
        end
        else begin
            $display("Test Case 4 Passed");
        end

        controlUnitCommand = 6'd03; #2 //jal
        if((ALU_input != 1'b0)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b1)||(Reg_Data_Src_Mux!=2'b10)
            ||(WrAddr_Reg_Mux!=2'b10)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 5 Failed: JAL implementation failed");
        end
        else begin
            $display("Test Case 5 Passed");
        end

        controlUnitCommand = 6'd14; #2                //xor
        if((ALU_input != 1'b1)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b01)
            ||(WrAddr_Reg_Mux!=2'b01)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)
            ||(ALUcommand != 3'b010)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 6 Failed: XOR implementation failed");
        end
        else begin
            $display("Test Case 6 Passed");
        end

        // R type testing
        controlUnitCommand = 6'd00; //r type

        // R type funct testing
        funct = 6'd32; #2                //add
        if((ALU_input != 1'b1)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b01)
            ||(WrAddr_Reg_Mux!=2'b01)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)
            ||(ALUcommand != `ADD)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 7 Failed: ADD implementation failed");
        end
        else begin
            $display("Test Case 7 Passed");
        end

        funct = 6'd34; #2                //sub
        if((ALU_input != 1'b1)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b01)
            ||(WrAddr_Reg_Mux!=2'b01)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)
            ||(ALUcommand != `SUB)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 8 Failed: SUB implementation failed");
        end
        else begin
            $display("Test Case 8 Passed");
        end

        funct = 6'd42; #2                //slt
        if((ALU_input != 1'b1)||(Branch != 1'b0)
            ||(Jump != 1'b0)||(Jump_Target_Mux!=1'b0)||(Reg_Data_Src_Mux!=2'b01)
            ||(WrAddr_Reg_Mux!=2'b01)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b1)
            ||(ALUcommand != `SLT)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 9 Failed: SLT implementation failed");
        end
        else begin
            $display("Test Case 9 Passed");
        end

        funct = 6'd8;  #2                //jr
        if((ALU_input != 1'b0)||(Branch != 1'b0)
            ||(Jump != 1'b1)||(Jump_Target_Mux!=1'b1)||(Reg_Data_Src_Mux!=2'b00)
            ||(WrAddr_Reg_Mux!=2'b00)||(WrEn_DM!=1'b0)||(WrEn_Reg!=1'b0)) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 10 Failed: JR implementation failed");
        end
        else begin
            $display("Test Case 10 Passed");
        end
        $finish;
    end

endmodule
