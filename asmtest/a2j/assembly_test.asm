xori $sp, $zero, 0x3ffc
xori $t0, $zero, 4 #t0 = 4
xori $t1, $zero, 1 #t1 = 1

main:
	sub $t2, $t0, $t1 #$t2 = 3
	add $t3, $t0, $t1 #t3 = 5
	slt $t4, $t0, $t1 #t4 = 1
	
	jal storeload

	bne $t0, $t1, makeequal
	xori $t7, $t4, 0 
	j end
	
storeload: 
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	lw $t5, 0($sp) #t5 = t0 = 4
	lw $t6, 4($sp) #t6 = t1 = 1
	
	jr $ra

makeequal:
	sub $t0, $t0, $t1
	jr $ra

end:
	j end
	
