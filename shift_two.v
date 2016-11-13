module shiftTwo (
  output reg [31:0] out,
  input        clk,
  input [31:0] in
);

  always @ ( posedge clk ) begin
    out <= { out[29:0], 2'b00 };
  end
endmodule
