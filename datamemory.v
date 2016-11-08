// Source: Lab 2 datamemory.v

module datamemory
(
  input 		        clk,
  output reg [31:0] dataOut,
  input [31:0]      address,
  input             writeEnable,
  input [31:0]      dataIn
);

  reg [31:0] memory [2**31:0];

  always @(posedge clk) begin
      if(writeEnable)
          memory[address] <= dataIn;
      dataOut <= memory[address];
  end
endmodule