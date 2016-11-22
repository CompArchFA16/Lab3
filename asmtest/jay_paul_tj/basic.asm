add $zero, $zero, $zero
add $zero, $zero, $zero

# Jump and link
jal basic

add $zero, $zero, $zero
add $zero, $zero, $zero

# Jump
target1: j target3
target2: j target5
target3: j target4
target4: j target2
target5:

# Branch if not equal
bne $t0, $t2, end

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# XORI, store word, load word, add, subtract, and SLT in one subroutine
basic:
xori $t0, $zero, 0x0
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
xori $t1, $zero, 0x4
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
xori $t2, $zero, 0x8
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
xori $t3, $zero, 0x10
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
xori $t4, $zero, 0x20
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

sw $t0, 0x1000($t0)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sw $t1, 0x1000($t1)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sw $t2, 0x1000($t2)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sw $t3, 0x1000($t3)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sw $t4, 0x1000($t4)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

lw $t4, 0x1000($t0)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
lw $t3, 0x1000($t1)
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

add $t8, $t0, $t1
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $t9, $t2, $t3
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sub $t8, $t4, $t3
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
sub $t9, $t2, $t3
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

slt $t8, $t0, $t1
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
slt $t9, $t1, $t0
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# Jump to register
jr $ra # Return to beginning
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# Finished all tests
end:
sw $t2, 0x1234($zero)
