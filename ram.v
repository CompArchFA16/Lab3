module RAM (
  output [31:0] readData1,
  output [31:0] readData2,
  input         clk,
  input  [31:0] address1,
  input  [31:0] address2,
  input  [31:0] dataIn,
  input         writeEnable
);

  // For testing purposes, we don't need all that memory.
  reg [31:0] memory [32767:0];

  assign readData1 = memory[address1 / 4];
  assign readData2 = memory[address2 / 4];
  always @(posedge clk) begin
    if(writeEnable) begin
      memory[address2 / 4] <= dataIn;
    end
  end

  initial $readmemh("asmtest/jay_paul_tj/basic.dat", memory);
endmodule
