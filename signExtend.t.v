`include "singlecyclecpu.v"

module seTest();
    reg [15:0] imm;
    wire [31:0] seImm;
    
    signExtend se(imm, seImm);
    
    initial begin
        imm = 8'h00000000;
        #10 imm = 8'hffffffff;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 8'h00000000;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 8'haaaaaaaa;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 8'h22222222;
        $display("Imm: %b seImm: %b", imm, seImm);
        #10 imm = 8'h01111111;
        $display("Imm: %b seImm: %b", imm, seImm);
    end

endmodule
