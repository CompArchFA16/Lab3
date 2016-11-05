module fakeDataMemory (
	clk, 
	dataMemOut,
 	dataMemAddr,
 	dataMemWR,
 	dataMemIn
);

	initial begin
		
		if (dataMemAddr === 32'd7) begin
			dataMemOut = 32'd3;
		end

	end

endmodule