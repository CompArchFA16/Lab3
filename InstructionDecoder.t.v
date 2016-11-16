`include "InstructionDecoder.v"
module testInstructionDecoder();

	reg [31:0] instruction;
	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] sa;
	wire [5:0] funct;
	wire [15:0] imm;
	wire [25:0] jadr;
	reg pass;

	instructionDecoder DUT(instruction, op, rs, rt, rd, sa, funct, imm, jadr);

	initial begin
		$dumpfile("instructionDecoder.vcd");
		$dumpvars(0, testInstructionDecoder);
		$display("InstructionDecoder Test:");
		pass = 1;

		instruction = 32'b00000111111001101000000000000000;	#10
		if(op!==6'b000001||rs!==5'b11111||rt!==5'b00110||rd!==5'b10000) begin
			pass = 0;
			$display("Test 1 Fail");
			$display("op: %b, rs: %b, rt: %b, rd: %b", op, rs, rt, rd);
		end

		instruction = 32'b01010100001100001000000111110000; #10
		if(op!==6'b010101||rs!==5'b00001||rt!=5'b10000||imm!==16'b1000000111110000) begin
			pass = 0;
			$display("Test 2 Fail");
			$display("op: %b, rs: %b, rt: %b. imm: %b", op, rs, rt, imm);	
		end

		instruction = 32'b00011111100001111100001001011011; #10
		if(op!==6'b000111||jadr!==26'b11100001111100001001011011) begin
			pass = 0;
			$display("Test 3 Fail");
			$display("op: %b, jadr: %b", op, jadr);
		end

		if (pass == 1) begin
            $display("InstructionDecoder Tests Passed");
        end
        else begin
            $display("InstructionDecoder Tests Failed");
        end
	end
endmodule