//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   readData always has the value mem[address]
//   If MemWrite is true, writes writeData to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 32,
    //parameter depth         = 2**addresswidth,
    parameter depth = 10,
    parameter width         = 32
)
(
    input 		                clk,
    output reg [width-1:0]      readData,
    input [addresswidth-1:0]    address,
    input                       MemWrite,
    input                       MemRead,
    input [width-1:0]           writeData
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(MemWrite)
            memory[address] <= writeData;
        if(MemRead)
            readData <= memory[address];
    end

endmodule

