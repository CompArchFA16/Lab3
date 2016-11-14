`include "instructionDecoder.v"
module testInstructionDecoder();

	reg[31:0] instruction;
	wire [5:0] Opp;
	wire [4:0] Rs, Rt, Rd;
	wire [15:0] Imm;
	wire [25:0] Jadd;

	instructionDecoder id0 (instruction, Opp, Rs, Rt, Rd, Imm, Jadd);

	initial begin
		$display("instruction| Opp| Rs| Rt| Rd| Imm| Jadd");
		instruction = 32'b00000011111010101010111100000111; #1000;
		$display("%b|%b|%b|%b|%b|%b|%b",instruction,Opp, Rs, Rt, Rd, Imm, Jadd);

	end
	endmodule
