# Expected Results
The test will run in the following order:
1. Jump and link to *Basic*
2. *Basic* submodule
  - XORI - Sets $t0 = 0x00, $t1 = 0x04, $t2 = 0x08, $t3 = 0x10, $t4 = 0x20
  - SW - Stores the values in registers $t0 to $t4 to data memory addresses $t0 to $t4
  - LW - Loads words $t4 and $t3 and saves them to $t0 and $t1
  - Add - $t8 = $t0 + $t1, $t9 = $t2 + $t3
  - Sub - $t8 = $t4 - $t3, $t9 = $t2 - $t3
  - SLT - $t8 = $t0 < $t1, $t9 = $t1 < $t0
3. Jump register to return address
4. Jump (test with different address values)
5. BNE - Ends test if $t0 != $t2 (This condition is true after the *Basic* submodule)

# Memory Layout
This test assumes that the memory is configured such that the text is saved at address 0, and the data segment begins at 0x1000 ("Compact, Text at Address 0" in MARS).
