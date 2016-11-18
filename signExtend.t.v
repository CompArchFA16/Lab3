`include "singlecyclecpu.v"

module seTest();
    reg [15:0] imm;
    wire [31:0] seImm;
    
    signExtend se(imm, seImm);
    
    initial begin
        imm = 4'h0000;
        #10 imm = 4'hffff;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 4'h0000;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 4'haaaa;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 4'h2222;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 4'h0111;
        $display("Imm: %b seImm: %b", imm, seImm);
    end

endmodule
