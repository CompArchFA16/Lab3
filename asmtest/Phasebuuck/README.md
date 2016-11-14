# Prime Number Generator (Sieves Algorithm)

## SETUP:
1. Set `$s1` to be the start address for your data (MARS has it set to `0x10010000`)
2. `$a0` is the largest number you with to find out primality. Defaults to 30.
3. `$a1` is the word-size of your CPU (should leave as is unless you are doing a 64bit)

## Expected Results:

The Sieves Generator marks all non-prime word-locations starting at `$s0` with a 1, and all prime word-locations with a 0. Obviously, the word-locations index from 0.

For instance, setting `$a0` to 5 (calculating primes up to 5), the memory locations starting at `$s0` should be:
`1 1 0 0 1 0`

## Memory Layout Requirements

The memory should be set to all 0's, with at `n+1` word's where `n` is the largest number you wish to see is prime or not. So, for n=5, there should be 6 word memory spaces all set to 0.

## Instructions to run

No additonal MIPS instructions required to run the algorithm. But, all required instructions are used so ensure that they are implemented correctly.

