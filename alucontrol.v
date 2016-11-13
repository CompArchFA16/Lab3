module alucontrol
(	
	input clk,
	input [1:0] ALUop,
	input [5:0] instruction, //instruction[5:0]
	output reg [2:0] ALUcontrol
);
	
initial begin
	ALUcontrol <= 3'b0;
end

always @(posedge clk) begin
	if (ALUop == 2'b10 && instruction == 6'b00_1110) begin //xori
		ALUcontrol <= 3'b100;
	end

	if (ALUop == 2'b00) begin //add, sub, slt
		if (instruction == 6'b10_0000) begin//add
			ALUcontrol <= 3'b001;
		end

		if (instruction == 6'b10_0010) begin//sub
			ALUcontrol <= 3'b010;
		end

		if (instruction == 6'b10_1010) begin//slt
			ALUcontrol <= 3'b011;
		end
	end
end


endmodule
