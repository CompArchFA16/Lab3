`ifndef __ALU_T_V__
`define __ALU_T_V__
`include "alu.v"

`define TEST(aValue,bValue) operandA= aValue; operandB  = bValue; #10000
`define CHECK(exp) $display("%d & %d & %d & %d & %b &  %b  &  %b & %s", operandA, operandB, command, result, carryout, zero, overflow, ((result == exp)? "PASS" : "FAIL"))
`define CHECKFLAGS(res,co,zr,of) flags = {result == res, carryout == co, zr == zero, overflow == of}; \
$display("%b & %b & %d & %d & %b &  %b  &  %b & %s", operandA, operandB, command, result, carryout, zero, overflow, ((result == res)? ((flags == 4'b1111)? "PASS": "FAILED FLAGS") : "FAIL"))
`define TESTCHECK(a,b,res) `TEST(a,b); `CHECK(res)
`define TESTFLAGS(a,b,res, co, zr, of) `TEST(a,b); `CHECKFLAGS(res, co, zr, of)

module alu_test();
wire signed [31:0] result;
wire carryout;
wire zero;
wire overflow;
reg signed [31:0] operandA;
reg signed [31:0] operandB;
reg [31:0]      command;
reg [3:0] flags;

alu #(.n(32)) alu_dut(result,carryout,zero,overflow,operandA,operandB,command[2:0]);

initial begin

	//create gtkwavefile
	$dumpfile("alu.vcd");
	$dumpvars;

	// =================================
	// 4-bit exhaustive test cases
	// Commented out due to incompatibility with 32-bit module.
	// Loops through all cases and shows output, though hard to interpret.
	// =================================
	//	for(operandA=-7; operandA<7; operandA=operandA+1) begin
	//		for(operandB=-7; operandB<7; operandB=operandB+1) begin
	//			for(command=0; command<8; command=command+1) begin
	//				#10000;
	//				$display("%b %b %d | %b %b %b %b |", operandA, operandB, //command[2:0], result, carryout, zero, overflow);//
	//			end//
	//		end
	//	end
	// =================================


	// =================================
	// Worst case Propagation Delay
	// Since there is no good way to determine the worst propagation delay,
	// open alu.vcd with gtkwave and examine the time it takes for the final
	// output to change values
	// =================================
	
	// ADD
	command = `C_ADD;
	operandA = -1; operandB = 0; #10000;
	operandA = -1; operandB = 1; #10000;

	// SUB / SLT, equivalent
	command = `C_SUB;
	operandA = -1; operandB = 0; #10000;
	operandA = -1; operandB = -1; #10000; 
	
	// AND
	command = `C_AND;
	operandA = -1; operandB = 0; #10000;	
	operandA = -1; operandB = -1; #10000;

	// =================================
	// Starting Result Verifications Here
	// =================================

	command= `C_ADD;
	$display("Testing ADD:");
	$display(" A  B CMD | RES C_OUT ZERO OVERFLOW | PASS");
	`TESTFLAGS(({4'b1011, 28'b0}),({4'b1010, 28'b0}),({4'b0101, 28'b0}),1'b1,1'b0,1'b1);
	`TESTFLAGS(({4'b0110, 28'b0}),({4'b0100, 28'b0}),({4'b1010, 28'b0}),1'b0,1'b0,1'b1);
	`TESTFLAGS(({4'b1111, 28'b0}),({4'b1010, 28'b0}),({4'b1001, 28'b0}), 1'b1, 1'b0, 1'b0);
	`TESTFLAGS(({4'b0001, 28'b0}),({4'b0101, 28'b0}),({4'b0110, 28'b0}), 1'b0, 1'b0, 1'b0);

	`TESTFLAGS(32'b1011,32'b1010, (32'b1011 + 32'b1010), 1'b0, 1'b0, 1'b0);
	`TESTFLAGS(32'b0110,32'b0100, (32'b0110 + 32'b0100),1'b0, 1'b0, 1'b0);
	`TESTFLAGS(32'b1111,32'b1010, (32'b1111 + 32'b1010),1'b0, 1'b0, 1'b0);
	`TESTFLAGS(32'b0001,32'b0101, (32'b0001 + 32'b0101),1'b0, 1'b0, 1'b0);
	`TESTFLAGS(~(32'd0),32'b1, 32'b0,1'b1,1'b1,1'b0);

	// SUB Module Test
	command= `C_SUB;
	$display("Testing SUB:");
	$display(" A  B CMD | RES C_OUT ZERO OVERFLOW | PASS");
	//`TESTFLAGS(a, b, a-b, carryout, zero, overflow);
	`TESTFLAGS(({4'b0010, 28'b0}),({4'b1010, 28'b0}),({4'b1000, 28'b0}),1'b0,1'b0,1'b1);
	`TESTFLAGS(({4'b1111, 28'b0}),({4'b1111, 28'b0}),32'b0,1'b1,1'b1,1'b0);
	`TESTFLAGS(({4'b0100, 28'b0}),({4'b0010, 28'b0}),({4'b0010, 28'b0}), 1'b1, 1'b0, 1'b0);
	`TESTFLAGS(({4'b0111, 28'b0}),({4'b1010, 28'b0}),({4'b1101, 28'b0}), 1'b0, 1'b0, 1'b1);

	// Same test, now with 4 bits set on lower bits so no overflow should occur
	`TESTFLAGS(32'b0010,32'b1010,-32'd8, 1'b0, 1'b0, 1'b0);
	`TESTFLAGS(32'b1111,32'b1111,32'b0, 1'b1, 1'b1, 1'b0);
	`TESTFLAGS(32'b0100,32'b0010,32'b0010, 1'b1, 1'b0, 1'b0);
	`TESTFLAGS(32'b0111,32'b1010,-32'd3, 1'b0, 1'b0, 1'b0);


	// SLT Module Test
	command=`C_SLT;
	$display("Testing SLT:");
	`TESTCHECK(32'd7,32'd2,32'd0);
	`TESTCHECK(32'd1,32'd4,32'd1);
	`TESTCHECK(-32'd4,-32'd7,32'd0);
	`TESTCHECK(-32'd6,-32'd3,32'd1);
	`TESTCHECK(-32'd1,-32'd1,32'd0);

	// XOR, NAND, AND, NOR, OR Module Test
	$display("Testing XOR, NAND, AND, NOR, OR:");

	$display(" A  B CMD | RES C_OUT ZERO OVERFLOW | PASS");

	for(command = 3; command < 8; command = command + 1) begin

		case (command)
			`C_XOR: begin
				$display(" -- XOR -- ");
				`TESTCHECK(-32'd1, -32'd1, -32'd1 ^ -32'd1);
				`TESTCHECK(-32'd1, 32'd0, -32'd1 ^ 32'd0);
				`TESTCHECK(32'd0, -32'd1, 32'd0 ^ -32'd1);
				`TESTCHECK(32'd0, 32'd0, 32'd0 ^ 32'd0);
			end
			`C_NAND: begin
				$display(" -- NAND -- ");
				`TESTCHECK(-32'd1, -32'd1, ~(-32'd1 & -32'd1));
				`TESTCHECK(-32'd1, 32'd0, ~(-32'd1 & 32'd0));
				`TESTCHECK(32'd0, -32'd1, ~(32'd0 & -32'd1));
				`TESTCHECK(32'd0, 32'd0, ~(32'd0 & 32'd0));
			end
			`C_AND: begin
				$display(" -- AND -- ");
				`TESTCHECK(-32'd1, -32'd1, (-32'd1 & -32'd1));
				`TESTCHECK(-32'd1, 32'd0, (-32'd1 & 32'd0));
				`TESTCHECK(32'd0, -32'd1, (32'd0 & -32'd1));
				`TESTCHECK(32'd0, 32'd0, (32'd0 & 32'd0));
			end
			`C_NOR: begin
				$display(" -- NOR -- ");
				`TESTCHECK(-32'd1, -32'd1, ~(-32'd1 | -32'd1));
				`TESTCHECK(-32'd1, 32'd0, ~(-32'd1 | 32'd0));
				`TESTCHECK(32'd0, -32'd1, ~(32'd0 | -32'd1));
				`TESTCHECK(32'd0, 32'd0, ~(32'd0 | 32'd0));
			end
			`C_OR: begin
				$display(" -- OR -- ");
				`TESTCHECK(-32'd1, -32'd1, (-32'd1 | -32'd1));
				`TESTCHECK(-32'd1, 32'd0, (-32'd1 | 32'd0));
				`TESTCHECK(32'd0, -32'd1, (32'd0 | -32'd1));
				`TESTCHECK(32'd0, 32'd0, (32'd0 | 32'd0));
			end
		endcase
		#10000;
	end

end

endmodule
`endif
