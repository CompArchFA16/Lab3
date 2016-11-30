// 32 bit Sign Extender

module signextender (
  output reg [31:0] signextendOut,
  input clk,
  input [15:0] imm
);

  always @ ( clk ) begin
      if (imm[15] === 1'b0) begin // If the first bit is zero, add 16 zeros
          signextendOut <= { 16'b0000000000000000, imm };
      end

      else begin // Otherwise add 16 ones
          signextendOut <= { 16'b1111111111111111, imm };
      end
  end

endmodule