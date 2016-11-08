module gate_IF_ID (
  output [31:0] instruction_ID,
  output        pcPlus4_ID,
  input         clk,
  input  [31:0] instruction_IF,
  input         pcPlus4_IF
);

  reg [31:0] instructionReg;
  reg        pcPlus4Reg;

  assign instruction_ID = instructionReg;
  assign pcPlus4_ID     = pcPlus4Reg;

  always @ ( posedge clk ) begin
    instructionReg <= instruction_IF;
    pcPlus4Reg     <= pcPlus4_IF;
  end
endmodule
