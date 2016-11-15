//------------------------------------------------------------------------
// jump_shifter
// Takes input immediate (Whatever many bits)
// sign extends the immediate to the right with the msb
// and outputs 32 bit
//------------------------------------------------------------------------


module jump_shifter
(
    output [31:0]                 extended_imm
    input  [25:0]                 immediate,
    input  [3:0]				  pc_bits,
);

   assign extended_imm = { pc_bits, immediate, {2'b00}};

endmodule