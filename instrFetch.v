`timescale 1 ns / 1 ps


module InstrFetchUnit
(
input [31:0] instr,
output reg [5:0] Op,
output reg [5:0] Funct,
output reg [4:0] A1,
output reg [4:0] A2,
output reg [4:0] RtE,
output reg [4:0] RdE,
output reg [15:0] Imm
);

always @(instr) begin
Op = instr[31:26];
assign Funct = instr[5:0];
assign A1 = instr[25:21];
assign A2 = instr[20:16];
assign RtE = instr[20:16];
assign RdE = instr[15:11];
assign Imm = instr[15:0];
end
endmodule

module quicktestIFU();
reg [31:0] instr;
wire [5:0] Op;
wire [5:0] Funct;
wire [4:0] A1;
wire [4:0] A2;
wire [4:0] RtE;
wire [4:0] RdE;
wire [15:0] Imm;

InstrFetchUnit iFetch(instr, Op, Funct, A1, A2, RtE, RdE, Imm);

initial begin
// $dumpfile("iFetch.vcd");
// $dumpvars();
instr = 32'b10011001100110011001100110011001;
#10
$display("In: %b Out %b Op %b Funct %b A1 %b A2 %b RtE %b RdE %b Imm", instr, Op, Funct, A1, A2, RtE, RdE, Imm);
#10
instr = 32'b11111111111111111111111111111100;
#10
$display("In: %b Out %b Op %b Funct %b A1 %b A2 %b RtE %b RdE %b Imm", instr, Op, Funct, A1, A2, RtE, RdE, Imm);

end

endmodule
