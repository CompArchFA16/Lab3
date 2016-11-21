xori $t0, $zero, 2
xori $t1, $zero, 5

add $t2, $t1, $t0 # Register $t2 should hold 7

sub $t3, $t1, $t0 # Register $t3 should hold 3

sub $t4, $t0, $t1 # Register $t4 should hold -2
