xori $t5, $zero, 6
xori $t2, $zero, 2
inadd: add $t2, $t2, 2
bne $t2, $t5, inadd
sub $t3, $t5, 3
