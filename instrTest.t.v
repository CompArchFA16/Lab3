`include "memory.v"

module memory_test();
    reg clk;
    reg enable;
    reg [31:0] addr;
    reg [31:0] dataIn;
    wire [31:0] dataOut;

    Data_memory tester (clk, enable, addr, dataIn, dataOut);

    initial begin
        $dumpfile("refer.vcd");
        $dumpvars();
        clk=0; enable=0; addr=32'h00000001; dataIn=32'h00000000;
        #10 clk=1; #10 clk = 0;
        $display("Data Out: %b Addr: %b", dataOut, addr);
        clk=0; enable=0; addr=32'h0000000A; dataIn=32'h00000000;
        #10 clk=1; #10 clk = 0;
        $display("Data Out: %b Addr: %b", dataOut, addr);
        clk=0; enable=0; addr=32'h0000000A; dataIn=32'h00000000;
        #10 clk=1; #10 clk = 0;
        $display("Data Out: %b Addr: %b", dataOut, addr);
        clk=0; enable=1; addr=32'h0000000A; dataIn=32'hFFFFFFFF;
        #10 clk=1; #10 clk = 0;
        $display("Data Out: %b Addr: %b", dataOut, addr);
        //clk=0; enable=0; addr=32'h0000000A; dataIn=32'h00000000;
        //#10 clk=1; #10 clk = 0;
        //$display("Data Out: %b Addr: %b", dataOut, addr);
    end
endmodule
