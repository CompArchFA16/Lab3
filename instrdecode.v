//instruction decocde stage
`include "instrFetch.v"
`include "regfile.v"

module instrDecode
(
    input clk,
    input instrd,
    input pcplus4d,
    output pcplus4e,
    output seImm,
    output rte,
    output rd3,
    output rd1,
    output rd2
    );

    //fetch instr units
    /*input [31:0] instr,
    output [4:0] Op,
    output [4:0] Funct,
    output [4:0] A1,
    output [4:0] A2,
    output [4:0] RtE,
    output [4:0] RdE,
    output [15:0] Imm */
    InstrFetchUnit fetch();

    //register file
    /*[31:0]	ReadData1,[31:0]	ReadData2,[31:0]	WriteData, [4:0]	ReadRegister1,[4:0]	ReadRegister2,[4:0]	WriteRegister,RegWrite,Clk */
    regfile reggie();
    //sign extension
    //control unit call

endmodule
