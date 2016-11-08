`include "opcodes.v"
`include "exmem_reg.v"
`include "datamemory.v"
`include "multiplexer_2_input.v"

`define AND and #330

module CPU (
  output [31:0] pc,
  input         clk,
  input  [31:0] instruction
);
	
	// exmem wires
	wire regWriteM;
	wire memToRegM;
	wire memWriteM;
	wire branchM;

	wire zeroM;
	wire aluOutM;
	wire writeDataM;
	wire writeRegM;
	wire pcBranchM;

	wire pcSource;

	exmem_reg exmem_reg(
		.clk(clk),
		.regWriteM(regWriteM),
		.memToRegM(memToRegM),
		.memWriteM(memWriteM),
		.branchM(branchM),
		.regWriteE(regWriteE),
		.memToReg(E),
		.branchE(branchE),
		.zeroM(zeroM),
		.aluOutM(aluOutM),
		.writeDataM(writeDataM),
		.writeReg(M),
		.pcBranchM(pcBranchM),
		.zeroE(zeroE),
		.aluOutE(aluOutE),
		.writeRegE(writeRegE),
		.writeDataE(writeDataE),
		.pcBranchE(pcBranchE)
	);

	`AND (pcSource, branchM, zeroM);

	// data memory wires
	wire readDataM;

	datamemory datamemory(
		.clk(clk),
		.dataOut(readDataM),
		.address(aluOutM),
		.writeEnable(memWriteM),
		.dataIn(writeDataM)
	);

	// memwb wires
	wire regWriteW;
  	wire memToRegW;

	wire aluOutW;
  	wire readDataW;
  	wire writeRegW;

	memwb_reg memwb_reg(
		.regWriteW(regWriteW),
		.memToRegW(memToRegW),
		.regWriteM(regWriteM),
		.memToRegM(memToRegM),
		.aluOutW(aluOutW),
		.readDataW(readDataW),
		.writeRegW(writeRegW),
		.aluOutM(aluOutM),
		.readDataM(readDataM),
		.writeRegM(writeRegM)
	);

	wire resultW;

	Multiplexer2Input mux(
		.out(resultW),
		.address(memToRegW),
		.inputs({aluOutW, readDataW})
	);

endmodule