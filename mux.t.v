module quicktest();
    reg input1;
    reg input2;
    reg selector;
    wire out;

    mux2to1 muxie (input1, input2, selector, out);

    initial begin

        input1 = 10001;
        input2 = 00000;
        selector = 1;
        #100
        $display("Output: %b %b %b %b", out, selector, input1, input2);

    end
endmodule
