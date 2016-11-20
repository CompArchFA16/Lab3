`ifndef __MUX_T_V__
`define __MUX_T_V__

`include "mux.v"

module test_mux();

reg [1:0] a;
reg [1:0] b;
reg [1:0] c;
reg [1:0] d;
reg [1:0] sel;

wire out_11;
mux #(.WIDTH(1), .CHANNELS(2)) m11(out_11, {b[0],a[0]}, sel[0]);

wire out_1111;
mux #(.WIDTH(1), .CHANNELS(4)) m1111(out_1111, {d[0], c[0], b[0], a[0]}, sel);

wire [1:0] out_22;
mux #(.WIDTH(2), .CHANNELS(2)) m22(out_22, {b, a}, sel[1]);

wire [1:0] out_2222;
mux #(.WIDTH(2), .CHANNELS(4)) m2222(out_2222, {d,c,b,a}, ~sel);

initial begin
	a = 2'b01;
	b = 2'b11;
	c = 2'b00;
	d = 2'b10;

	sel = 2'b10;

	#500;
	$display("MUX BASIC TEST : %s", ((out_11 == a[0])? "PASS" : "FAIL"));

	$display("MUX MULTI-CHANNEL TEST : %s", ((out_1111 == c[0])? "PASS" : "FAIL"));

	$display("MUX MULTI-BUS TEST : %s", ((out_22 == b)? "PASS" : "FAIL"));

	$display("MUX MULTI_BUS MULTI-CHANNEL TEST : %s", ((out_2222 == b)? "PASS" : "FAIL"));

	// choose 1-1
	// choose 1-1-1-1
	// choose 2-2
	// choose 2-2-2-2
end

endmodule
`endif
