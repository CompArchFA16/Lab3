//------------------------------------------------------------------------
// PC
//------------------------------------------------------------------------
//`include "adder.v"
module pc
(
input               clk, 
input               enable, // from FSM to say whether or not to increment
output reg [31:0]   addr = 32'b00000000000000000000000000000000
);

    //reg [31:0] pcreg;
    //wire overflow;
    //wire carryout;
    //reg b = 32'b00000000000000000000000000000100;
    //wire toadd;
    //and andgate(toadd, b, enable);
    //Full32Add adder(overflow, carryout, addr, pcreg, toadd, 0,0); //ADD MODULE

    always @(posedge clk) begin
        if (enable)
            addr <= addr + 4;
    end
    
endmodule