module mux32(
	output [31:0] out,
	input address,
	input [31:0] input0,
	input [31:0] input1 
	);
	mux2Input #(32, 32) U0(.out(out), .address(address), .input0(input0), .input1(input1));
endmodule

module mux2Input
#(
  parameter out_width  = 1,
  parameter in_width   = 1
)
(
  output reg [out_width-1:0] out,
  input address,
  input [in_width-1:0] input0,
  input [in_width-1:0] input1 
);

	always @(address) begin
		if (address) begin
			out <= input1;
		end
		else begin
			out <= input0;
		end
	end

endmodule