`timescale 1ns / 1ps

module alu(

  output [31:0] aluRes,
  output zero,
  input [2:0] alucontrol,
  input [31:0] a, b
);

	reg [31:0] aluRes_reg;

always @* begin 
	//add
	if (alucontrol == 3'b001) begin
		aluRes_reg <= a + b;
	end

	//sub
	else if (alucontrol == 3'b010) begin
		aluRes_reg <= a - b;
	end

	//slt
	else if (alucontrol == 3'b011) begin
		aluRes_reg <= (a < b) ? 32'b1 : 32'b0;
	end

	//xori
	else if (alucontrol == 3'b100) begin
		aluRes_reg <= a ^ b;
	end

	else begin 
		aluRes_reg <= 32'b0;
	end

end
	assign zero = ~|aluRes_reg; // If aluRes = 32'b0, zero is true
	assign aluRes = aluRes_reg;	// Set aluRes for output

endmodule
