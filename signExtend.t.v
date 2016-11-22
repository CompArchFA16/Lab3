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
    
    signExtend se(imm, seImm);

    initial begin
        imm = 16'h0000;
        imm = 16'hffff; #1000
        $display("Imm: %b seImm: %b", imm, seImm);
        imm = 16'h0000; #1000
        $display("Imm: %b seImm: %b", imm, seImm);
        imm = 16'haaaa; #1000
        $display("Imm: %b seImm: %b", imm, seImm);
        imm = 16'h2222; #1000
        $display("Imm: %b seImm: %b", imm, seImm);
        imm = 16'h0111; #1000
        $display("Imm: %b seImm: %b", imm, seImm);
    end

endmodule
