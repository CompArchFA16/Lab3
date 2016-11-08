module exmem_reg (

  input clk,

  // control signals
  output reg regWriteM,
  output reg memToRegM,
  output reg memWriteM,
  output reg branchM,

  input regWriteE,
  input memToRegE,
  input memWriteE,
  input branchE,
   
  // cpu wires
  output reg zeroM,
  output reg aluOutM,
  output reg writeDataM,
  output reg writeRegM,
  output reg pcBranchM,

  input zeroE,
  input aluOutE,
  input writeRegE,
  input writeDataE,
  input pcBranchE
);
	
	always @(posedge clk) begin
		// control signals
		regWriteM <= regWriteE;
		memToRegM <= memToRegE;
		memWriteM <= memWriteE;
		branchM <= branchE;

		// cpu wires
		zeroM <= zeroE;
		aluOutM <= aluOutE;
		writeDataM <= writeDataE;
		writeRegM <= writeRegE;
		pcBranchM <= pcBranchE;		
	end
endmodule
