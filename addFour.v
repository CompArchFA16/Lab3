module addFour (
  output reg [31:0] pcPlus4F,
  input clk,
  input [31:0] pc
);
	always @(posedge clk) begin
		pcPlus4F <= pc + 32'd4;
	end
	
endmodule