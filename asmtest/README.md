# Test your CPU: Factorial Progression

Expected results of the test
The result of the test should be 1!, 2!, 3!, 4!, 5!....9!, 10!, or more specifically "1 2 6 24 120 720 5040 40320 362880 3628800"

Memory layout requirements:

| Address   | Segment                    |
|:---------:|:---------------------------|
|0x00003fff | data segment limit address |
|0x00003ffc | stack pointer $sp          |
|0x00003ffc | stack base address         |
|0x00003000 | stack limit address        |
|0x00002000 | .data base address         |
|0x00001800 | global pointer $gp         |
|0x00001000 | data segment base address  |
|0x00000ffc | text limit address         |
|0x00000000 | .text base address         |


Instructions used outside basic required subset? 

We used addi and la, which are add immediate and load address, respectively. The instructions used overall were lw, sw, add, addi, bne, and la.

Submit the test program and README by submitting a pull request to the main course repository. Code should be in `/asmtest/<your-team-name>/` (you may use subfolders if you submit multiple tests).

