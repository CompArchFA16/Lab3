`timescale 1 ns / 1 ps


module mux2to1
(
    input input1,
    input input2,
    input select,
    output reg out
);

always @(input1, input2, select) begin
if (select) begin
    assign out = input2;
end
else begin
    assign out = input1;
end
end
endmodule


module quicktest();
    reg input1;
    reg input2;
    reg selector;
    wire out;

    mux2to1 muxie (input1, input2, selector, out);

    initial begin

        input1 = 1;
        input2 = 0;
        selector = 1;
        #100
        $display("Output: %b %b %b %b", out, selector, input1, input2);

    end
endmodule
