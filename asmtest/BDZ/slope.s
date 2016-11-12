# Slope of a line defined by two points: (x1, y1) and (x2, y2)
# Slope is floored because the return type is int.

# 	return num / den;

# int main () {
# 	int s = slope (0, 0, 3, 6);
# 	printf("%d", s);
# 	return s;
# }

# int slope (int x1, int y1, int x2, int y2) {
# 	int num = y2 - y1;
# 	int den = x2 - x1;
# 	return num / den;
# }

main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 3
	addi $a3, $zero, 6
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a3, 0($sp)
	# set up $a0?
	jal slope
	lw $ra, 16($sp)
	addi $sp, $sp, 20

slope:
	sub $t0, $a3, $a1 # numerator
	sub $t1, $a2, $a0 # denominator
	add $t2, $zero, $zero # sign
	add $t3, $zero, $zero # division counter
	addi $t4, $zero, 1 # division complete check
	divloop:
		sub $t0, $t0, $t1 # subtracting the den from the num
		slt $t4, $zero, $t0 # check if 0 < $t0
		bne $zero, $t4, endloop # branch if $t0 is not > 0 (<= 0)
		addi $t3, $t3, 1
		j divloop
	endloop:
	j end

end: