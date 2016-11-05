`include "bne.v"

module testBne();

	reg programCounter;
	reg rs;
	reg rt;
	wire res;
	reg imm;


	bne dut(.programCounter(programCounter),
			.rs(rs),
			.rt(rt),
			.res(res),
			.imm(imm));


	initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

	reg dutPassed;

	initial begin
		$dumpfile("bne.vcd");
		$dumpvars;

		dutPassed = 1;

		if (rs!==rt && programCounter !== res) begin
			dutPassed = 0;
			$display("programCounter: %d", programCounter);
			$display("res: %d", res);

		end
		
		$display("Did all tests pass? %b", dutPassed);
        $finish;

	end