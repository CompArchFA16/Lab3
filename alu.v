`ifndef __ALU_V__
`define __ALU_V__

// Module Declaration taken from Lab 1
`include "utils.v"

module alu
#(parameter n = 32)
(
	output reg [n-1:0]   result,
	output carryout,
	output zero,
	output overflow,
	input [n-1:0]    a,
	input [n-1:0]    b,
	input [2:0]      command
);

integer i;
reg [n:0] carryouts;
wire [n-1:0] _b = ~b;
// FLAGS
assign zero = ~|result;
assign overflow = carryouts[n] ^ carryouts[n-1];
assign carryout = carryouts[n];

always @* begin
	case (command)
		`C_ADD: begin
			carryouts[0] = 1'b0;
			for(i=0; i<n; i=i+1) begin
				{carryouts[i+1], result[i]} <= a[i] + b[i] + carryouts[i];
			end
			end
		`C_SUB: begin
			carryouts[0] = 1'b1;
			for(i=0; i<n; i=i+1) begin
				{carryouts[i+1], result[i]} <= a[i] + _b[i] + carryouts[i];
			end
		end
		`C_SLT:  begin
			result <= (a < b);
		end // invert B to subtract subtract
		`C_XOR:  begin
			result <= (a ^ b);
		end    
		`C_NAND: begin
			result <= ~(a & b);
		end
		`C_AND:  begin
			result <= (a & b);
		end    
		`C_NOR:  begin
			result <= ~(a | b);
		end    
		`C_OR:   begin
			result <= (a | b);
		end
		default: begin
			// can't really define a reasonable default behavior :/
			result <= 0;
		end
	endcase
end

endmodule

`endif
