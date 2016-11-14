`include "opcodes.v"

module controlUnit (
  output reg regWrite_ID,
  output reg memToReg_ID,
  output reg memWrite_ID,
  output reg branch_ID,
  output reg aluControl_ID,
  output reg aluSrc_ID,
  output reg regDst_ID,

  input [5:0] op,
  input [5:0] funct
);

  always @(op) begin
    case (op)
      `CMD_lw: begin
          regWrite_ID   <= 1;
          memToReg_ID   <= 1;
          memWrite_ID   <= 0;
          branch_ID     <= 0;
          aluControl_ID <= 000;
          aluSrc_ID     <= 1;
          regDst_ID     <= 0;
        end
      `CMD_sw: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 1;
        branch_ID     <= 0;
        aluControl_ID <= 000;
        aluSrc_ID     <= 1;
        regDst_ID     <= 0;
      end
      `CMD_j: begin
        // TODO: David
        // NOTE: Not even sure if these apply to J.
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 1;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_jr: begin
        // TODO: David
        // NOTE: Again, I don't think these apply.
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_jal: begin
        // TODO: David
        regWrite_ID   <= 1;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_bne: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_xori: begin
        regWrite_ID   <= 1;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 010;
        aluSrc_ID     <= 1;
        regDst_ID     <= 1;
      end
      `CMD_add: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_sub: begin
        // TODO: David
        regWrite_ID   <= 1;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0; // TODO: Reference ALU commands.
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_slt: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
    endcase
  end
endmodule
