module control
(
	input clk,
	input [5:0] instruction, //instruction[31:26]

	output reg RegDst,
	output reg Branch,
	output reg MemRead,
	output reg MemtoReg,
	output reg [2:0] ALUOp,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite
);

initial begin
	RegDst <= 0;
	RegWrite <=0;
	ALUSrc <=0;
	MemWrite <=0;
	MemRead <=0;
	MemtoReg <=0;
	Branch <=0;
	ALUOp[1] <=0;
	ALUOp[0] <=0;
end

always @(posedge clk) begin

	case(instruction)

		6'b000000: begin //jr, add, sub, slt
			RegDst <= 0;
			RegWrite <=0;
			ALUSrc <=0;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=1;
			ALUOp[1] <=0;
			ALUOp[0] <=0;
		end

		6'b000010: begin //j 
			RegDst <= 0;
			RegWrite <=0;
			ALUSrc <=0;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=1;
			ALUOp[1] <=0;
			ALUOp[0] <=0;
		end

		6'b000011: begin //jal
			RegDst <= 0;
			RegWrite <=1;
			ALUSrc <=0;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=1;
			ALUOp[1] <=0;
			ALUOp[0] <=0;
		end

		6'b000101: begin //bne
			RegDst <= 0;
			RegWrite <=0;
			ALUSrc <=0;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=1;
			ALUOp[1] <=0;
			ALUOp[0] <=1;
		end

		6'b001110: begin //xori
			RegDst <= 0;
			RegWrite <=1;
			ALUSrc <=1;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=0;
			ALUOp[1] <=1;
			ALUOp[0] <=0;
		end

		6'b100011: begin //lw
			RegDst <= 0;
			RegWrite <=1;
			ALUSrc <=1;
			MemWrite <=0;
			MemRead <=1;
			MemtoReg <=1;
			Branch <=0;
			ALUOp[1] <=0;
			ALUOp[0] <=0;
		end

		6'b101011: begin //sw
			RegDst <= 0;
			RegWrite <=1;
			ALUSrc <=1;
			MemWrite <=0;
			MemRead <=0;
			MemtoReg <=0;
			Branch <=0;
			ALUOp[1] <=0;
			ALUOp[0] <=0;
		end

		default: begin
		end

	endcase
end
endmodule