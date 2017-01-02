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

always @(posedge clk) begin
    case (Op)
        loadWord: begin
            RegWriteD <= 1;
            MemtoRegD <= 1; //we want to write memory to reg!
            MemWriteD <= 0;
            BranchD <=0;
            end
        // assign ALUCtrl <=
     // ALUSrcD <=
     // RegDstD <=
    endcase
end


registerID rid(wrenable, clk, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUCtrlD, ALUSrcD, RegDstD, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUCtrlE, ALUSrcE, RegDstE);
registerEX rex(wrenable, clk, RegWriteE, MemWriteE, MemWriteE, BranchE, RegWriteM, MemWriteM, MemWriteM, BranchM);
registerMEM rMEM(wrenable, clk, RegWriteM, MemtoRegM, RegWriteW, MemtoRegW);

endmodule

module registerID
(
    input       clk,
    input       d1,
    input       d2,
    input       d3,
    input       d4,
    input [2:0] d5,
    input       d6,
    input       d7,
    input [31:0]d8,
    input [31:0]d9,
    input  [4:0]d10,
    input  [4:0]d11,
    input [15:0]d12,
    input [31:0]d13,
    output reg  q1,
    output reg  q2,
    output reg  q3,
    output reg  q4,
    output reg [2:0]  q5,
    output reg  q6,
    output reg   q7,
    output reg [31:0] q8,
    output reg [31:0] q9,
    output reg [4:0] q10,
    output reg [4:0] q11,
    output reg [31:0] q12,
    output reg [31:0] q13
    );

    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
            q5 = d5;
            q6 = d6;
            q7 = d7;
            q8 = d8;
            q9 = d9;
            q10 = d10;
            q11 = d11;
            q12 = d12;
            q13 = d13;
    end
endmodule

module quicktest_RID();
wire RegWriteE;
wire MemtoRegE;
wire BranchE;
wire ALUCtrlE;
wire ALUSrcE;
wire RegDstE;
wire rd1e;
wire rd2e;
wire rtEe;
wire rdEe;
wire seImmee;
wire pcplus4e;
reg RegWriteD;
reg MemtoRegD;
reg MemWriteD;
reg BranchD;
reg ALUCtrlD;
reg ALUSrcD;
reg RegDstD;
reg rd1d;
reg rd2d;
reg rtEd;
reg rdEd;
reg seImmd;


registerID rid(RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUCtrlD, ALUSrcD, RegDstD, rd1d, rd2d, rtEd, rdE , seImmd, pcplus4d, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUCtrlE, ALUSrcE, RegDstE, rd1e, rd2e, rtEe, rdEe, seImme,pcplus4e );

initial begin
RegWriteD = 1;
MemtoRegD = 1;
MemWriteD = 1;
BranchD = 1;
ALUCtrlD = 1;
ALUSrcD = 1;
RegDstD = 1;
rd1d = 1;
rd2d = 1;
rtEd = 1;
rdEd = 1;
seImmd = 1111000011110000;
pcplus4d = 32d'20;
// $display("In: Out: "); 
end

endmodule

module registerEX
(
    input       clk,
    input       d1,
    input       d2,
    input       d3,
    input       d4,
    input       d5,
    input   [31:0]    d6,
    input   [31:0]    d7,
    input   [4:0]    d8,
    input  [31:0]     d9,
    output reg  q1,
    output reg  q2,
    output reg  q3,
    output reg  q4,
    output reg  q5,
    output reg  q6,
    output reg  q7,
    output reg  q8,
    output reg  q9
    );
    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
            q5 = d5;
            q6 = d6;
            q7 = d7;
            q8 = d8;
            q9 = d9;
    end
endmodule

module registerMEM
(
    input       clk,
    input       d1,
    input       d2,
    input [31:0] d3,
    input [31:0] d4,
    input [4:0] d5,
    output reg  q1,
    output reg  q2,
    output reg [31:0] q3,
    output reg [31:0] q4,
    output reg [4:0] q5
    );
    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
            q3 = d3;
            q4 = d4;
            q5 = d5;
    end
endmodule

module registerIF
(
    input       clk,
    input [31:0] d1,
    input [31:0] d2,
    output reg [31:0] q1,
    output reg [31:0] q2
    );
    always @(posedge clk) begin
            q1 = d1;
            q2 = d2;
    end
endmodule
