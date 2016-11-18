`timescale 1ns / 1ps

module pc
(	
	input 			  clk,
	input [31:0] 	  pc_in,
	output reg [31:0] pc_out
);

initial begin
	pc_out <=32'b0;
end
always @(posedge clk) begin
	pc_out <= pc_in ;
end

endmodule