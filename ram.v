// Source: Lab 2 datamemory.v

module RAM (
  output reg [31:0] dataOut,
  input             clk,
  input      [31:0] address,
  input             writeEnable,
  input      [31:0] dataIn
);

  // For testing purposes, we don't need all that memory.
  reg [31:0] memory [2**25 - 1:0];

  always @(posedge clk) begin
      if(writeEnable) begin
          memory[address] <= dataIn;
      end
      dataOut <= memory[address];
  end
endmodule
