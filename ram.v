module RAM (
  output [31:0] dataOut,
  input         clk,
  input  [31:0] address,
  input         writeEnable,
  input  [31:0] dataIn
);

  // For testing purposes, we don't need all that memory.
  reg [31:0] memory [(2**10)- 1:0];

  assign dataOut = memory[address];
  always @(posedge clk) begin
    if(writeEnable) begin
      memory[address] <= dataIn;
    end
  end

  initial $readmemh("file.dat", memory);
endmodule
