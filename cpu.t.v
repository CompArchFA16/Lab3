`include "cpu.v"

module testCpu();

    reg clk;
    CPU cpu0(clk);
    initial clk=0;

    initial begin
        $dumpfile("testing.vcd");
        $dumpvars();
        $display("Testing CPU!");

        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;
        #50 clk=!clk;

        $finish;
        $dumpflush;
    end

    //always #50 clk=!clk;

endmodule
