//Tom Lisa Anisha so hawt
 `timescale 1 ns / 1 ps
`include "pc.v"
`include "memory.v"
`include "ctrl_unit.v"

module pipelineCPU
(
    input clk,
    output whatever
);

pc programcounter(clk, enable, PCaddr);
Instr_memory iMem(clk, regWE, IMaddr, DataIn, DataOut);
registerIF rif(wrenable, clk, dataout, PCaddr);
//insert rest here

endmodule
