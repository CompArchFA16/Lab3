module gate_MEM_WB (

  output reg regWrite_WB,
  output reg memToReg_WB,

  output reg [31:0] aluOut_WB,
  output reg [31:0] readData_WB,
  output reg [4:0]  writeReg_WB,

  input clk,

  input regWrite_MEM,
  input memToReg_MEM,

  input [31:0] aluOut_MEM,
  input [31:0] readData_MEM,
  input [4:0]  writeReg_MEM
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
