


module InstrFetchUnit
(
input [31:0] instr,
output reg [5:0] Op,
output reg [5:0] Funct,
output reg [4:0] A1,
output reg [4:0] A2,
output reg [4:0] RtE,
output reg [4:0] RdE,
output reg [15:0] Imm,
output reg [25:0] Jumpaddr
);

always @(instr) begin
Op = instr[31:26];
assign Funct = instr[5:0];
assign A1 = instr[25:21];
assign A2 = instr[20:16];
assign RtE = instr[20:16];
assign RdE = instr[15:11];
assign Imm = instr[15:0];
assign Jumpaddr = instr[25:0];
end
endmodule
