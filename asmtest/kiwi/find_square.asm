# Calculate the square of an input integer
# Also run through every command with a focus on testing hazards

# Instruction set: LW, SW, J, JR, JAL, BNE, XORI, ADD, SUB, SLT



# Main Function
main:
	addi $sp, $sp, -8
	jal instr
	addi $sp, $sp, 8
	xori $t6, $zero, 0
	jal square
	j end



# Instruction tests
instr:
	# Load values for operations
	xori $t0, $zero, 1	# 1 -> $t0
	xori $t1, $zero, 2	# 2 -> $t1
	xori $t2, $zero, 3	# 3 -> $t2

	# ADD/SUB test
	add $t3, $t1, $t2	# 5 -> $t3
	sub $t4, $t3, $t0	# 4 -> $t4

	# SLT test
	slt $t4, $t2, $t3	# 1 -> $t4

	# BNE/LW/SW test
	bne $t4, $t0, bneTest	# make $t0 equal to $t4 (1 -> $t0) in bneTest

	
	bneTest:
		sw $t4, 0($sp)		# load $t4 into $sp
		lw $t5, 0($sp)		# make $t0 equal to $t4

	# JR test (return to main)
	jr $ra



# Compute square of 
square:
	# Compute the square of $t2, store in $t7
	# for ($t6 = 0; $t6 < $t3; $t6++)
	bne $t6, $t3, body
	jr $ra

	body: 
		add $t7, $t7, $t3	# add $t3 to the sum
		add $t6, $t6, $t0	# add 1 to the count in $t6
		jal square
		



end:
	
