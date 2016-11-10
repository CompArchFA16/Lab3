module controlUnit (
  output RegWriteD,
  output MemToRegD,
  output MemWriteD,
  output BranchD,
  output ALUControlD,
  output ALUSrcD,
  output RegDstD,

  input [5:0] Op,
  input [5:0] Funct
);
endmodule
