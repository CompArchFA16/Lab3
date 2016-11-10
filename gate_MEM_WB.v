module gate_MEM_WB (

  input clk,

  // control signals
  output reg regWrite_WB,
  output reg memToReg_WB,

  input regWrite_MEM,
  input memToReg_MEM,
   
  // cpu wires
  output reg aluOut_WB,
  output reg readData_WB,
  output reg writeReg_WB,

  input [31:0] aluOut_MEM,
  input [31:0] readData_MEM,
  input writeReg_MEM
);
	
  always @(posedge clk) begin
    // control signals
    regWrite_WB <= regWrite_MEM;
    memToReg_WB <= memToReg_MEM;

    // cpu wires
    aluOut_WB <= aluOut_MEM;
    readData_WB <= readData_MEM;
    writeReg_WB <= writeReg_MEM;	
  end
endmodule
