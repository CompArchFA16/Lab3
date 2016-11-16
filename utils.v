`ifndef __UTILS_V__
`define __UTILS_V__

`define C_ADD  3'd0
`define C_XOR  3'd1
`define C_SUB  3'd2
`define C_SLT  3'd3
`define C_NAND 3'd4
`define C_AND  3'd5
`define C_NOR  3'd6
`define C_OR   3'd7

//OPCODES
`define O_R 6'h0
`define O_LW 6'h23
`define O_SW 6'h2b
`define O_J 6'h2
`define O_JAL 6'h3
`define O_BNE 6'h5
`define O_XORI 6'b001110

// FUNCTO
`define O_ADD 6'h20
`define O_SUB 6'h22
`define O_SLT 6'h2a
`define O_JR 6'h08

`endif
