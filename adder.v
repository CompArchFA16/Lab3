module adder (
  output [31:0] out,
  input  [31:0] left,
  input  [31:0] right
);
  assign out = left + right;
endmodule
