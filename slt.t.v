`include "slt.v"

module testSlt();

	reg rs;
	reg rt;
	reg rd;
	wire res;



	add dut (.rs(rs),
			 .rt(rt),
			 .rd(rd),
			 .res(res));

	initial clk=0;
	always #10 clk=!clk; //50MHz clock

	reg dutPassed;

	initial begin
		$dumpfile("add.vcd");
		$dumpvars;

		dutPassed = 1;

		if(rs < rt && rd !== 1) begin //rd? res?
			dutPassed = 0;
		end

		if (res !== rd) begin
			dutPassed = 0;
			
		end

		$display("Did all tests pass? %b", dutPassed);
        $finish;
	end








