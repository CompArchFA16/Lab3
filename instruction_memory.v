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
		$readmemh("asmtest/addsub.dat", memory);
	end

    assign dOut = memory[address];

endmodule
`endif
