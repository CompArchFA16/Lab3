; Sieves Algorithm
;; Prime Number Generator

; Main start
xori $a0, $zero, 30 ; $a0 is the top prime to go to
xori $a1, $zero, 4 ; $a1 is word-size
xori $a2, $zero, 1 ; $a2 is the immediate 1

xori $s0, $zero, 0x10010000 ; $s0 stores the start address of the data
xori $s1, $zero, 2 ; $s1 stores the current number iterating through

; Start $s0 at 2's place
sw $a2, 0($s0)
add $s0, $s0, $a1
sw $a2, 0($s0)
add $s0, $s0, $a1

; for( ; $t0 < $a0; $t0++ )
mainLoop:
	bne $a0, $s1, body ; Do check
	j end
	body: ; The meat of the program

	; Make sure the memory spot at current place is 0 (prime)
	lw $t0, 0($s0)
	bne $t0, $zero, nextNumber

	; Mark memory spots of multiples
	jal markMemory

	; Go to next number
	nextNumber:
	add $s1, $s1, $a2
	add $s0, $s0, $a1
	
j mainLoop


; Function
markMemory:

	; Multiply $s1 (cur number) w/ $a1 (word size)
	xori $t1, $zero, 0 ; Stores multiples in word-size
	add $t0, $s1, $zero
	
	Mult:
 		add $t1, $t1, $a1
		sub $t0, $t0, $a2
		slt $t2, $zero, $t0 ; t2 = a2 < t0 ? 1:0 -> t2 = 1 < t0 ? 1 : 0
   		bne $t2, $a2, endMult
   	j Mult
   	
	endMult:
  
	; $t0 will hold where we are at for this function
	add $t0, $s1, $zero ; $t0 = $s1
	add $t2, $s0, $zero ; $t2 = $s0

	for:
		add $t0, $t0, $s1 ; Next multiple of $s1
		add $t2, $t2, $t1 ; Memory position of next multiple

		; Check to make sure we don't go above $a0
		slt $t3, $a0, $t0 ;  $a0 < $t0 ? 1 : 0
		bne $t3, $zero, jumpBack ; Done with loop

		sw $a2, 0($t2)

	j for

jumpBack:
jr $ra

; Done with the program
end:

.data
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
