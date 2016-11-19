`include "singlecyclecpu.v"
module quicktestCPU();

reg clk;

// Generate clock (50MHz)
    initial clk=0;
	always #10 clk=!clk; 

singlecycleCPU CPU(clk);

initial begin
 $dumpfile("cpu-nov18.vcd");
 $dumpvars();


#50000 $finish;

end

endmodule
