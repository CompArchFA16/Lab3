`timescale 1ns / 1ps

module signExtend(seIn, seOut);

	input [15:0] seIn;
	output [31:0] seOut;

	assign seOut[15:0] = seIn;

	genvar i;
	generate
		for(i = 16; i < 32; i = i+1) 
    begin: gen1
			assign seOut[i] = seIn[15];	
		end
	endgenerate
endmodule
