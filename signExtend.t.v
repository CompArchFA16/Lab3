module signExtend
(
	input [15:0] imm,
	output reg [31:0] seImm
);

always @(imm) begin
    seImm <= $signed(imm);
end
endmodule

module seTest();
    reg [15:0] imm;
    wire [31:0] seImm;
	reg dutpassed = 0;

    signExtend se(imm, seImm);

    initial begin
        imm = 16'h0000;
        imm = 16'hffff; #1000
        // $display("Imm: %b seImm: %b", imm, seImm);
		#10
		if (seImm == 32'b11111111111111111111111111111111) begin
			dutpassed = 1;
		end
		else begin
		dutpassed = 0;
		end
        imm = 16'h0000; #1000
        // $display("Imm: %b seImm: %b", imm, seImm);
		#10
		if (seImm == 32'b00000000000000000000000000000000) begin
			dutpassed = 1;
		end
		else begin
		dutpassed = 0;
		end
        imm = 16'haaaa; #1000
        // $display("Imm: %b seImm: %b", imm, seImm);
		#10
		if (seImm == 32'b11111111111111111010101010101010) begin
			dutpassed = 1;
		end
		else begin
		dutpassed = 0;
		end
        imm = 16'h2222; #1000
        // $display("Imm: %b seImm: %b", imm, seImm);
		#10
		if (seImm == 32'b00000000000000000010001000100010) begin
			dutpassed = 1;
		end
		else begin
		dutpassed = 0;
		end
        imm = 16'h0111; #1000
        // $display("Imm: %b seImm: %b", imm, seImm);
		#10
		if (seImm == 32'b00000000000000000000000100010001) begin
			dutpassed = 1;
		end
		else begin
		dutpassed = 0;
		end

		$display("Sign Extend DUT: %b ", dutpassed);
    end

endmodule
