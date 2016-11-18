`timescale 1ns / 1ps

module alu(

  output [31:0] aluRes,
  output zero,
  input [2:0] alucontrol,
  input [31:0] a, b
);

  //I don't think we need to deal with cin/cout
reg [31:0] aluRes_reg;

always @* begin //NOTE: You are describing combo logic, since there is no clock signal
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
	assign zero = ~|aluRes_reg;
	assign aluRes = aluRes_reg;

endmodule
