module instMem
(
    input                   clk,
    input [31: 0]           PC,
    output reg [31:0]       instruction
);
    reg [31:0] instructionMem [31:0];

    //initial $readmemh(“file.dat”, instructionMem);

    initial begin
    	instructionMem[0] <= 32'h2008000a;
        instructionMem[4] <= 32'h2008000b;
        instructionMem[8] <= 32'h2008000c;
    end

    always @(posedge clk) begin
        instruction <= instructionMem[PC];
    end

endmodule
