module gate_EX_MEM (

  output reg regWrite_MEM,
  output reg memToReg_MEM,
  output reg memWrite_MEM,
  output reg branch_MEM,

  output reg zero_MEM,
  output reg [31:0] aluOut_MEM,
  output reg [31:0] writeData_MEM,
  output reg writeReg_MEM,
  output reg [31:0] pcBranch_MEM,

  input clk,

  input regWrite_EX,
  input memToReg_EX,
  input memWrite_EX,
  input branch_EX,
  
  input zero_EX,
  input [31:0] aluOut_EX,
  input writeReg_EX,
  input [31:0] writeData_EX,
  input [31:0] pcBranch_EX
);
	
	always @(posedge clk) begin
		// control signals
		regWrite_MEM <= regWrite_EX;
		memToReg_MEM <= memToReg_EX;
		memWrite_MEM <= memWrite_EX;
		branch_MEM <= branch_EX;

		// cpu wires
		zero_MEM <= zero_EX;
		aluOut_MEM <= aluOut_EX;
		writeData_MEM <= writeData_EX;
		writeReg_MEM <= writeReg_EX;
		pcBranch_MEM <= pcBranch_EX;		
	end
endmodule
