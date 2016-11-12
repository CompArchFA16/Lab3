`ifndef __MUX_V__
`define __MUX_V__

module mux
#(parameter n=1, parameter m=2**n)
(
	output out,
	input [m-1:0] data,
	input [n-1:0] sel
);

assign out = data[sel];

endmodule

`endif
