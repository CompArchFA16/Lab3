`ifndef __ALU_V__
`define __ALU_V__

// Module Declaration taken from Lab 1
`include "utils.v"

module alu
#(parameter n = 32)
(
	output reg signed [n-1:0]   result,
	output reg signed carryout,
	output zero,
	output overflow,
	input [n-1:0]    a,
	input [n-1:0]    b,
	input [2:0]      command
);

// FLAGS
assign overflow = ({carryout,result[31]} == 2'b01);
assign zero = ~|result;

always @* begin
	case (command)
		`C_ADD: begin
			{carryout,result} <= a + b;
		end
		`C_SUB: begin
			{carryout,result} <= a - b;
		end
		`C_SLT:  begin
			result <= (a < b);
		end // invert B to subtract subtract
		`C_XOR:  begin
			result <= (a ^ b);
		end    
		`C_NAND: begin
			result <= ~(a&b);
		end
		`C_AND:  begin
			result <= (a&b);
		end    
		`C_NOR:  begin
			result <= ~(a|b);
		end    
		`C_OR:   begin
			result <= (a|b);
		end
		default: begin
			// can't really define a reasonable behavior :/
			result <= 0;
		end
	endcase
end

endmodule

`endif
