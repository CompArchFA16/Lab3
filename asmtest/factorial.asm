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
	addi $s1, $zero, 1 # Count against $s1 to check if we have multiplied enough times
	
outloop: lw $s3, 0($s0)		# Set s3 to s2 so we can use it to add back onto s2 repeatedly
	 addi $s4, $zero, 1	# Set s4 back to 1 so we can iterate through it in the interior loop
	 addi $s1, $s1, 1	# Iterate s1 ...
      inloop: add $s2, $s2, $s3	# Every interior loop adds the initial value of s2 to itself
	      addi $s4, $s4, 1	# iterate s4 ...
	      bne $s4, $s1, inloop # ... until it equals s1
      	 sw   $s2, 4($s0)      	# Store newly computed F[n] in array
      	 addi $s0, $s0, 4      	# increment address to now-known factorial storage
      	 bne $s5, $s1, outloop	# ... until it equals s5
      	 
# Factorials are computed and stored in an array. Print them.
      la   $a0, facts        # first argument for print (array)
      add  $a1, $zero, $s5  # second argument for print (size)
      jal  print            # call print routine. 

      # The program is finished. Exit.
      li   $v0, 10          # system call for exit
      syscall               # Exit!
		
###############################################################
# Subroutine to print the numbers on one line.
      .data
space:.asciiz  " "          # space to insert between numbers
head: .asciiz  "The factorial values are:\n"
      .text
print:add  $t0, $zero, $a0  # starting address of array of data to be printed
      add  $t1, $zero, $a1  # initialize loop counter to array size
      la   $a0, head        # load address of the print heading string
      li   $v0, 4           # specify Print String service
      syscall               # print the heading string
      
out:  lw   $a0, 0($t0)      # load the integer to be printed (the current Fib. number)
      li   $v0, 1           # specify Print Integer service
      syscall               # print fibonacci number
      
      la   $a0, space       # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string
      
      addi $t0, $t0, 4      # increment address of data to be printed
      addi $t1, $t1, -1     # decrement loop counter
      bgtz $t1, out         # repeat while not finished
      
      jr   $ra              # return from subroutine
# End of subroutine to print the numbers on one line
###############################################################
