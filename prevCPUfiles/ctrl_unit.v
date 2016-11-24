`include "CPU.v"
//Control Unit

module ctrl_unit(
input [5:0] Op,
input [5:0] Funct,
input clk,
output reg RegWriteD,
output reg MemtoRegD,
output reg MemWriteD,
output reg BranchD,
output reg [2:0] ALUCtrlD,
output reg ALUSrcD,
output reg RegDstD
);

// Encodings for Operations
localparam loadWord = 6'h23;
localparam storeWord = 6'h2b;
localparam jump = 6'h2;
localparam jumpLink = 6'h3;
localparam branchNotEq = 5'h5;
localparam xOrI = 6'he;
localparam functionalCode = 6'h0;

// Encodings for Functions
localparam jumpReg = 6'h8;
localparam add = 6'h20;
localparam sub = 6'h22;
localparam slt = 6'h2a;

// ALU things
localparam ADD  3'd0;
localparam SUB  3'd1;
localparam XOR  3'd2;
localparam SLT  3'd3;
localparam AND  3'd4;
localparam NAND 3'd5;
localparam NOR  3'd6;
localparam OR   3'd7;

always @(posedge clk) begin
    case (Op)
        loadWord: begin // read from data memory and write to register file
            RegWriteD <= 1; // Enables writing to register after instruction
            MemtoRegD <= 1; // Selects output to be from Memory so we can write it to reg
            MemWriteD <= 0; // Disables writing to Memory
            BranchD <= 0; // No branching
            ALUControlD <= ADD; // add the address to imm
            ALUSrcD <= 1; // choose the immediate
            RegDstD <= 0; // we want to write to rt
        end
        storeword: begin // read from register file and write to data memory
            RegWriteD <= 0; // we don't want to write
            MemtoRegD <= 0; // doesn't matter (we're not writing to reg file)
            MemWriteD <= 1; // write to datamemory 
            BranchD <= 0; // No branching
            ALUControlD <= ADD; // add the address to imm
            ALUSrcD <= 1; // choose the immediate
            RegDstD <= 0; // doesn't matter (we're not writing to reg file)
        end
        jump: begin // todo
            RegWriteD <= 0; // we don't want to write
            MemtoRegD <= 0; // doesn't matter (we're not writing to reg file)
            MemWriteD <= 1; // write to datamemory 
            BranchD <= 0; // No branching
            ALUControlD <= ADD; // add the address to imm
            ALUSrcD <= 1; // choose the immediate
            RegDstD <= 0; // doesn't matter (we're not writing to reg file)
        end
        jumplink: begin // todo
            RegWriteD <= 0; // we don't want to write
            MemtoRegD <= 0; // doesn't matter (we're not writing to reg file)
            MemWriteD <= 1; // write to datamemory 
            BranchD <= 0; // No branching
            ALUControlD <= ADD; // add the address to imm
            ALUSrcD <= 1; // choose the immediate
            RegDstD <= 0; // doesn't matter (we're not writing to reg file)
        end
        branchNotEq: begin // we test if equal if zero flag high after subtract
            RegWriteD <= 0; // we don't want to write
            MemtoRegD <= 0; // doesn't matter (we're not writing to reg file)
            MemWriteD <= 0; // don't write to datamemory 
            BranchD <= 1; //  branching
            ALUControlD <= SUB; // add the address to imm
            ALUSrcD <= 0; // compare two read ports
            RegDstD <= 0; // doesn't matter (we're not writing to reg file)
        end
        xOrI: begin // rt
            RegWriteD <= 1; // want to write to register file
            MemtoRegD <= 0; // take alu out
            MemWriteD <= 0; // don't write to datamemory 
            BranchD <= 0; // No branching
            ALUControlD <= XOR; // add the address to imm
            ALUSrcD <= 1; // want imm
            RegDstD <= 0; // writing to rt
        end
        functionalCode: begin
            case (Funct)
                jumpReg: begin
                end
                add:begin
                end
                sub: begin
                end
                slt: begin
                end
            endcase
        end
    endcase
end


registerID rid(wrenable, clk, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUCtrlD, ALUSrcD, RegDstD, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUCtrlE, ALUSrcE, RegDstE);
registerEX rex(wrenable, clk, RegWriteE, MemWriteE, MemWriteE, BranchE, RegWriteM, MemWriteM, MemWriteM, BranchM);
registerMEM rMEM(wrenable, clk, RegWriteM, MemtoRegM, RegWriteW, MemtoRegW);

endmodule

