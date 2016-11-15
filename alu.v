module alu(

  output reg [31:0] aluRes,
  output reg zero,
  input [2:0] alucontrol,
  input [31:0] a, b,
  input clk

);

  //I don't think we need to deal with cin/cout

	always @(clk) begin
    //add
		if (alucontrol == 3'b001) begin
			aluRes <= a + b;
		end

    //sub
    	else if (alucontrol == 3'b010) begin
			aluRes <= a - b;
		end

    //slt
    	else if (alucontrol == 3'b011) begin
			aluRes <= (a < b) ? 1 : 0;
		end

    //xori
    	else if (alucontrol == 3'b100) begin
			aluRes <= a ^ b;
		end

		else begin 
			aluRes <= 32'b0;
		end

		assign zero = ~|aluRes;

	end
endmodule
