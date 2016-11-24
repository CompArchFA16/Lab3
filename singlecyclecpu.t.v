`include "singlecyclecpu.v"
/*This will generate the waveform, where we can visually check that the CPU is acting as it should. */
module quicktestCPU();

reg clk;

// Generate clock (50MHz)
    initial clk=0;
	always #10 clk=!clk;

singlecycleCPU CPU(clk);

initial begin
 $dumpfile("cpu.vcd");
 $dumpvars();


#50000 $finish;
//the registers are too nested to be able to reference them and check their contents with a dutpassed. 
end

endmodule
