`include "cpu.v"

module testCpu();

    reg clk;
    CPU cpu0(clk)

    initial begin

    end

    initial clk=0;
    always #50 clk=!clk;

endmodule
