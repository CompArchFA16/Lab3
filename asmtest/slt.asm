xori $t0, $zero, 8
xori $t1, $zero, 2

slt $t2, $t0, $t1 # Value in $t2 should be 0
slt $t3, $t1, $t0 # Value in $t3 should be 1
