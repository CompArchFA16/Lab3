# Jump and link
jal basic

# Jump
target1: j target3
target2: j target5
target3: j target4
target4: j target2
target5:

# Branch if not equal
bne $t0, $t2, end

# XORI, store word, load word, add, subtract, and SLT in one subroutine
basic:
xori $t0, $zero, 0x0
xori $t1, $zero, 0x4
xori $t2, $zero, 0x8
xori $t3, $zero, 0x10
xori $t4, $zero, 0x20

sw $t0, 0x1000($t0)
sw $t1, 0x1000($t1)
sw $t2, 0x1000($t2)
sw $t3, 0x1000($t3)
sw $t4, 0x1000($t4)

lw $t4, 0x1000($t0)
lw $t3, 0x1000($t1)

add $t8, $t0, $t1
add $t9, $t2, $t3

sub $t8, $t4, $t3
sub $t9, $t2, $t3

slt $t8, $t0, $t1
slt $t9, $t1, $t0

# Jump to register
jr $ra # Return to beginning

# Finished all tests
end:
