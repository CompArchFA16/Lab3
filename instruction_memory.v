`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__
module instructionMemory
(
    input                       clk,
    input 						writeEnable,
    input [31:0]                address,
    output [31:0]               dOut

);
    reg [31:0] memory [2**10-1:0];

	initial begin
		$readmemh("asmtest/shy/lab3test.dat", memory);
	end

    assign dOut = memory[address/4];

endmodule
`endif
