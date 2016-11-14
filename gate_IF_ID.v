module gate_IF_ID (
  output reg [31:0] instruction_ID,
  output reg        pcPlus4_ID,
  input        clk,
  input [31:0] instruction_IF,
  input [31:0] pcPlus4_IF
);
  always @ ( posedge clk ) begin
    instruction_ID <= instruction_IF;
    pcPlus4_ID     <= pcPlus4_IF;
  end
endmodule
