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
	        addr <= addr + 4;
	        end
	    end
    end

endmodule

module quickpctest();
reg clk;
reg enable;
wire [31:0] addr;

pc peecee(clk, enable, addr);

initial begin
$display("Output: %b %b", clk, addr);
clk = 1; enable = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
$display("Output: %b %b", clk, addr);
clk = 1; enable = 0; #100
$display("Output: %b %b", clk, addr);
clk = 0; enable = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; enable = 0; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);


end
endmodule
