// TODO: Potentially revisit.

module signExtend (
  output reg [31:0] out,
  input [15:0] in
);
  always @ (in) begin
    if (in[15] === 1'b0) begin
      out <= { 16'b0, in };
    end
    else begin
      out <= { 16'b1, in };
    end
  end
endmodule
