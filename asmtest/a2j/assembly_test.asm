xori $sp, $zero, 0x3ffc
main: 
	add $t0, $zero, 5 #t0 = 5
	sub $t1, $t0, 2 #t1 = 3
	slt $t4, $t1, $t0 #t4 = 1
	jal storeload
	
	bne $t0, $t1, makeequal
	xori $t5, $t4, 0 
	j end
	
storeload: 
	add $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	lw $t2, 0($sp) #t2 = t0 = 5
	lw $t3, 4($sp) #t3 = t1 = 3
	add $sp, $sp, 8
	
	jr $ra

makeequal:
	sub $t0, $t0, 1
	jr $ra

end:
	j end
	
