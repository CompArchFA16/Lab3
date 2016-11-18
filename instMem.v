module instMem
(
    input [31:0]        read_address,
    output [31:0]       instruction
);
    reg [31:0] instructionMem [20:0];

    initial $readmemh("assembly_test.dat", instructionMem);
 	// initial $readmemh("xori_test.dat", instructionMem);
 	// initial begin
 	// 	instructionMem[0] = 32'h381d3ffc;
		// instructionMem[1] = 32'h38080004;
		// instructionMem[2] = 32'h38090001;
		// instructionMem[3] = 32'h01095022;
		// instructionMem[4] = 32'h01095820;
		// instructionMem[5] = 32'h0128602a;
		// instructionMem[6] = 32'h0c000009;
		// instructionMem[7] = 32'h1509000a;
		// instructionMem[8] = 32'h08000014;
		// instructionMem[9] = 32'h03a8e822;
		// instructionMem[10] = 32'h03a8e822;
		// instructionMem[11] = 32'hafa80000;
		// instructionMem[12] = 32'hafa90004;
		// instructionMem[13] = 32'h8fad0000;
		// instructionMem[14] = 32'h8fae0004;
		// instructionMem[15] = 32'h03a8e820;
		// instructionMem[16] = 32'h03a8e820;
		// instructionMem[17] = 32'h03e00008;
		// instructionMem[18] = 32'h01094022;
		// instructionMem[19] = 32'h03e00008;
		// instructionMem[20] = 32'h08000014;
 	// end
 	
    assign instruction = instructionMem[read_address>>2];

endmodule
