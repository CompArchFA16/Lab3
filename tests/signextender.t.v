`include "submodules/signextender.v"

module testSignextend ();

	// Inputs
	reg clk;
	reg [15:0] imm;

	// Output
	wire [31:0] signextendOut;

	// Indicates whether register file passed tests
	reg dutpassed;

	signextender signext(.clk(clk), .imm(imm), .signextendOut(signextendOut));

	initial clk = 0;
	always #10 clk =! clk;
	initial begin

		clk = 1;
		dutpassed = 1;

        //$display("-------------------------");
    	//$display("SIGNEXTENDER TEST CASES");
		//$display("-------------------------");

        // Sign extend with ones
        //$display("| imm | signextendOut |");
    	imm = 16'b1010101010101010; #100
		//$display("| 	%b 		| 		%b 		| ", imm, signextendOut);

    	// Verify test result
    	if(signextendOut != 32'b11111111111111111010101010101010) begin
      		dutpassed = 0;
    	end 

        // Sign extend with zeros
        //$display("| imm | signextendOut |");
    	imm = 16'b0101010101010101; #100
		//$display("| 	%b 		| 		%b 		| ", imm, signextendOut);

    	// Verify test result
    	if(signextendOut != 32'b00000000000000000101010101010101) begin
      		dutpassed = 0;
    	end 

    	if (dutpassed != 0) begin
    		$display("SNE: PASSED");
    	end
    	else begin
    		$display("SNE: FAILED");
    	end

		$finish;

	end
endmodule
