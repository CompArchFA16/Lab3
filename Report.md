# Written Description

# Block Diagram

![Circuit](https://github.com/tj-kim/Lab3/blob/master/images/circuit.jpg "Circuit")

Above is our block diagram for the single cycle CPU that does the following instructions listed below in the “RTL of Instruction” Set section. The control signals that separate the different instructions are also explained in the section below. All the instructions are from the MIPS ISA.

It is important to understand that a full clock cycle happens so that the negative edge of the clock occurs, and then the positive edge within one cycle. Our CPU operates on such a clock cycle because the PC register is written to on the negative edge, and our Register File and Data Memory are written to on the positive edge. 

In the starting parts of the clock cycle, the negative edge will update the PC to PC + 4. Now, a new PC will address the Instruction Memory, which will input a new ‘OP’ and ‘funct’ into the decoder, which will output new control signals. These control signals control the cpu to run different commands.

It is important to note that we have a total of 4 ALUs in this block diagram, but the only one we control is the one that takes the control signal, takes in R[rs], R[rt], and the sign extended immediate. All instances below in the RTL explanation where we refer to the ALU, we are referring to that single ALU.

# RTL of Instruction Set

We accounted for the following MIPS instructions, which have been arranged by instruction type.

## I-Type Commands
### Branch on not equal (BNE)
#### RTL
if (R[rs] =! R[rt])
  PC = PC + 4 + BranchAddr

#### Notable Control Signals
* ALU_input = 1
* ALUcommand = `SUB
* Branch = 1;

#### Description
In the BNE command, we want to input R[rt] into the ALU, so we will set the ALU_input control signal to 1, to select R[rt]. The ALU command will be set as ‘SUB’ so that we can compare the values of R[rs] and R[rt], as if the two values are equal, we will be returned a ‘1’ in the zero flag of the ALU. The ‘Branch’ Control Signal will be raised and ANDed with the inverse of the zero flag. This signal is used as one of the mux control signals that determine which value PC will be updated to. If ‘Branch’ & ‘zero-flag inverse’ is 1, it means the two values put into the big ALU were not equal, and the cpu will branch. 

### Load word (LW)
#### RTL
R[rt] = Mem[R[rs] + SignExtImm]

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 0
* ALU_input = 0
* ALUcommand = `ADD
* Reg_Data_Src_Mux = 0

#### Description
In the LW command, we want to read R[rs] from the register file, and add it with the sign extended immediate. The ALU_input command is set to ‘0’ so that we select the sign extend immediate. The ALUcommand is set to `ADD so that we add R[rs] and the immediate. The WrEn_Reg is set to 1 so that we can write word into the register file, and WrAddr_Reg_Mux command is 0, to select ‘rt’ as the address we want to write to. Reg_Data_Src_Mux command as ‘00’ indicates that the data that we will write to the register file is the data out of the data memory.

### Store word (SW)
#### RTL
Mem[R[rs] + SignExtImm] = R[rt]

#### Notable Control Signals
* WrEn_DM = 1
* ALU_input = 0
* ALUcommand = `ADD

#### Description
The SW command has WrEN_DM set as 1 so that we write to the data memory. Moreover, the ALU_input is set to 0 so that the mux selects the sign extended immediate to go into the ALU with R[rs]. The sum of R[rs] and the immediate goes into the data memory as its address, and the R[rt] data is written as the data into the data memory.

### Bitwise XOR immediate (XORI)
#### RTL
R[rt] = R[rs] XOR SignExtImm

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 0
* ALU_input = 0
* ALUcommand = `XOR
* Reg_Data_Src_Mux = 1

#### Description
The XORI command writes to the register at address ‘rt’ the output from the ALU where an immediate and R[rs] is xor’ed. Therefore, the WrEn_Reg is 1 to write to the register. The WrAddr_Reg_Mux signal chooses rt to be the address to be written to in the Reg file. The ALU_input is 0, which selects the extended sign immediate to go into the ALU instead of R[rt]. ALUcommand is XOR. Reg_Data_Src_Mux is 1, that picks the output from the ALU to be DataIn to the register file.

## J-Type Commands
### Jump (J)
#### RTL
PC = JumpAddr

#### Notable Control Signals
* JumpR = 0
* Jump_Target_Mux = 1
* Branch = 0

#### Description
The 3 control signals above select the sign extended immediate of the Jump target address to be written in the PC. This will allow the PC to go to the jump address for the next cycle.

### Jump and link (JAL)
#### RTL
R[31] = PC + 4; PC = JumpAddr

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 2'd2
* Reg_Data_Src_Mux = 2'd2
* JumpR = 0
* Jump_Target_Mux = 1
* Branch = 0

#### Description
The WrEN_Reg is ‘1’ as we will write to the register file. The WrAddr_Reg_Mux has its mux select control signal set to ‘2’ as we want to write to address 31, as we want to store the PC+4 information in that register. Reg_Data_Src_Mux will be set to 2, as that holds the value PC+4, which is what we want to write to the register file. The last 3 control signals select what we want to write to the PC for the next cycle. Since this is a jump command, the 3 control signals allow us to write the Jump target to the PC.

## R-Type Commands
### Jump register (JR)
#### RTL
PC = R[rs]

#### Notable Control Signals
* JumpR = 1
* Jump_Target_Mux = 1
* Branch = 0

#### Description
This R-type instruction is very similar to the J-type jump command. We pass the address ‘rs’ into the register file and and using the 3 control signals that selects the next PC value, we select the output from the register file to write to the PC.

### Add (ADD)
#### RTL
R[rd] = R[rs] + R[rt]

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 1
* ALU_input = 1
* ALUcommand = `ADD
* Reg_Data_Src_Mux = 1

#### Description
This R-type instruction adds the output of R[rs] and R[rt]. This is done by ALU_input = 1. ALUcommand is ADD. WrAdder_Reg_Mux is 1, which makes rd the address we will write to into the register file. Reg_Data_Src_Mux chooses the output of the ALU as what we will write into the Reg File.

### Subtract (SUB)
#### RTL
R[rd] = R[rs] - R[rt]

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 1
* ALU_input = 1
* ALUcommand = `SUB
* Reg_Data_Src_Mux = 1

#### Description
This R-type instruction adds the output of R[rs] and R[rt]. This is done by ALU_input = 1. ALUcommand is SUB. WrAdder_Reg_Mux is 1, which makes rd the address we will write to into the register file. Reg_Data_Src_Mux chooses the output of the ALU as what we will write into the Reg File.

### Set less than (SLT)
#### RTL
R[rd] = (R[rs] < R[rt]) ? 1 : 0

#### Notable Control Signals
* WrEn_Reg = 1
* WrAddr_Reg_Mux = 1
* ALU_input = 1
* ALUcommand = `SLT
* Reg_Data_Src_Mux = 1

#### Description
This R-type instruction adds the output of R[rs] and R[rt]. This is done by ALU_input = 1. ALUcommand is SLT. WrAdder_Reg_Mux is 1, which makes rd the address we will write to into the register file. Reg_Data_Src_Mux chooses the output of the ALU as what we will write into the Reg File.

# Test Plan
For our tests, we made sure to test each individual MIPS instruction, by first writing the code in assembly and converting that to a hexadecimal format, which can then be passed to Icarus Verilog. The memory is assumed to be configured such that the program counter begins at 0x0000 and maxes at 0x0FFC. The data memory in the CPU may occupy addresses at or above 0x1000. Since we built a single-cycle CPU, we did not have to worry about data or structural hazards, since each instruction will run to completion before the next one begins.

1. Jump and link test - Jumps to the subroutine “basic” and saves the return address to the 31st register in the register file
  * jal basic
2. Basic submodule - Tests basic functions that use data that lives in the register file or in memory data
  1. XORI tests - Saves values to several registers by taking the XOR of the zero register and some immediate value.
    * xori $t0, $zero, 0x0 (Reg[t0] = 0x0)
    * xori $t1, $zero, 0x4 (Reg[t1] = 0x4)
    * xori $t2, $zero, 0x8 (Reg[t2] = 0x8)
    * xori $t3, $zero, 0x10 (Reg[t3] = 0x10)
    * xori $t4, $zero, 0x20 (Reg[t4] = 0x20)
  2. Store word tests - Saves values from the register file to data memory, using the value stored in the registers from the XORI tests as both the address and the input data. The immediate is also set to 0x1000, which is the lowest usable address for data memory.
    * sw $t0, 0x1000($t0) (Mem[Reg[t0] + 0x1000] = Reg[t0])
    * sw $t1, 0x1000($t1) (Mem[Reg[t1] + 0x1000] = Reg[t1])
    * sw $t2, 0x1000($t2) (Mem[Reg[t2] + 0x1000] = Reg[t2])
    * sw $t3, 0x1000($t3) (Mem[Reg[t3] + 0x1000] = Reg[t3])
    * sw $t4, 0x1000($t4) (Mem[Reg[t4] + 0x1000] = Reg[t4])
  3. Load word tests - Loads values from data memory to the register file, by referencing the values that were saved in the 
    * lw $t4, 0x1000($t0) (Reg[t4] = Mem[Reg[t0] + 0x1000])
    * lw $t3, 0x1000($t1) (Reg[t3] = Mem[Reg[t1] + 0x1000])
  4. Add tests - Adds values stored in two registers and saves the result to a new register
    * add $t8, $t0, $t1 (Reg[t8] = Reg[t0] + Reg[t1])
    * add $t9, $t2, $t3 (Reg[t9] = Reg[t2] + Reg[t3])
  5. Subtract tests = Subtract values stored in two registers and saves the result to a new register
    * sub $t8, $t4, $t3 (Reg[t8] = Reg[t4] - Reg[t3])
    * sub $t9, $t2, $t3 (Reg[t9] = Reg[t2] - Reg[t3])
  6. SLT tests - Saves whether or not Reg[rs] < Reg[rt] into a new register
    * slt $t8, $t0, $t1 (Reg[t8] = Reg[t0] < Reg[t1])
    * slt $t9, $t1, $t0 (Reg[t9] = Reg[t1] < Reg[t0])
3. Jump register test - Jumps to the return register that was set when the first JAL command jumped to the “basic” submodule
  * jr $ra
4. Jump tests - Jumps to different targets to make sure that the CPU is getting to the correct addresses. The correct sequence of jumps should be target1 → target3 → target4 → target2 → target5.
  * target1: j target3
  * target2: j target5
  * target3: j target4
  * target4: j target2
  * target5:
5. Branch if not equal test - Branches to the end of the program if Reg[t0] != Reg[t1]. This inequality is guaranteed, since $t0 and $t1 were set to hold different values during the “basic” submodule
  * bne $t0, $t2, end

# Test Results
Our CPU successfully ran through the sequence that we passed as input into the instruction memory module. Our waveform analysis of the instruction memory signals shows that the correct order of instructions is being fetched as the PC changes. The PC’s current value is represented by the address wires, and the current instruction is represented by the dataOut wires. 

![Instructions](https://github.com/tj-kim/Lab3/blob/master/images/instructions.png "Instructions")

## Jump and Link
R[31] = PC + 4; PC = JumpAddr

The first instruction is JAL, which sets the program counter to the location of the “basic” submodule. The current value of the program counter + 4 is saved to the return address (register 31) before the jump actually occurs. The blue signals refer to the WB phase.

![Jump and Link](https://github.com/tj-kim/Lab3/blob/master/images/jal.png "Jump and Link")

## XOR Immediate
R[rt] = R[rs] XOR SignExtImm

In the “basic” submodule, the first set of commands tests the XORI function. These results are then written to the registers, such that $t0 = 0x00, $t1 = 0x04, $t2 = 0x08, $t3 = 0x10, and $t4 = 0x20. The yellow signals refer to the ID phase, and the blue signals refer to the WB phase

![XORI](https://github.com/tj-kim/Lab3/blob/master/images/xori.png "XORI")

## Store Word
Mem[R[rs] + SignExtImm] = R[rt]

The values that were recently written to registers by XORI are then saved to data memory using the same values as the addresses. The quantity R[rs] is shifted by an offset value of 0x1000, as specified by our memory configuration, before being passed to the data memory module as the address pin. The orange signals refer to the MEM phase.

![Stpre Word](https://github.com/tj-kim/Lab3/blob/master/images/storeword.png "Store Word")

## Load Word
R[rt] = Mem[R[rs] + SignExtImm]

The data that was just saved to memory is retrieved and then saved back into registers $t3 and $t4. At this point, the registers should have the following data: $t0 = 0x00, $t1 = 0x04, $t2 = 0x08, $t3 = 0x04, $t4 = 0x00. The orange signals refer to the MEM phase, and the blue signals refer to the WB phase.

![Load Word](https://github.com/tj-kim/Lab3/blob/master/images/loadword.png "Load Word")

## Add
R[rd] = R[rs] + R[rt]

The addition operation is tested by calculating the following: $t8 = $t0 + $t1 and $t9 = $t2 + $t3. The yellow wires refer to the ID phase, the red wires refer to the EX phase, and the blue wires refer to the WB phase.

![Add](https://github.com/tj-kim/Lab3/blob/master/images/add.png "Add")

## Subtract
R[rd] = R[rs] - R[rt]

Similarly to the addition tests, the subtraction tests calculate the following: $t8 = $t4 - $t3 and $t9 = $t2 - $t3.

![Subtract](https://github.com/tj-kim/Lab3/blob/master/images/sub.png "Subtract")

## Set If Less Than
R[rd] = (R[rs] < R[rt]) ? 1 : 0

The SLT tests then calculate the following: $t8 = $t0 < $t1 ? 1 : 0 and $t9 = $t1 < $t0 ? 1 : 0. The first operation returns true, since $t0 is less than $t1, and the opposite is true if the operands are flipped.

![SLT](https://github.com/tj-kim/Lab3/blob/master/images/slt.png "SLT")

## Jump Register
PC = R[rs]

Once the “basic” submodule has finished, the program counter is set to the return address via the jump register command. The yellow signals refer to the ID phase.

![Jump Register](https://github.com/tj-kim/Lab3/blob/master/images/jr.png "Jump Register")

## Jump
PC = JumpAddr

The next set of instructions jump to different jump instructions. At the end of each IF phase, the immediate is pulled from the instruction, sign extended, and then passed to the program counter.

![Jump](https://github.com/tj-kim/Lab3/blob/master/images/jump.png "Jump")

## Branch On Not Equal
if (R[rs] =! R[rt])
    PC = PC + 4 + BranchAddr

The final instruction is the BNE, which checks if $t0 is not equal to $t2. Due to the previous instructions, this should be true, and the program counter should be set to the branch address. This takes the CPU to the end of the program.

![BNE](https://github.com/tj-kim/Lab3/blob/master/images/bne.png "BNE")

# Performance and Area Analysis

# Work Plan Reflection
For the work plan, we were were generally successful in following the work plan. We were able to create a working, complete design of a single-cycle CPU that could perform most of the instructions required by the deadline. Jump and link took a little longer, but we were able to finish it by a day within our deadline, which we consider relatively successful. We did not meet with a ninja for a mid-point check-in, but we felt that we learned enough in class during discussions to not need a check-in. We successfully made unit tests and created the entire cpu by our deadline of Nov 14. After that, we spent most of our time debugging the cpu and making sure the system worked. 
