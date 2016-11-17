module instMem
(
    input [31:0]        read_address,
    output [31:0]       instruction
);
    reg [31:0] instructionMem [1:0];

    // initial $readmemh("assembly_test.dat", instructionMem);
 	initial $readmemh("xori_test.dat", instructionMem);
    assign instruction = instructionMem[read_address];

endmodule
