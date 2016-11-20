`ifndef __CONTROLLER_V__
`define __CONTROLLER_V__

`include "utils.v"

module controller(
	input [5:0] opcode,
	input [5:0] funct,
	output reg [1:0] sel_pc,
	output reg sgn,
	output reg sel_b,
	output reg [1:0] sel_aluop,
	output reg dm_wen,
	output reg rf_wen,
	output reg [1:0] rf_selwadr,
	output reg [1:0] rf_seldin,
	output reg sel_bne
);

always @(opcode or funct) begin
	case(opcode)
		`O_R: begin
			case(funct)
				`O_ADD: begin
					sel_pc <= 2'b00;
					sel_b <= 1'b0;
					sel_aluop <= 2'b10; //means 'look at func'
					dm_wen <= 1'b0;
					rf_wen <= 1'b1;
					rf_selwadr <= 2'b10; // = rd
					rf_seldin <= 2'b10;
					sel_bne <= 1'b0;
				end
				`O_SUB: begin
					sel_pc <= 2'b00;
					sel_b <= 1'b0;
					sel_aluop <= 2'b10; //means 'look at func'
					dm_wen <= 1'b0;
					rf_wen <= 1'b1;
					rf_selwadr <= 2'b10;
					rf_seldin <= 2'b10;
					sel_bne <= 1'b0;
				end
				`O_SLT: begin
					sel_pc <= 2'b00;
					sel_b <= 1'b0;
					sel_aluop <= 2'b10; //means 'look at func'
					dm_wen <= 1'b0;
					rf_wen <= 1'b1;
					rf_selwadr <= 2'b10;
					rf_seldin <= 2'b10;
					sel_bne <= 1'b0;
				end
				`O_JR: begin
					sel_pc <= 2'b01;
					dm_wen <= 1'b0;
					rf_wen <= 1'b0;
				end
			endcase
		end
		`O_LW: begin
			sel_pc <= 2'b00;
			sgn <= 1'b1;
			sel_b <= 1'b1; // immediate
			sel_aluop <= 2'b00;
			dm_wen <= 1'b0;
			rf_wen <= 1'b1;
			rf_selwadr <= 2'b00; // = rt
			rf_seldin <= 2'b01;
			sel_bne <= 1'b0;
		end
		`O_SW: begin
			sel_pc <= 2'b00;
			sgn <= 1'b1;
			sel_b <= 1'b1;
			sel_aluop <= 2'b00;
			dm_wen <= 1'b1;
			rf_wen <= 1'b0;
			sel_bne <= 1'b0;	
		end
		`O_J: begin
			sel_pc <= 2'b11;
			dm_wen <= 1'b0;
			rf_wen <= 1'b0;
			sel_bne <= 1'b0;
		end
		`O_JAL: begin
			sel_pc <= 2'b11;
			dm_wen <= 1'b0;
			rf_wen <= 1'b1;
			rf_selwadr <= 2'b10; // = 31
			rf_seldin <= 2'b00;
			sel_bne <= 1'b0;
		end
		`O_BNE: begin
			sel_pc <= 2'b10;
			sel_b <= 1'b0;
			sel_aluop <= 2'b00;
			dm_wen <= 1'b0;
			rf_wen <= 1'b0;
			sel_bne <= 1'b1;
		end
		`O_XORI: begin
			sel_pc <= 2'b00;
			sgn <= 1'b0; //unsigned
			sel_b <= 1'b1;
			sel_aluop <= `C_XOR;
			dm_wen <= 1'b0;
			rf_wen <= 1'b1;
			rf_selwadr <= 2'b00;
			rf_seldin <= 2'b10;
			sel_bne <= 1'b0;
		end
	endcase
end

endmodule

`endif
