module mux_2 #( parameter width  = 1 ) (
  output reg [width-1:0] out,
  input address,
  input [width-1:0] input0,
  input [width-1:0] input1
);
	always @( address ) begin
		if (address) begin
			out <= input1;
		end
		else begin
			out <= input0;
		end
	end
endmodule
