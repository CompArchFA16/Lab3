`include "instructionDecoder.v"
module testInstructionDecoder();

	reg[31:0] instruction;
	wire [5:0] Opp, Funct;
	wire [4:0] Rs, Rt, Rd, Shamt;
	wire [15:0] Imm;
	wire [25:0] Jadd;

	instructionDecoder id0 (instruction, Opp, Rs, Rt, Rd, Shamt, Funct, Imm, Jadd);

	initial begin
		instruction = 32'b00000011111010101010111100000111; #1000;
		$display("Instruction: %b", instruction);
		$display("Opp   |Rs   |Rt   |Rd   |Shamt|Funct |Imm             |Jadd");
		$display("%b|%b|%b|%b|%b|%b|%b|%b", Opp, Rs, Rt, Rd, Shamt, Funct, Imm, Jadd);
	end
	endmodule
