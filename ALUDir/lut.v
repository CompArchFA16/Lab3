// define logic control
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7


module aluLUT
(
    output reg[2:0] sel,
    output reg      invert,
    // output reg      sltOp,
    input[2:0]      ALUcommand
);
    wire[2:0] ALUcommand;

    always @(ALUcommand) begin
        case (ALUcommand)
            `ADD:  begin sel = 0; invert=0; end    
            `SUB:  begin sel = 0; invert=1; end
            `AND:  begin sel = 1; invert=0; end
            `NAND: begin sel = 2; invert=0; end
            `NOR:  begin sel = 3; invert=0; end
            `OR:   begin sel = 4; invert=0; end
            `XOR:  begin sel = 5; invert=0; end
            `SLT:  begin sel = 6; invert=0; end   
        endcase
    end
endmodule
