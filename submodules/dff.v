// D Flip Flop
module dFF
(
input       clk,
input       d,
input       wrenable,
output reg  q

);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule

module mux_32_bit
(
  output reg [31:0] out,
  input [31:0] a,
  input [31:0] b,
  input addr
);
   initial begin
      if (addr) 
	out = b; 
      else 
	out = a;
   end
endmodule
