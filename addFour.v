module addFour (
  output [31:0] pcPlus4F,
  input [31:0] pc
);
		assign pcPlus4F = pc + 32'd4;
endmodule
