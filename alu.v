module alu(

  output reg [31:0] aluRes,
  output reg zero,
  input [5:0] opcode,
	input [31:0] a, b

);

  //I don't think we need to deal with cin/cout

	always @(opcode) begin
    //add
		if (opcode == 6'b10_0000) begin
			aluRes <= a + b;
		end

    //sub
    else if (opcode == 6'b10_0010) begin
			aluRes <= a - b;
		end

    //slt
    else if (opcode == 6'b10_1010) begin
			aluRes <= (a < b) ? 1 : 0;
		end

    //xori
    else if (opcode == 6'b00_1110) begin
			aluRes <= a ^ b;
		end

		assign zero = (a == b);

	end
endmodule
