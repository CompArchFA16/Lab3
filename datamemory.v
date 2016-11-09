//------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   readData always has the value mem[address]
//   If MemWrite is true, writes writeData to mem[address]
//------------------------------------------------------------------------

module datamemory
#(
    parameter addresswidth  = 7,
    parameter depth         = 2**addresswidth,
    parameter width         = 8
)
(
    input 		                clk,
    output reg [width-1:0]      readData,
    input [addresswidth-1:0]    address,
    input                       MemWrite,
    input [width-1:0]           writeData
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(MemWrite)
            memory[address] <= writeData;
        readData <= memory[address];
    end

endmodule
