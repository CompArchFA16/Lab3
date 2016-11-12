// Notation Simplification for Control unit LUT Commands
// `define LW   4'd0
// `define SW   4'd1
// `define J    4'd2
// `define JR   4'd3
// `define JAL  4'd4
// `define BNE  4'd5
// `define XOR  4'd6
// `define ADD  4'd7
// `define SUB  4'd8
// `define SLT  4'd9

`define LW       6'd8
`define SW       6'd9
`define J        6'd10
`define JAL      6'd11
`define BNE      6'd12
`define R_type   6'd13

// Notation Simplification for ALU Commands
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module controlUnitLUT // Converts the commands to a more convenient format
(
    output reg       WrEn_Reg,
    output reg       WrEn_DM,
    output reg       WrAddr_Reg_Mux,
    output reg       ALU_input,
    output reg       ALUcommand,
    output reg       Reg_Data_In_Mux,
    output reg       Jump,
    output reg       Jump_Target_Mux,
    output reg       Branch,
    output reg       signextend_ctrl,
    input[2:0]       controlUnitCommand,
    input[2:0]       ALUcommand
);

    always @(controlUnitCommand) begin
      case (controlUnitCommand)
        `LW:       begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 1; ALUcommand = `ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; signextend_ctrl = 0; end
        `SW:       begin WrEn_Reg = 0; WrEn_DM = 1; WrAddr_Reg_Mux = 0; ALU_input = 'rt'; ALUcommand = `ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; signextend_ctrl = 0; end
        `J:        begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = `ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; signextend_ctrl = 0; end
        `JAL:      begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = `ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; signextend_ctrl = 0; end
        `R_type:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ALUcommand; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; signextend_ctrl = 0; end
    endcase
    end


    // always @(controlUnitCommand) begin
    //   case (controlUnitCommand)
    //     `LW:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = 0; ALU_input = 1; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `SW:   begin WrEn_Reg = 0; WrEn_DM = 1; WrAddr_Reg_Mux = 0; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `J:    begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `JR:   begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `JAL:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `BNE:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `XOR:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `ADD:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `SUB:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //     `SLT:  begin WrEn_Reg = 1; WrEn_DM = 0; WrAddr_Reg_Mux = x; ALU_input = 'rt'; ALUcommand = ADD; Reg_Data_In_Mux = 'Datamem'; Jump = 0; Jump_Target_Mux = 0; Branch = 0; end
    //   endcase
    // end
endmodule
