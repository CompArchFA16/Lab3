`define JUMP  6'h2
`define JAL   6'h3
`define LW    6'h23
`define SW    6'h2b
`define BNE   6'h5
`define XORI  6'he
`define RTYPE 6'h0

`define JR    6'h8
`define ADD   6'h20
`define SUB   6'h22
`define SLT   6'h2a


module control
(
    input clk,
    input [5:0] opp,
    input [5:0] func,
    output reg regDst,
    output reg jump,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [2:0] aluOp,
    output reg memWrite,
    output reg aluSrc,
    output reg regWrite,
    output reg jumpReg
);

    always @(posedge clk) begin
        case(opp)
            `JUMP: 
                begin
                    regDst    <= 0;
                    jump      <= 1;
                    branch    <= 0;
                    memRead   <= 0;
                    memtoReg  <= 0;
                    aluOp     <= 0;
                    memWrite  <= 0;
                    aluSrc    <= 0;
                    regWrite  <= 0;
                    jumpReg   <= 0;
                end
            `JAL:
                begin
                    regDst    <= 0;
                    jump      <= 1;
                    branch    <= 0;
                    memRead   <= 0;
                    memtoReg  <= 0;
                    aluOp     <= 0;
                    memWrite  <= 0;
                    aluSrc    <= 0;
                    regWrite  <= 1;
                    jumpReg   <= 0;
                end
            `LW:
                begin
                    regDst    <= 0;
                    jump      <= 0;
                    branch    <= 0;
                    memRead   <= 1;
                    memtoReg  <= 1;
                    aluOp     <= 0;
                    memWrite  <= 0;
                    aluSrc    <= 0;
                    regWrite  <= 1;
                    jumpReg   <= 0;
                end
            `SW:
                begin
                    regDst    <= 0;
                    jump      <= 0;
                    branch    <= 0;
                    memRead   <= 0;
                    memtoReg  <= 0;
                    aluOp     <= 0;
                    memWrite  <= 1;
                    aluSrc    <= 0;
                    regWrite  <= 0;
                    jumpReg   <= 0;
                end
            `BNE:
                begin
                    regDst    <= 0;
                    jump      <= 0;
                    branch    <= 1;
                    memRead   <= 0;
                    memtoReg  <= 0;
                    aluOp     <= 3'd1; //SUB
                    memWrite  <= 0;
                    aluSrc    <= 0;
                    regWrite  <= 0;
                    jumpReg   <= 0;
                end
            `XORI:
                begin
                    regDst    <= 0;
                    jump      <= 0;
                    branch    <= 0;
                    memRead   <= 0;
                    memtoReg  <= 0;
                    aluOp     <= 3'd6; //XOR
                    memWrite  <= 0;
                    aluSrc    <= 1;
                    regWrite  <= 1;
                    jumpReg   <= 0;
                end
            `RTYPE:
                case(func)
                    `JR:
                        begin
                            regDst    <= 1;
                            jump      <= 0;
                            branch    <= 0;
                            memRead   <= 0;
                            memtoReg  <= 0;
                            aluOp     <= 0;
                            memWrite  <= 0;
                            aluSrc    <= 0;
                            regWrite  <= 0;
                            jumpReg   <= 1;
                        end
                    `ADD:
                        begin
                            regDst    <= 1;
                            jump      <= 0;
                            branch    <= 0;
                            memRead   <= 0;
                            memtoReg  <= 0;
                            aluOp     <= 3'd0; //ADD
                            memWrite  <= 0;
                            aluSrc    <= 0;
                            regWrite  <= 1;
                            jumpReg   <= 0;
                        end
                    `SUB:
                        begin
                            regDst    <= 1;
                            jump      <= 0;
                            branch    <= 0;
                            memRead   <= 0;
                            memtoReg  <= 0;
                            aluOp     <= 3'd1; //SUB
                            memWrite  <= 0;
                            aluSrc    <= 0;
                            regWrite  <= 1;
                            jumpReg   <= 0;
                        end
                    `SLT:
                        begin
                            regDst    <= 1;
                            jump      <= 0;
                            branch    <= 0;
                            memRead   <= 0;
                            memtoReg  <= 0;
                            aluOp     <= 3'd7; //SLT
                            memWrite  <= 0;
                            aluSrc    <= 0;
                            regWrite  <= 1;
                            jumpReg   <= 0;
                        end
                endcase
        endcase
    end

endmodule
