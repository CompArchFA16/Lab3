// Notation Simplification for Control unit LUT Commands

// I type ops
`define BNE      6'd05
`define LW       6'd35
`define SW       6'd43

// J type ops
`define J        6'd2
`define JAL      6'd3

// R Type ops
`define R_type   6'd0
// R type functs
`define JR_c       6'd8
`define XOR_c      6'd38
`define ADD_c      6'd32
`define SUB_c      6'd34
`define SLT_c      6'd42

// ALU Translation
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7


module LUTcaller // Converts the commands to a more convenient format
(
    output reg       WrEn_Reg,
    output reg       WrEn_DM,
    output reg[1:0]  WrAddr_Reg_Mux,
    output reg       ALU_input,
    output reg[2:0]  ALUcommand,
    output reg[1:0]  Reg_Data_Src_Mux,
    output reg       JumpR,
    output reg       Jump_Target_Mux,
    output reg       Branch,
    input[5:0]       controlUnitCommand,
    input[5:0]       funct
);

    wire       WrEn_Reg1;
    wire       WrEn_DM1;
    wire[1:0]  WrAddr_Reg_Mux1;
    wire       ALU_input1;
    wire[2:0]  ALUcommand1;
    wire[1:0]  Reg_Data_Src_Mux1;
    wire       JumpR1;
    wire  Jump_Target_Mux1;
    wire       Branch1;

    wire       WrEn_Reg2;
    wire       WrEn_DM2;
    wire[1:0]  WrAddr_Reg_Mux2;
    wire       ALU_input2;
    wire[2:0]  ALUcommand2;
    wire[1:0]  Reg_Data_Src_Mux2;
    wire       JumpR2;
    wire  Jump_Target_Mux2;
    wire       Branch2;

    controlUnitLUT  lut_ctrl(WrEn_Reg1, WrEn_DM1, WrAddr_Reg_Mux1, ALU_input1, ALUcommand1, 
                            Reg_Data_Src_Mux1, JumpR1, Jump_Target_Mux1, Branch1, controlUnitCommand, funct);

    R_type_LUT      R_ctrl(WrEn_Reg2, WrEn_DM2, WrAddr_Reg_Mux2, ALU_input2, ALUcommand2, 
                            Reg_Data_Src_Mux2, JumpR2, Jump_Target_Mux2, Branch2, funct);

    always@* begin
        if (controlUnitCommand == 6'd0) begin
            WrEn_Reg <= WrEn_Reg2;
            WrEn_DM <= WrEn_DM2;
            WrAddr_Reg_Mux <= WrAddr_Reg_Mux2;
            ALU_input <= ALU_input2;
            ALUcommand <= ALUcommand2;
            Reg_Data_Src_Mux <= Reg_Data_Src_Mux2;
            JumpR <= JumpR2;
            Jump_Target_Mux <= Jump_Target_Mux2;
            Branch <= Branch2;     
        end
        else begin
            WrEn_Reg <= WrEn_Reg1;
            WrEn_DM <= WrEn_DM1;
            WrAddr_Reg_Mux <= WrAddr_Reg_Mux1;
            ALU_input <= ALU_input1;
            ALUcommand <= ALUcommand1;
            Reg_Data_Src_Mux <= Reg_Data_Src_Mux1;
            JumpR <= JumpR1;
            Jump_Target_Mux <= Jump_Target_Mux1;
            Branch <= Branch1;      
        end
    end

endmodule


module controlUnitLUT // Converts the commands to a more convenient format
(
    output reg       WrEn_Reg,
    output reg       WrEn_DM,
    output reg[1:0]  WrAddr_Reg_Mux,
    output reg       ALU_input,
    output reg[2:0]  ALUcommand,
    output reg[1:0]  Reg_Data_Src_Mux,
    output reg       JumpR,
    output reg       Jump_Target_Mux,
    output reg       Branch,
    input[5:0]       controlUnitCommand,
    input[5:0]       funct
);

    always @(controlUnitCommand) begin
      case (controlUnitCommand)
            `BNE:      begin WrEn_Reg = 0; WrEn_DM = 0; WrAddr_Reg_Mux = 0;    ALU_input = 1; ALUcommand = `SUB;    Reg_Data_Src_Mux = 0;      JumpR = 0; Jump_Target_Mux = 0; Branch = 1; end
            `LW:       begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0;    ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
            `SW:       begin WrEn_Reg = 0; WrEn_DM = 1; WrAddr_Reg_Mux = 0;    ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
            `J:        begin WrEn_Reg = 0; WrEn_DM = 0; WrAddr_Reg_Mux = 0;    ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      JumpR = 0; Jump_Target_Mux = 1; Branch = 0; end
            `JAL:      begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 2'd2; ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 2'd2;   JumpR = 0; Jump_Target_Mux = 1; Branch = 0; end
       endcase
    end
endmodule

module R_type_LUT // Converts the commands to a more convenient format
(
    output reg       WrEn_Reg,
    output reg       WrEn_DM,
    output reg[1:0]  WrAddr_Reg_Mux,
    output reg       ALU_input,
    output reg[2:0]  ALUcommand,
    output reg[1:0]  Reg_Data_Src_Mux,
    output reg       JumpR,
    output reg       Jump_Target_Mux,
    output reg       Branch,
    input[5:0]       funct
);

    always @(funct) begin
      case (funct)
            `JR_c:      begin WrEn_Reg = 0; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = 6'd0;    Reg_Data_Src_Mux = 0;      JumpR = 1; Jump_Target_Mux = 1; Branch = 0; end
            `XOR_c:     begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 1; ALU_input = 1; ALUcommand = `XOR;    Reg_Data_Src_Mux = 1;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
            `ADD_c:     begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 1; ALU_input = 1; ALUcommand = `ADD;    Reg_Data_Src_Mux = 1;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
            `SUB_c:     begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 1; ALU_input = 1; ALUcommand = `SUB;    Reg_Data_Src_Mux = 1;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
            `SLT_c:     begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 1; ALU_input = 1; ALUcommand = `SLT;    Reg_Data_Src_Mux = 1;      JumpR = 0; Jump_Target_Mux = 0; Branch = 0; end
       endcase
    end
endmodule
