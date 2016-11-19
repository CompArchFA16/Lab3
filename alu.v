`define ADD  3'd0
`define SUB  3'd1
`define NAND 3'd2
`define AND  3'd3
`define NOR  3'd4
`define OR   3'd5
`define XOR  3'd6
`define SLT  3'd7

module ALU
(
    output reg [31:0] result,
    output zero,
    output overflow,
    input signed [31:0] A,
    input signed [31:0] B,
    input [2:0] command
);
    reg cout;

    assign zero = (result == 0);
    assign overflow = (cout^result[31]) && (command == `ADD || command == `SUB);
    always @(command, A, B) begin
        case(command)
            `ADD:   {cout, result} <= A + B;
            `SUB:   {cout, result} <= A - B;
            `NAND:  result <= ~(A + B);
            `AND:   result <= A & B;
            `NOR:   result <= ~(A | B);
            `OR:    result <= A | B;
            `XOR:   result <= A ^ B;
            `SLT:   result <= A < B;
            default:result <= 0;
        endcase
    end
endmodule
