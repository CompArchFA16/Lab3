`include "CPU.v"
module quicktestCPU();

reg clk;
wire [31:0] whatever;

// Generate clock (50MHz)
    initial clk=0;
	always #10 clk=!clk; 

pipelineCPU pCPU(clk, whatever);

initial begin
 $dumpfile("cpu.vcd");
 $dumpvars();


#50000 $finish;

end

endmodule
