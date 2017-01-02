`include "instrFetch.v"

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
