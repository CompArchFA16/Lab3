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
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_sw: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_j: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_jr: begin
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
      end
      `CMD_jal: begin
        regWrite_ID   <= 0;
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
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
        aluSrc_ID     <= 0;
        regDst_ID     <= 0;
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
        regWrite_ID   <= 0;
        memToReg_ID   <= 0;
        memWrite_ID   <= 0;
        branch_ID     <= 0;
        aluControl_ID <= 0;
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
