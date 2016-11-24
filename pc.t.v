`include "pc.v"
`include "mux.v"

/*This tests that PC is implemented correctly, with the barest loop (includes two muxes) DUT will say 1 if passed */

module quickpctest();
reg clk;
reg enable;
wire [31:0] addr;
wire [31:0] pcinput;
wire [31:0] nextaddr;
reg dutpassed;

wire [31:0] seImm;
reg PCsrc ;
wire [31:0] pcbtwnmux;
wire [31:0] jumpAddrforpc;
reg JumpSelect;

pc peecee(clk, enable, pcinput, addr, nextaddr);
mux32to1by1small muxpcbranchinput(nextaddr, (nextaddr + seImm), PCsrc, pcbtwnmux);
mux32to1by1small muxpcjumpinput(pcbtwnmux, jumpAddrforpc, JumpSelect, pcinput);

initial begin
 // $dumpfile("pc.vcd");
 // $dumpvars();
enable = 1;
PCsrc = 0; JumpSelect = 0;
dutpassed = 0;
// $display("        clk, addr");
// $display("Output: %b %b", clk, addr);
clk = 1;  #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);
clk = 1; #100
// $display("Output: %b %b", clk, addr);
clk = 0; #100
// $display("Output: %b %b", clk, addr);

if (addr == 32'b00000000000000000000000000001110) begin
    dutpassed = 1;
end
$display("Program counter DUT passed: %b", dutpassed);

end
endmodule
