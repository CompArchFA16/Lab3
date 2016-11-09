//Control Unit

module ctrl_unit(
input wrenable,
input clk,
input [5:0] Op,
input [5:0] Funct,
output reg RegWriteD,
output reg MemtoRegD,
output reg MemWriteD,
output reg BranchD,
output reg [4:0] ALUCtrlD,
output reg ALUSrcD,
output reg RegDstD,
output RegWriteE,
output MemtoRegE,
output MemWriteE,
output BranchE,
output [4:0] ALUCtrlE,
output ALUSrcE,
output RegDstE,
output RegWriteM,
output MemtoRegM,
output MemWriteM,
output BranchM,
output RegWriteW,
output MemtoRegW
);

always @(posedge clk) begin
if (Op == 6'h23) begin //LOAD WORD
RegWriteD <= 1;
MemtoRegD <= 1; //we want to write memory to reg!
MemWriteD <= 0;
BranchD <=0;
// assign ALUCtrl <=
// ALUSrcD <=
// RegDstD <=
end

// if (Op == 5'h2b) begin //STORE WORD
//
// end
//
// if (Op == 5'h02) begin //JUMP
//
// end
//
// if ((Op == 5'h00) && Funct == 5'h08) begin //JUMP TO REGISTER
//
// end
//
// if (Op == 5'h03) begin //JUMP AND LINK
//
// end
//
// if (Op == 5'h05) begin //BRANCH NOT EQUAL
//
// end
//
// if (Op == 5'h0e) begin //XORI
//
// end
//
// if ((Op == 5'h00) && (Funct == 5'h20)) begin //ADD
//
// end
//
// if ((Op == 5'h00) && (Funct == 5'h22)) begin //SUB
//
// end
//
// if ((Op == 5'h00) && (Funct == 5'h2a)) begin //SLT
//
// end


end


registerID rid(wrenable, clk, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUCtrlD, ALUSrcD, RegDstD, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUCtrlE, ALUSrcE, RegDstE);
registerEX rex(wrenable, clk, RegWriteE, MemWriteE, MemWriteE, BranchE, RegWriteM, MemWriteM, MemWriteM, BranchM);
registerMEM rMEM(wrenable, clk, RegWriteM, MemtoRegM, RegWriteW, MemtoRegW);

endmodule

module registerID
(
    input       wrenable,
    input       clk,
    input       d1,
    input       d2,
    input       d3,
    input       d4,
    input [4:0] d5,
    input       d6,
    input       d7,
    output reg  q1,
    output reg  q2,
    output reg  q3,
    output reg  q4,
    output reg [4:0]  q5,
    output reg  q6,
    output reg   q7
    );

    always @(posedge clk) begin
        if (wrenable) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
            q5 = d5;
            q6 = d6;
            q7 = d7;
        end
    end
endmodule

module registerEX
(
    input       wrenable,
    input       clk,
    input       d1,
    input       d2,
    input       d3,
    input       d4,
    output reg  q1,
    output reg  q2,
    output reg  q3,
    output reg  q4
    );
    always @(posedge clk) begin
        if (wrenable) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
        end
    end
endmodule

module registerMEM
(
    input       wrenable,
    input       clk,
    input       d1,
    input       d2,
    output reg  q1,
    output reg  q2
    );
    always @(posedge clk) begin
        if (wrenable) begin
            q1 = d1;
            q2 = d2;
        end
    end
endmodule

module registerIF
(
    input       wrenable,
    input       clk,
    input [31:0] d1,
    input [31:0] d2,
    output reg [31:0] q1,
    output reg [31:0] q2
    );
    always @(posedge clk) begin
        if (wrenable) begin
            q1 = d1;
            q2 = d2;
        end
    end
endmodule
