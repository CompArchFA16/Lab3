// From: http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html

`ifndef _opcodes
`define _opcodes

// Arithmetic and logical.
`define CMD_add	  6'b100000
`define CMD_addu	6'b100001
`define CMD_addi	6'b001000
`define CMD_addiu	6'b001001
`define CMD_and	  6'b100100
`define CMD_andi  6'b001100
`define CMD_div	  6'b011010
`define CMD_divu	6'b011011
`define CMD_mult	6'b011000
`define CMD_multu	6'b011001
`define CMD_nor	  6'b100111
`define CMD_or	  6'b100101
`define CMD_ori	  6'b001101
`define CMD_sll	  6'b000000
`define CMD_sllv	6'b000100
`define CMD_sra	  6'b000011
`define CMD_srav	6'b000111
`define CMD_srl	  6'b000010
`define CMD_srlv	6'b000110
`define CMD_sub	  6'b100010
`define CMD_subu	6'b100011
`define CMD_xor	  6'b100110
`define CMD_xori	6'b001110

// Constant-manipulating.
`define CMD_lhi	6'b011001
`define CMD_llo	6'b011000

// Comparison.
`define CMD_slt	  6'b101010
`define CMD_sltu	6'b101001
`define CMD_slti	6'b001010
`define CMD_sltiu	6'b001001

// Branch.
`define CMD_beq	  6'b000100
`define CMD_bgtz	6'b000111
`define CMD_blez	6'b000110
`define CMD_bne	  6'b000101

// Jump.
`define CMD_j	    6'b000010
`define CMD_jal	  6'b000011
`define CMD_jalr	6'b001001
`define CMD_jr	  6'b001000

// Load.
`define CMD_lb	6'b100000
`define CMD_lbu	6'b100100
`define CMD_lh	6'b100001
`define CMD_lhu	6'b100101
`define CMD_lw	6'b100011

// Store.
`define CMD_sb	6'b101000
`define CMD_sh	6'b101001
`define CMD_sw	6'b101011

// Data movement.
`define CMD_mfhi  6'b010000
`define CMD_mflo	6'b010010
`define CMD_mthi	6'b010001
`define CMD_mtlo	6'b010011

// Trap.
`define CMD_trap	6'b011010

`endif
