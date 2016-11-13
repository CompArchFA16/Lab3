module instructionmemory
(
  output reg [31:0] dataOut,
  input 			clk,
  input [31:0]      address
);

  reg [31:0] memory [(2**25)-1:0];

  always @(posedge clk) begin
      dataOut <= memory[address];
  end
endmodule
