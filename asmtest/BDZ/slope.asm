# Slope of a line defined by two points: (x1, y1) and (x2, y2)
# Slope is floored because the return type is int.

.data # loading (x1, y1) and (x2, y2) values
	x1: .word 0
	y1: .word 0
	x2: .word 3
	y2: .word 6

.text
main:
	# load address of parameters
	la $a0, x1
	la $a1, y1
	la $a2, x2
	la $a3, y2
	
	# loading contents at parameter addresses into volatile memory
	lw $t4, ($a0)
	lw $t5, ($a1)
	lw $t6, ($a2)
	lw $t7, ($a3)

	# allocating memory for slope function
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	jal slope
	lw $ra, 16($sp)
	addi $sp, $sp, 20

slope:
	# calculating numerator and denominator
	sub $t0, $t7, $t5 # numerator
	sub $t1, $t6, $t4 # denominator

	divloop:
		# dividing numerator / denominator
		sub $t0, $t0, $t1 # subtracting the den from the num
		slt $t4, $t0, $zero # check if num < 0
		bne $zero, $t4, endloop # branch if num < 0
		addi $t3, $t3, 1 # add to division counter
		j divloop
	endloop:
	j end

end: # answer is stored in $t3