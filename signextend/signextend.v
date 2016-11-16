`ifndef __SIGNEXTEND_V__
`define __SIGNEXTEND_V__
module signextend
(
	output[31:0]  signextended, // Sign extended immediate
	input[15:0]   immediate,    // Value to be sign extended
  input         issigned      // High if actually extend the sign. Else, pad it with zeros
);

	assign signextended = issigned? {{16{immediate[15]}}, immediate[15:0]} : {16'h0000, immediate[15:0]};

endmodule
`endif
