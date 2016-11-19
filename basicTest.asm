xori $t0, $zero, 4
jal here
add $t3, $0, $t1
j end

here:
	xori $t1, $zero, 5
	jr $ra

end:
j end