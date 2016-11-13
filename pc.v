//------------------------------------------------------------------------
// PC
//------------------------------------------------------------------------
//`include "adder.v"

`timescale 1 ns / 1 ps
module pc
(
input               clk,
output reg [31:0]   addr = 32'b00000000000000000000000000000000
);

    always @(posedge clk) begin
        addr <= addr + 4;
    end

endmodule

module quickpctest();
reg clk;
wire addr;

initial begin
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);
clk = 1; #100
$display("Output: %b %b", clk, addr);
clk = 0; #100
$display("Output: %b %b", clk, addr);

end
endmodule
