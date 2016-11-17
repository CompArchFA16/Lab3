`include "memory.v"

module testMemory();

    reg clk;
    initial clk=0;
    reg regWE;
    reg[9:0] addr;
    reg[31:0] dataIn;
    wire[31:0] dataOut;
     
    instrMemory dataMem0(clk, regWE, addr, dataIn, dataOut);

    initial begin
        addr = 10'd0;

        #50 clk=!clk;
        $display("Output: %x", dataOut);

        addr = 10'd1;
        #50 clk=!clk;
        $display("Output: %x", dataOut);
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
    end

endmodule
