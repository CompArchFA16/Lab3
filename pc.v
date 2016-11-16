//------------------------------------------------------------------------
// PC
//------------------------------------------------------------------------
//`include "adder.v"

`timescale 1 ns / 1 ps
module pc
(
input               clk,
input				enable,
output reg [31:0]   addr = 32'b00000000000000000000000000000000
);

    always @(posedge clk) begin
    	if (enable) begin
	        if (addr == 32'b11111111111111111111111111111100) begin
	        end
	        else begin
	        addr <= addr + 1;
	        end
	    end
    end

endmodule
