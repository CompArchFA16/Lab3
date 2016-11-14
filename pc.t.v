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
