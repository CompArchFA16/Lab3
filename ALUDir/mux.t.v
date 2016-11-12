`include "mux.v"

module testMux();
    reg[2:0] sel;
    reg[7:0] muxInputs;

    wire out;

    aluMUX mux0 (out, sel, muxInputs[0], muxInputs[1], muxInputs[2], muxInputs[3],
                 muxInputs[4], muxInputs[5], muxInputs[6], muxInputs[7]);

    initial begin
        $display("select | out | expected");

        sel=3'b000;
        muxInputs=8'bXXXXXXX0;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b000;
        muxInputs=8'bXXXXXXX1;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b001;
        muxInputs=8'bXXXXXX0X;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b001;
        muxInputs=8'bXXXXXX1X;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b010;
        muxInputs=8'bXXXXX0XX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b010;
        muxInputs=8'bXXXXX1XX;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b011;
        muxInputs=8'bXXXX0XXX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b011;
        muxInputs=8'bXXXX1XXX;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b100;
        muxInputs=8'bXXX0XXXX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b100;
        muxInputs=8'bXXX1XXXX;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b101;
        muxInputs=8'bXX0XXXXX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b101;
        muxInputs=8'bXX1XXXXX;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b110;
        muxInputs=8'bX0XXXXXX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b110;
        muxInputs=8'bX1XXXXXX;
        #1000
        $display("%b    | %b   | 1", sel, out);

        sel=3'b111;
        muxInputs=8'b0XXXXXXX;
        #1000
        $display("%b    | %b   | 0", sel, out);

        sel=3'b111;
        muxInputs=8'b1XXXXXXX;
        #1000
        $display("%b    | %b   | 1", sel, out);
    end
    
endmodule
