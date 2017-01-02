`include "signExtend.v"
module testSignExtend();
	reg [15:0] IMM;
	wire [31:0] signExtendIMM;

	signExtend se0 (IMM, signExtendIMM);

	initial begin
		$display("IMM|SE");
		IMM = 16'b1010101010101010; #10000
		$display("%b|%b", IMM, signExtendIMM);
	end

endmodule