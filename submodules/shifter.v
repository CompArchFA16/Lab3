// Bit shifter

module shift_by_two (
  output reg [31:0] out,
  input [3:0] in
);
   initial begin
      out <= (in<<2);
   end
endmodule
