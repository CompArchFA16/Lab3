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
