`timescale 1ns / 1ps


module mux2to1
(
    input input1,
    input input2,
    input select,
    output reg out
);

initial begin
if (select) begin
    out <= input1;
end
else begin
    out <= input2;
end
end
endmodule


module quicktest();
    reg input1 ;
    reg input2;
    reg select ;
    wire out;

    mux2to1 muxie (input1, input2, select, out);

    initial begin

        input1 = 1;
        input2 = 0;
        select = 1;
        #100
        $display("Output: %d %d %d %d", out, select, input1, input2);

    end
endmodule
