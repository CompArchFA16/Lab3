`timescale 1 ns / 1 ps

module slowclk
(
input clk,
output reg slowclk = 0
);


reg [3:0] counter = 0000;

always @(posedge clk) begin
	counter <= counter +1;
	if (counter == 3'b101) begin
		counter <=0;
		slowclk <= !slowclk;
	end

end

endmodule

module quicktestslowclk();
reg clk;
wire slower;
// Generate clock (50MHz)
initial clk=0;
always #10 clk=!clk; 

slowclk slow(clk, slower);

initial begin
 $dumpfile("slow.vcd");
 $dumpvars();

//$display("Output: %b %b", clk, addr);

#50000 $finish;

end

endmodule
