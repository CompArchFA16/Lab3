//instruction decocde stage
`include "instrFetch.v"
`include "regfile.v"

module instrDecode
(
    input clk,
    input [31:0] instrd,
    input pcplus4d,
    input [31:0] ResultW,
    input [4:0] writeRegW,
    input RegWriteW,
    output pcplus4e,
    output seImm,
    output [4:0] rte,
    output [4:0] rde,
    output [31:0] rd1,
    output [31:0] rd2
    );

    //fetch instr units
    wire [5:0] op;
    wire [5:0] funct;
    wire [4:0] a1;
    wire [4:0] a2;
    wire [15:0] Imm;

    InstrFetchUnit fetch(instrd, op, funct, a1, a2, rte, rde, Imm);

    //register file
    /*[31:0]ReadData1,[31:0]ReadData2,[31:0]WriteData, [4:0]ReadRegister1,[4:0]	ReadRegister2,[4:0]	WriteRegister,RegWrite,Clk */
    wire [31:0] wd3;
    wire [4:0] a3;
    wire we3;
    regfile reggie(rd1, rd2, ResultW, a1, a2, writeRegW, RegWriteW, clk);

    //sign extension
    assign seImm = {Imm, 16'b0000000000000000}; //Imm is only 16 bits
    //control unit call


endmodule
