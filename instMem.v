module instMem
(
    input [31:0]            read_address,
    output [31:0]       instruction
);
    reg [31:0] instructionMem [31:0];

    //initial $readmemh(“assembly_test.dat”, instructionMem);
    //initial $readmemh(“test.dat”, instructionMem);

    initial begin
        instructionMem[0] <= 32'h2008000a;
    end

    assign instruction = instructionMem[read_address];

endmodule
