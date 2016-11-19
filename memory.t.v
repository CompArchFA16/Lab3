`include "memory.v"

module testMemory();

    reg clk;
    initial clk=0;
    reg regWE;
    initial regWE=0;
    reg[9:0] addr;
    reg[31:0] dataIn;
    wire[31:0] dataOut;
     
    dataMemory dataMem0(clk, regWE, addr, dataIn, dataOut);

    initial begin
        addr = 10'd0;

        #50 clk=!clk;
        #50 clk=!clk;
        $display("Output: %x", dataOut);

        addr = 10'd1;
        #50 clk=!clk;
        #50 clk=!clk;
        $display("Output: %x", dataOut);


        addr = 10'd3;
        dataIn = 32'd43;
        regWE=1;
        #50 clk=!clk;
        #50 clk=!clk;
        $display("Output: %x", dataOut);

        addr = 10'd3;
        regWE=0;
        #50 clk=!clk;
        #50 clk=!clk;
        $display("Output: %x", dataOut);
        
        $finish;
    end

endmodule
