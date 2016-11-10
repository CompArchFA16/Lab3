module controlUnit (
  output regWrite_ID,
  output memToReg_ID,
  output memWrite_ID,
  output branch_ID,
  output aluControl_ID,
  output aluSrc_ID,
  output regDst_ID,

  input [5:0] op,
  input [5:0] funct
);
endmodule
