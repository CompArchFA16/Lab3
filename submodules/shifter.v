// Bit shifter

module shift_by_two (
  output reg [31:0] out,
  input [3:0] in,
);
  out <= in<<2;
endmodule