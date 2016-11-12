# Compute the multiplicative factorial of a value, then print it

.data
facts: .word 0:10 # add size in form 0:19
size: .word 10
prompt: .asciiz
.text
	la   $s0, facts
	la   $s5, size
	lw   $s5, 0($s5)
	
	li   $s2, 1
	sw   $s2, 0($s0)