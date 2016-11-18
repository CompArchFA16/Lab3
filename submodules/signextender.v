// 32 bit Sign Extender

module signextender (
	input clk,
	input [15:0] imm,
	output reg [31:0] signextendOut
	);

	always @ ( clk ) begin
    	if (imm[15] === 1'b0) begin // If the first bit is one, add 16 ones
      		signextendOut <= { 16'b0, imm };
    	end
    	else begin // Otherwise add 16 ones
      		signextendOut <= { 16'b1, imm };
    	end
	end

endmodule