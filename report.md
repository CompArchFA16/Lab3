# Lab 3: CPU

### Franton Lin, Ian Paul, Byron Wasti

## Block Diagram 

![Block Diagram](images/blockdiagram_update.png)

We used a simple single cycle CPU design based on this image that we found. We modified the original to allow for jump and link. Because we our design is single cycled, we only have a clock cycle going into the instruction memory.

We implemented the following RTL instructions:

Instr |Type| Op Code | Func |
------|----| ------- | ---- |
J     | J  | 0x2     |      |
JAL   | J  | 0x3     |      |
LW    | I  | 0x23    |      |
SW    | I  | 0x2b    |      |
BNE   | I  | 0x5     |      |
XORI  | I  | 0xe     |      |
JR    | R  | 0x00    | 0x08 |
ADD   | R  | 0x00    | 0x20 |
SUB   | R  | 0x00    | 0x22 |
SLT   | R  | 0x00    | 0x2a |

The table above highlights the different methods we used to differentiate commands, all based on the MIPS instruction set. All R-Type instructions are differentiated by their Func section rather than their Op Code.

## Test Plan and Results

Most of this was integrating other verilog files. These already had tests which we included in our project. The parts that we wrote for this lab we tested by running assembly and looking at the memory at the end or the GTKWave. Our testing showed that all of our old, reused modules were still working. Mostly, our testing of the full CPU showed us where we had miswired modules together. The assembly testing was how we did most of our testing and final confirmations at the end.

Our main test of functionality was running the sieves algorithm which generates prime numbers in data memory. The results are in `PrimeNumbers.dat`. The algorithm goes through and sets a memory location to `1` if it is not prime, and leaves it `0` if it is prime. Since the Sieves Algorithm heavily uses all functionality of our CPU, a valid output means that our CPU is functioning properly. 

## Performance/Area Analysis

Overall, our CPU will be slow and large for what it can do. Since it's single cycle it can only be clocked as fast as its slowest operation. We determined this to be load word because it sequentially uses all parts of the CPU. We also choose to implement memory in two separate blocks: instruction memory and data memory. This makes the design slighly larger. All of our components are reused from previous assignments, so we chose not to do analisys on them. 

## Work Plan Reflections

We overestimated the total number of hours this would take by a small amount, but that's probably due to us including a decent number of steps that we didn't actually need. For example, when writing the work plan we thought we had to implement a lot more high level features and allocated them a few hours. Instead, we spent those hours debugging our CPU for the assembly tests. We were likely better at our timing estimate this time because we struggled far less with the FSM design. Last lab we needed to spend a few hours redoing schematics, but this time we stuck with our initial design.
