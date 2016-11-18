//------------------------------------------------------------------------
// PC
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
module pc
(
input               clk, //this is the slower clock
input [31:0]		pcinput,
output reg [31:0]   addr = 32'b00000000000000000000000000000000,
output reg [31:0]   nextaddr = 32'b00000000000000000000000000000000
);

    always @(posedge clk) begin
	        if (addr == 32'b00000000000000000000000000001010) begin
                addr = 32'b00000000000000000000000000000000;
	        end
	        else begin
	        addr <= pcinput;
	        nextaddr <= pcinput+1;
	        end
    end

endmodule
