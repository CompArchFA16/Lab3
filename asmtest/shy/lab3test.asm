start:
    j main

addsubslt:
    add $t2, $t1, $t0  # Register $t2 should hold 7
    sub $t3, $t1, $t0  # Register $t3 should hold 3
    slt $t4, $t3, $t2  # Register $t4 should hold 1
    jr $ra

store:
    sw $t0, 4($sp)     # push $t0
    sw $t1, 0($sp)     # push $t1
    jr $ra

load:
    lw $t5, 4($sp)     # Put 2 into register $t5
    lw $t6, 0($sp)     # Put 5 into register $t6
    jr $ra

main:
    xori $t0, $zero, 2  # Put 2 into register $t0
    xori $t1, $zero, 5  # Put 5 into register $t1

    jal addsubslt

    addi $sp, $sp, -8  # Allocate space
    jal store          
    jal load
    addi $sp, $sp, 8  # Delete space
    
    j end

end:

# Instructions used: ADD, SUB, SLT, XORI, J, JAL, JR, LW, SW
# No .data requirement
# At the end, the registers should have the following value
#   t0  2
#   t1  5
#   t2  7
#   t3  3
#   t4  1
#   t5  2
#   t6  5
