//------------------------------------------------------------------------
// Sign Extender
// Takes input immediate (Whatever many bits)
// sign extends the immediate to the right with the msb
// and outputs 32 bit
//------------------------------------------------------------------------

module signextend
(
    input  [15:0]                 immediate,
    output [31:0]                 extended_imm
);

   assign extended_imm = { {16{immediate[15]}}, immediate };

endmodule
