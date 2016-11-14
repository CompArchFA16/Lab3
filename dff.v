`ifndef _dff
`define _dff

module dff #( parameter width  = 1 ) (
  output reg [width-1:0] out,
  input	[width-1:0] in,
  input	clk
);
  always @(posedge clk) begin
    out <= in;
  end
endmodule

`endif
