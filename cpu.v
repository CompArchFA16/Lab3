`include "memory.v"
`include "RegfileDir/regfile.v"
`include "alu.v"

module CPU
(
    input clk;
);

    reg [31:0] pc;
    initial pc = 0;

    // Instr. Memory Wires
    wire [31:0] instrAddr;
    wire [31:0] instrData;

    // Regfile wires
    wire [31:0] Da;
    wire [31:0] Db;
    wire [31:0] Dw;
    wire [31:0] Aw; 
    wire [31:0] Ab; 
    wire [31:0] Aa;
    wire WrEn_regFile;

    // ALU Wires
    wire [31:0] aluInput0;
    wire [31:0] aluInput1;

    // Data Memory Wires
    wire [31:0] dataAddr;
    wire [31:0] dataOut;
    wire [31:0] dataWrite;
    wire WrEn_dataMem;

    // Initialize and wire subcomponents
    regfile regfile0(Da, Db, Dw, Aa, Ab, Aw, WrEn_regFile, clk);

    memory instrMemory0(clk, 0, pc, 0, instrData);
    memory dataMemory0(clk, WrEn_dataMem, dataAddr, dataWrite, dataOut);


    // Increase PC
    always @(posedge clk) begin
        pc <= pc+4;
    end


endmodule
