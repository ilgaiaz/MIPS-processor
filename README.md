# MIPS-processor

The purpose of this project is to develop a MIPS processor with pipeline in VHDL.

## Usage (linux users)

1. First of all, install:
    - GHDL an open-source simulator for the VHDL language
    - GTKWave a wave viewer for Linux based on GTK+
2. Run
    ```
    mkdir work wave
    chmod +x *.sh # make the file executable
    ./analysis.sh namefile.vhd # do it for all the files
    ./run.sh 5_complete_CPU_tb.vhd tb_completeCPU # start the simulation
    ```
3. Try the CPU, change the instructions (look at the instruction set below) in `instruction.dat` and change value into registers and data memory for new results.

## How the simulation works

At the first clock cycle, there is a reset of the program counter and all the pipelines.  The instruction memory loads the instruction from the file `instruction.dat` and nothing happens.
From the next clock cycle, the program counter goes to the next instruction or jumps to a particular instruction if there is a jump or a branch operation. The instruction memory gets the instruction to do (depends on the program counter).
Any instruction needs four clock cycles to be executed because it is a pipeline architecture.

The program continues running until the instructions end (then it restarts from the first one) or the simulation ends (simulation time could be modified in `run.sh`).
Data into instruction_memory, registers, and data memory components persists until it is overwritten or the simulation ends.

## Instructions

Implemented instructions:  

|Instruction        |Type  |Meaning                           |
|:-----------------:|:----:|:--------------------------------:|
|Add                |R     |$s1 = $s2 + $s3                   |
|Subtract           |R     |$s1 = $s2 - $s3                   |
|Add immediate      |I     |$s1 = $s2 + 100                   |
|Load Word          |I     |$s1 = Memory[$s2 + 100]           |
|Store Word         |I     |Memory[$s1 + 100] = $s1           |
|And                |R     |$s1 = $s2 & $s3                   |
|Or                 |R     |$s1 = $s2 | $s3                   |
|Nor                |R     |$s1 = ~($s2 | $s3)                |
|And immediate      |I     |$s1 = $s2 & 100                   |
|Or immediate       |I     |$s1 = $s2 | 100                   |
|Shift left logical |R     |$s1 = $s2 << 10                   |
|Shift right logical|R     |$s1 = $s2 >> 10                   |
|Branch on equal    |I     |If ($s1 == $s2) go to PC + 4 + 100|
|Jump               |J     |Go to 10000                       |


## Codes

These are the codes format for all the possible operations.  

#### R-Type

Field opcode has 6 bit.  
Fields register RS, RT, RD has 5 bit.  
Field shift amount has 5 bit.  
Field function has 6 bit.  

|Instruction|opcode |RS   |RT   |RD   |Shamt        | funct|
|:---------:|:-----:|:---:|:---:|:---:|:-----------:|:----:|
|Add        |000000 |Any  |Any  |Any  |don’t care   |110000|
|Subtract   |000000 |Any  |Any  |Any  |don’t care   |110001|
|And        |000000 |Any  |Any  |Any  |don’t care   |110010|
|Or         |000000 |Any  |Any  |Any  |don’t care   |110011|
|Nor        |000000 |Any  |Any  |Any  |don’t care   |110100|
|Shft Left  |000000 |Any  |Any  |Any  |shift amount |110101|
|Shft Right |000000 |Any  |Any  |Any  |shift amount |110110|

#### I-type

Field opcode has 6 bit.  
Fields register RS, RT has 5 bit.  
Field address/value has 16 bit.  

|Instruction  |Opcode|RS   |RT   |Address/value|
|:-----------:|:----:|:---:|:---:|:-----------:|
|Add immediate|001000|Any  |Any  |Value to add |
|And immediate|001001|Any  |Any  |Value to and |
|Or immediate |001010|Any  |Any  |Value to or  |
|Load         |010000|Any  |Any  |Address      |
|Store        |010001|Any  |Any  |Address      |
|Branch       |000100|Any  |Any  |Address      |

#### J-type

Field opcode has 6 bit.  
Field address has 26 bit.

|Instruction|Opcode|Address      |
|:---------:|:----:|:-----------:|
|Jump       |000100|Address to go|


## Components

Here all the components in details

* 0_adder:
    - Sum two numbers of 32 bits, used for branching.
* 0_mux:
    - Select two signals of variable dimension.
* 0_shifter_left:
    - Shift a signal of variable dimension of a variable number of bits.
* 1_program_counter:
    - Component for pointing to the next instruction.
* 1_instruction_memory:
    - Component that gets the instruction to be executed.
* 1_instuction.dat:
    - File with some possible instructions to do.
* 1_pipeline:
    - First pipeline where to save data to get next clock cycle.
* 1_block_CPU:
    - First macro block used to contains components before the first pipeline.
* 2_control:
    - Component that gets the instruction and sets all flags in the CPU.
* 2_registers:
    - Components of 32x32-bit register
* 2_pipeline:
    - Second pipeline.
* 2_sign_extended:
    - Components that extends 16 bit of instructions needed for I type instr.
* 2_block_CPU:
    - Second Macro block that contains component between first and second pipeline
* 3_ALU:
    - Arithmetical logical unit used for computing all operations.
* 3_pipeline:
    - Third pipeline.
* 3_block_CPU:
    - Third macro block with all components between second and third pipeline
* 4_data_memory:
    - Memory where it is possible to store and load operations.
* 4_pipeline:
    - Last pipeline.
* 4_block_CPU:
    - Last macro block with all components between third and fourth pipeline
* 5_complete_CPU:
    - The complete CPU where there are all the macro block.
* 5_complete_CPU_tb:
    - Test bench for testing the CPU.
