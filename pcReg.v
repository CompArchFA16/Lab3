module pcReg (
  input clk,
  output reg [31:0] pc,
  input [31:0] prePC
);

	always @(posedge clk) begin
		pc <= prePC;	
	end
endmodule