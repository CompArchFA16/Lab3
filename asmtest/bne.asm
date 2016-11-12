xori $t0, $zero, 3
xori $t1, $zero, 3


bne $t0, $t1, branched
add $t0, $t0, $t1 

branched:
add $t1, $t0, $t1 # Should branch. Register $t1 should hold value 10