//------------------------------------------------------------------------
// PC
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
module pc
(
input               clk, //this is the slower clock
input enable,
input [31:0]		pcinput,
output reg [31:0]   addr = 32'b00000000000000000000000000000000,
output reg [31:0]   nextaddr = 32'b00000000000000000000000000000000
);

    always @(posedge clk) begin
	if (enable) begin
	        addr <= nextaddr;
	end
    end
	always @(negedge clk) begin
	if (enable) begin
	        nextaddr <= pcinput+1;
	end
    end

endmodule
