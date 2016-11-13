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
`define JR       6'd8
`define XOR      6'd38
`define ADD      6'd32
`define SUB      6'd34
`define SLT      6'd42
// other R type functs we don't use
`define AND      6'd36
`define NOR      6'd39
`define OR       6'd37

module controlUnitLUT // Converts the commands to a more convenient format
(
    output reg       WrEn_Reg,
    output reg       WrEn_DM,
    output reg[1:0]  WrAddr_Reg_Mux,
    output reg       ALU_input,
    output reg[5:0]  ALUcommand,
    output reg[1:0]  Reg_Data_Src_Mux,
    output reg       Jump,
    output reg[1:0]  Jump_Target_Mux,
    output reg       Branch,
    input[5:0]       controlUnitCommand,
    input[5:0]       funct
);

    always @(controlUnitCommand) begin
      case (controlUnitCommand)
        if((controlUnitCommand == `R_type)&&(funct == `JR)) begin
            `R_type:   begin WrEn_Reg = 0; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = funct;   Reg_Data_Src_Mux = 0;      Jump = 1; Jump_Target_Mux = 1; Branch = 0; end
        end
        else begin
            `LW:       begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
            `SW:       begin WrEn_Reg = 0; WrEn_DM = 1; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
            `J:        begin WrEn_Reg = 0; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 0;      Jump = 1; Jump_Target_Mux = 1; Branch = 0; end
            `JAL:      begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 0; ALUcommand = `ADD;    Reg_Data_Src_Mux = 2'd2;   Jump = 1; Jump_Target_Mux = 1; Branch = 0; end
            `R_type:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 1; ALU_input = 1; ALUcommand = funct;   Reg_Data_Src_Mux = 1;      Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        end
       endcase
    end
endmodule
