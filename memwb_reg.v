module memwb_reg (

  input clk,

  // control signals
  output reg regWriteW,
  output reg memToRegW,

  input regWriteM,
  input memToRegM,
   
  // cpu wires
  output reg aluOutW,
  output reg readDataW,
  output reg writeRegW,

  input aluOutM,
  input readDataM,
  input writeRegM
);
	
	always @(posedge clk) begin
		// control signals
		regWriteW <= regWriteM;
    memToRegW <= memToRegM;

		// cpu wires
		aluOutW <= aluOutM;
    readDataW <= readDataM;
    writeRegW <= writeRegM;	
	end
endmodule
