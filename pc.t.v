`include "pc.v"

module quickpctest();
reg clk;
reg enable;
wire [31:0] addr;
reg dutpassed;

pc peecee(clk, enable, addr);

initial begin
dutpassed = 0;
// $display("Output: %b %b", clk, addr);
clk = 1; enable = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 1; enable = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 0; enable = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; enable = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; enable = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);

if (addr == 32'b00000000000000000000000000000100) begin
    dutpassed = 1;
end
$display("DUT passed: %b", dutpassed);

end
endmodule
