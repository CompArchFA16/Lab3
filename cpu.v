`include "memory.v"
`include "instructionDecoder.v"
`include "control.v"
`include "regfile.v"
`include "alu.v"

module CPU
(
    input clk
);

    // PC
    reg [31:0] pc;
    initial pc = 0;
    wire [31:0] pcNext;
    assign pcNext = pc+4;

    // Instr. Memory Wires
    wire [31:0] instrAddr;
    wire [31:0] instrData;
    instrMemory instrMemory0(clk, 1'b0, {2'b0, pc[31:2]}, 32'b0, instrData);

    // Instruction Decoder
    wire [5:0] Opp, Funct;
    wire [4:0] Rs, Rt, Rd, Shamt;
    wire [31:0] Imm;
    wire [25:0] Jadd;
    instructionDecoder instrDec0 (instrData, Opp, Rs, Rt, Rd, Shamt, Funct, Imm, Jadd);

    // Control Wires
    wire regDest;
    wire jump;
    wire branch;
    wire memRead;
    wire memtoReg;
    wire [2:0] aluOp;
    wire memWrite;
    wire aluSrc;
    wire regWrite;
    wire jumpReg;
    control control0(Opp, Funct, regDest, jump, branch, memRead, memtoReg, aluOp, memWrite, aluSrc, regWrite, jumpReg);

    // Regfile wires
    wire [31:0] Da;
    wire [31:0] Db;
    wire [31:0] Dw;
    wire [4:0] Aw; 
    wire [4:0] Ab; 
    wire [4:0] Aa;
    regfile regfile0(Da, Db, Dw, Aa, Ab, Aw, regWrite, clk);

    assign Aw = (regDest == 0 ? Rt : Rd);
    assign Aa = Rs;
    assign Ab = Rt;

    // ALU Wires
    wire [31:0] aluInput0;
    wire [31:0] aluInput1;
    wire [31:0] aluOutput;
    wire zero;
    wire overflow;
    ALU alu0 (aluOutput, zero, overflow, aluInput0, aluInput1, aluOp);

    assign aluInput0 = Da;
    assign aluInput1 = (aluSrc == 0 ? Db : Imm);

    // Data Memory Wires
    wire [31:0] dataAddr;
    wire [31:0] dataOut;
    wire [31:0] dataWrite;
    dataMemory dataMemory0(clk, memWrite, dataAddr, dataWrite, dataOut);

    assign dataAddr = aluOutput;
    assign Dw = (memtoReg == 0 ? aluOutput : dataOut);
    assign dataWrite = Db;

    // Jumping Routines
    wire [31:0] jumpAddress;
    assign jumpAddress = { pcNext[31:28], (Jadd << 2)};

    wire [31:0] branchImmediate;
    assign branchImmediate = pcNext + (Imm << 2);
    
    wire [31:0] branchDestination;
    assign branchDestination = ( (zero & branch) == 0 ? pcNext: branchImmediate);

    wire [31:0] jumpDest;
    assign jumpDest = ( jump == 0 ? branchDestination : jumpAddress);

    wire [31:0] actualPCNext;
    assign actualPCNext = (jumpReg == 0 ? jumpDest : Da);

    always @(posedge clk) begin
        pc <= actualPCNext;
    end

endmodule
