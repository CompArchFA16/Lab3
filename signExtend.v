module signExtend(seIn, seOut);

	input [15:0] seIn;
	output [31:0] seOut;
	
	assign out[15:0] = imm;

	genvar i;
	generate
		for(i = 16; i < 32; i = i+1) 
    begin: gen1
			assign out[i] = imm[15];	
		end
	endgenerate
endmodule
