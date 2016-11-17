`include "cpu.v"

module cputest();

	reg clk;

	cpu test(.clk(clk));

	initial clk=1;
    always #100 clk=!clk; 

	initial begin
		$dumpfile("cpu.vcd");
	    $dumpvars();
	    #300
	    $finish;
    end

endmodule
