`define NOT not #10
`define AND and #330
`define OR or #330

module mux2Input
#(
  parameter out_width  = 32,
  parameter in_width   = 32
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