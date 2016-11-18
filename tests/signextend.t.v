`include "submodules/signextender.v"

module testSignextend ();

	// Inputs
	reg clk;
	reg [15:0] imm;

	// Output
	wire [31:0] signextendOut;

	signextender signext(clk, imm, signextendOut);

	initial clk = 0;
	always #10 clk =! clk;
	initial begin

        $display("-------------------------");
    	$display("SIGNEXTENDER TEST CASES");
		$display("-------------------------");


        // Sign extend with ones
        $display("| imm | signextendOut |");
    	imm = 16'b1010101010101010; signextendOut = 1; #100
		$display("| 	%b 		| 		%b 		| ", imm, signextendOut);

        // Sign extend with zeros
        $display("| imm | signextendOut |");
    	imm = 16'b0101010101010101; #100
		$display("| 	%b 		| 		%b 		| ", imm, signextendOut);

	end
endmodule