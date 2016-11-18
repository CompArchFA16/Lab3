// 32 bit Sign Extender

module signextender (
	input clk,
	input [15:0] imm,
	output reg [31:0] signExtendOut
	);

	always @ ( clk ) begin
    	if (in[15] === 1'b0) begin # If the first bit is one, add 16 ones
      		out <= { 16'b0, in };
    	end
    	else begin # Otherwise add 16 ones
      		out <= { 16'b1, in };
    	end
	end

endmodule