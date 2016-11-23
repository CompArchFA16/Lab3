`include "opcodes.v"
`include "alu/alu_commands.v"

module control_unit (
  output reg regWrite_ID,
  output reg memToReg_ID,
  output reg memWrite_ID,
  output reg branch_ID,
  output reg [2:0] aluControl_ID,
  output reg aluSrc_ID,
  output reg regDst_ID,

  input [5:0] op,
  input [5:0] funct
);

  always @(op or funct) begin
    case (op)
      6'b0: begin
        case (funct)
          `CMD_add: begin
          // IF: From memory at address PC, write to IR. Update PC.
          // ID: From rs in Regfile, load to register A; from rt in RegFile, load to reg B.
          // EX: A+B is written to Result register
          // MEM:
          // WB: Result is written to rd in RegFile
            regWrite_ID   <= 1;
            memToReg_ID   <= 0;
            memWrite_ID   <= 0;
            branch_ID     <= 0;
            aluControl_ID <= `ALU_CMD_ADD;
            aluSrc_ID     <= 0;
            regDst_ID     <= 1;
          end
          `CMD_sub: begin
            regWrite_ID   <= 1;
            memToReg_ID   <= 0;
            memWrite_ID   <= 0;
            branch_ID     <= 0;
            aluControl_ID <= `ALU_CMD_SUB;
            aluSrc_ID     <= 0;
            regDst_ID     <= 1;
          end
          `CMD_slt: begin
          // IF: From memory at address PC, write to IR. Update PC.
          // ID: From rs in Regfile, load to register A, from rt in RegFile, write to reg B
          // EX: If (A<B) Set result set to 1. If not, set to 0.
          // MEM:
          // WB: Result is written to rd in RegFile
            regWrite_ID   <= 1;
            memToReg_ID   <= 0;
            memWrite_ID   <= 0;
            branch_ID     <= 0;
            aluControl_ID <= `ALU_CMD_SLT;
            aluSrc_ID     <= 0;
            regDst_ID     <= 1;
          end
          default: begin
            regWrite_ID   <= 0;
            memToReg_ID   <= 0;
            memWrite_ID   <= 0;
            branch_ID     <= 0;
            aluControl_ID <= `ALU_CMD_ADD;
            aluSrc_ID     <= 0;
            regDst_ID     <= 0;
          end
        endcase
      end
      `CMD_lw: begin
      // IF: From memory at address PC, write to IR. Update PC.
      // ID: From rs in Regfile, load to register A
      // EX: A + sign extended imm is written to Result register
      // MEM: Result (address) in Mem is written to DataReg
      // WB: Write DataReg to rt address in RegFile.
          regWrite_ID   <= 1;
          memToReg_ID   <= 1;
          memWrite_ID   <= 0;
          branch_ID     <= 0;
          aluControl_ID <= `ALU_CMD_ADD;
          aluSrc_ID     <= 1;
          regDst_ID     <= 0;
        end
      `CMD_sw: begin
      // IF: From memory at address PC, write to IR. Update PC.
      // ID: From rs in Regfile, load to register A. from rt in RegFile write to reg B
      // EX: A + sign extended imm is written to Result register
      // MEM: Write B to the Result address in Mem
      // WB:
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 1;
        branch_ID     <= 0;
        aluControl_ID <= `ALU_CMD_ADD;
        aluSrc_ID     <= 1;
        regDst_ID     <= 0;
      end
      `CMD_bne: begin
      // IF: From memory at address PC, write to IR. Update PC.
      // ID: From rs in Regfile, load to register A, from rt in RegFile, write to reg B
      //     Also, PC +sign extended imm is written to Res register
      // EX: If (A!==B) PC = Res
      // MEM:
      // WB:
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 1; //And ZeroM wire must be set to 1 (A-B should not output 0 - meaning they are not equal).
        aluControl_ID <= `ALU_CMD_SUB;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_xori: begin
        regWrite_ID   <= 1;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= `ALU_CMD_XOR;
        aluSrc_ID     <= 1;
        regDst_ID     <= 0;
      end
      default: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= `ALU_CMD_ADD;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
    endcase
  end
endmodule
