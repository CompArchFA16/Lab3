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
  reg [7:0] memory [32767:0];

  assign readData1 = { memory[address1], memory[address1+1], memory[address1+2], memory[address1+3] };
  assign readData2 = { memory[address2], memory[address2+1], memory[address2+2], memory[address2+3] };
  always @(posedge clk) begin
    if(writeEnable) begin
      memory[address2]   <= dataIn[31:24];
      memory[address2+1] <= dataIn[23:16];
      memory[address2+2] <= dataIn[15:8];
      memory[address2+3] <= dataIn[7:0];
    end
  end

  initial $readmemh("asmtest/jay_paul_tj/basic.dat", memory);
  initial $display("%h", memory[8]);
endmodule
