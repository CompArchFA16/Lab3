`include "cpu.v"

module testCpu();

    reg clk;
    CPU cpu0(clk);
    initial clk=0;

    always #50 clk=!clk;

    initial begin
        $dumpfile("testing.vcd");
        $dumpvars();
        $display("Testing CPU!");

        #100000

        $finish;
        $dumpflush;
    end

    //always #50 clk=!clk;

endmodule
