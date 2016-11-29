// jump address concatenator

module concatenator (
  input [3:0] a,
  input [25:0] b,
  output reg [31:0] out
  );

  out <= { a, b, 2'b00 }

endmodule