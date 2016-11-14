`ifndef _dff
`define _dff

module dff #( parameter width  = 1 ) (
  output reg [width-1:0] out,
  input	clk,
  input	[width-1:0] in,
  input reset
);
  always @(posedge clk or negedge reset) begin
    if (~reset) begin
      out <= 1'b0;
    end else begin
      out <= in;
    end
  end
endmodule

`endif
