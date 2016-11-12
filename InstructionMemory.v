module instructionmemory
(
    input                       clk,
    input 						writeEnable,
    input [31:0]				dIn,
    input [31:0]                address,
    output [31:0]               dOut

);
    reg [31:0] memory [2**10-1:0];

    always @(posedge clk) begin
    	if(writeEnable)
        	memory[address] <= dIn;
    end
    
    assign dOut = memory[address];
    initial $readmemb("instructions.txt", memory);

endmodule