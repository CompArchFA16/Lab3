module pc
(	
	input clk,
	input pc_in,
	output reg pc_out
);

always @(posedge clk) begin
	pc_out <= pc_in;
end

endmodule