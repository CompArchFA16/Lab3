`include "DataMemory.v"
module testDataMemory();
	reg clk;
	reg writeEnable;
	reg [31:0] dIn;
	reg [31:0] address;
	wire [31:0] dOut;
	reg pass;
	
	datamemory DUT(clk, writeEnable, dIn, address, dOut);
	
	initial clk = 0;
	always #10 clk = !clk;

	initial begin
		$dumpfile("datamemory.vcd");
		$dumpvars(0,testDataMemory);
		pass = 1;

		address = 31'b0;
		dIn = 31'd2**10;
		writeEnable = 1;
		#50
		if(dOut != dIn) begin
			pass = 0;
			$display("TestFail: %b", dOut);
		end

		writeEnable = 0;
		address = 31'b0;
		dIn = 31'b1;
		#50
		if(dOut != 31'd2**10) begin
			pass = 0;
			$display("TestFail: %b", dOut);
		end

		address = 31'd2**32-1;
		dIn = 31'd2**32-1;
		#50
		if(dOut != dIn) begin
			pass = 0;
			$display("TestFail: %b", dOut);
		end

	end

endmodule
