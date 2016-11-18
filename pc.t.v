`include "pc.v"
`include "mux.v"

module quickpctest();
reg clk;
wire [31:0] addr;
wire [31:0] pcinput;
wire [31:0] nextaddr;
reg dutpassed;

wire [31:0] seImm;
reg PCsrc ;
wire [31:0] pcbtwnmux;
wire [31:0] jumpAddrforpc;
reg JumpSelect;

pc peecee(clk, pcinput, addr, nextaddr);
mux32to1by1small muxpcbranchinput(nextaddr, (nextaddr + seImm), PCsrc, pcbtwnmux);
mux32to1by1small muxpcjumpinput(pcbtwnmux, jumpAddrforpc, JumpSelect, pcinput);

initial begin
 // $dumpfile("pc.vcd");
 // $dumpvars();
PCsrc = 0; JumpSelect = 0;
dutpassed = 0;
$display("Output: %b %b", clk, addr);
clk = 1;  #100
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

if (addr == 32'b00000000000000000000000000001001) begin
    dutpassed = 1;
end
$display("DUT passed: %b", dutpassed);

end
endmodule
