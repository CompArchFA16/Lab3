//control unit
//Tom Lisa Anisha so hawt
`timescale 1 ns / 1 ps


module singlecyclectrl
(
input [5:0] Op,
input [5:0] Funct,
input clk,
output reg PCenable = 1,
output reg RegWrite,
output reg ALUSrc,
output reg MemWrite,
output reg [2:0] ALUOp,
output reg MemtoReg,
//output reg MemRead,
output reg Branch,
output reg Jump,
output reg RegDst,
output reg JALselect,
output reg selectRegorJump,
output selstart
);

// Encodings for Operations
localparam loadWord = 6'h23;
localparam storeWord = 6'h2b;
localparam jump = 6'h2;
localparam jumpLink = 6'h3;
localparam branchNotEq = 5'h5;
localparam xOrI = 6'he;
localparam functionalCode = 6'h0;
localparam done = 6'h3f;

// Encodings for Functions
localparam jumpReg = 6'h8;
localparam add = 6'h20;
localparam sub = 6'h22;
localparam slt = 6'h2a;

// ALU things
localparam ADD = 3'd0;
localparam SUB = 3'd1;
localparam XOR = 3'd2;
localparam SLT = 3'd3;
localparam AND = 3'd4;
localparam NAND = 3'd5;
localparam NOR = 3'd6;
localparam OR =  3'd7;

//TO DO: have it set PC to 0 with putting selstart high once at beginning. 
//assign selstart = 32'b00000000000000000000000000000000;
//assign PCenable = 1;

always @(posedge clk) begin
    case (Op)
	done: begin // read from data memory and write to register file
	    $finish;
	    PCenable <= 0; // stop pc
            RegDst <= 0; // doesnt matter
            Branch <= 0;
            Jump <= 0;
            MemtoReg <= 0; // doesnt matter
            ALUOp <= ADD; // doesnt matter
            MemWrite <= 0; // not writing to data mem
            ALUSrc <= 0; // doesnt matter
            RegWrite <= 0; // dont write
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        loadWord: begin // read from data memory and write to register file
            RegDst <= 0; // want to write to rt
            Branch <= 0;
            Jump <= 0;
            MemtoReg <= 1; // choose read data output
            ALUOp <= ADD; // R[rs] +seimm
            MemWrite <= 0; // not writing to data mem
            ALUSrc <= 1; // want se imm
            RegWrite <= 1; // we're writing to register
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        storeWord: begin // read from register file and write to data memory
            RegDst <= 0; // doesnt matter
            Branch <= 0;
            Jump <= 0;
            MemtoReg <= 0; // doesnt matter
            ALUOp <= ADD; // R[rs] +seimm
            MemWrite <= 1; // writing to data mem
            ALUSrc <= 1; // want se imm
            RegWrite <= 0; // dont write
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        jump: begin
            RegDst <= 0; // doesnt matter
            Branch <= 0;
            Jump <= 1;
            MemtoReg <= 0; // doesnt matter
            ALUOp <= ADD; // doesnt matter
            MemWrite <= 0; // doesnt matter
            ALUSrc <= 0; // doesnt matter
            RegWrite <= 0; // doesnt matter
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // jump address
        end
        jumpLink: begin // todo: have a pc+8 to write data, perhaps with mux on write data
            RegDst <= 0; // doesnt matter
            Branch <= 0;
            Jump <= 1;
            MemtoReg <= 0; // doesnt matter
            ALUOp <= ADD; // doesnt matter
            MemWrite <= 0; // doesnt matter
            ALUSrc <= 0; // doesnt matter
            RegWrite <= 0; // doesnt matter
            JALselect <= 1; // write to reg 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        branchNotEq: begin // we test if equal if zero flag high after subtract
            RegDst <= 0; // doesnt matter
            Branch <= 1;
            Jump <= 0;
            MemtoReg <= 0; // doesnt matter
            ALUOp <= SUB; // doesnt matter
            MemWrite <= 0; // doesnt matter
            ALUSrc <= 0; // read data 2
            RegWrite <= 0; // doesnt matter
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        xOrI: begin // rt
            RegDst <= 0; // choose rt
            Branch <= 0;
            Jump <= 0;
            MemtoReg <= 0; // alu out
            ALUOp <= XOR; // matters
            MemWrite <= 0; // doesnt matter
            ALUSrc <= 1; // immediate
            RegWrite <= 1; // writing to reg rt
            JALselect <= 0; // not 31
            selectRegorJump <= 0; // doesn't matter, not jumping
        end
        functionalCode: begin
            case (Funct)
                jumpReg: begin
                    RegDst <= 0; // doesnt matter
                    Branch <= 0;
                    Jump <= 1;
                    MemtoReg <= 0; // doesnt matter
                    ALUOp <= ADD; // doesnt matter
                    MemWrite <= 0; // doesnt matter
                    ALUSrc <= 0; // doesnt matter
                    RegWrite <= 1; // writing to reg rt
                    JALselect <= 0; // not 31
                    selectRegorJump <= 1; // select the R[rs] to write to pc
                end
                add:begin
                    RegDst <= 1; // write to rd
                    Branch <= 0;
                    Jump <= 0;
                    MemtoReg <= 0; // want alu
                    ALUOp <= ADD; // doesnt matter
                    MemWrite <= 0; // doesnt matter
                    ALUSrc <= 0; // read data 2
                    RegWrite <= 1; // writing to reg rd
                    JALselect <= 0; // not 31
                    selectRegorJump <= 0; // select the R[rs] to write to pc
                end
                sub: begin
                    RegDst <= 1; // write to rd
                    Branch <= 0;
                    Jump <= 0;
                    MemtoReg <= 0; // want alu
                    ALUOp <= SUB; // doesnt matter
                    MemWrite <= 0; // doesnt matter
                    ALUSrc <= 0; // read data 2
                    RegWrite <= 1; // writing to reg rd
                    JALselect <= 0; // not 31
                    selectRegorJump <= 0; // select the R[rs] to write to pc
                end
                slt: begin
                    RegDst <= 1; // write to rd
                    Branch <= 0;
                    Jump <= 0;
                    MemtoReg <= 0; // want alu
                    ALUOp <= SLT; // doesnt matter
                    MemWrite <= 0; // doesnt matter
                    ALUSrc <= 0; // read data 2
                    RegWrite <= 1; // writing to reg rd
                    JALselect <= 0; // not 31
                    selectRegorJump <= 0; // select the R[rs] to write to pc
                end
            endcase
        end
    endcase
end


endmodule
