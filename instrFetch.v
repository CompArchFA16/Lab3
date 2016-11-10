module InstrFetchUnit
(
input [31:0] instr,
output [5:0] Op,
output [5:0] Funct,
output [4:0] A1,
output [4:0] A2,
output [4:0] RtE,
output [4:0] RdE,
output [15:0] Imm
);

assign Op = instr[31:26]; //syntax??
assign Funct = instr[5:0];
assign A1 = instr[25:21];
assign A2 = instr[20:16];
assign RtE = instr[20:16];
assign RdE = instr[15:11];
assign Imm = instr[15:0];

endmodule
