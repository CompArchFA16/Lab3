module instructionmemory
(
    input                       clk,
    input [31:0]                address,
    output reg[31:0]               instruction,
);
    reg [31:0] memory [2**10-1:0];

    always @(posedge clk) begin
        instruction <= memory[address];
    end


endmodule