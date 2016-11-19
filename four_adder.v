module four_adder (
  output [31:0] out,
  input  [31:0] in
);
  assign out = in + 32'h4;
endmodule
