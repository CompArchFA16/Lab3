// Notation Simplification for Control unit LUT Commands
`define LW   4'd0
`define SW   4'd1
`define J    4'd2
`define JR   4'd3
`define JAL  4'd4
`define BNE  4'd5
`define XOR  4'd6
`define ADD  4'd7
`define SUB  4'd8
`define SLT  4'd9

module controlUnitLUT // Converts the commands to a more convenient format
(
    output reg[2:0]     muxindex,
    output reg  invertB,
    output reg  othercontrolsignal,
    input[2:0]  ALUcommand
);

    always @(controlUnitCommand) begin
      case (controlUnitCommand)
        `LW:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 1; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `SW:   begin WrEn_Reg = 0; WrEn_DM = 1; WrAddr_Reg_Mux = 0; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `J:    begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `JR:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `JAL:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `BNE:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `XOR:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `ADD:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `SUB:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
        `SLT:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
      endcase
    end
endmodule
