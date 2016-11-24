`include "CPU.v"

module piperegtest();
reg wrenable;
reg  clk;
reg [31:0] d1;
reg [31:0] d2;
wire [31:0] q1;
wire [31:0] q2;

initial clk = 0;
always #10 clk = !clk;

registerIF rif(wrenable, clk, d1, d2, q1, q2);

initial begin
wrenable = 1;
d1 = 32'h0000000A;
d2 = 32'h8C111111;
#100
$display("In: %h %h  Out: %h %h", d1, d2, q1, q2);

d1 = 32'h0000000B;
d2 = 32'h8C111000;
#100
$display("In: %h %h  Out: %h %h", d1, d2, q1, q2);
#1000
$finish;
end
endmodule
