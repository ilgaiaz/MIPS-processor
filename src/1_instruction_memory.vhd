--Michele Gaiarin
--University project for the development of a MIPS
--Instruction memory : get the address of of the instruction and put out the instruction readed 
--from the memory
--1_instruction_memory.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity instruction_memory is
  port (
    instrMemIn       :  in std_logic_vector (31 downto 0); --Program Counter input
    instruction   :  out std_logic_vector (31 downto 0) --create an output that pass the instruction read from instruction.txt
  );
end instruction_memory;

architecture behavioral of instruction_memory is
  
  
  file fileInstructions     : text;                         --define varibale for open instruction file
  type vector_of_mem is array(0 to 1024) of std_logic_vector (31 downto 0);
  signal instructionStored  : vector_of_mem := (others => (others => '0'));
    
  begin
    
      loadMemory : process
        --needed varables for reading from file
        variable readedLine         : line;
        variable vInstruction       : bit_vector (31 downto 0) := (others => '0');
        variable instructionIndex   : integer := 0;
      
      --Create a function for load the file with instruction
      --and save them into instructionStored signal 
        begin
          file_open(fileInstructions, "1_instruction.dat",  read_mode);
      
          while not endfile(fileInstructions) loop
          
            readline(fileInstructions, readedLine);                                  --Read the file line and save into readedLine (type: line)
            read(readedLine, vInstruction);                                          --Save the line into a vInstruction (type: std_logic_vector)
            instructionStored(instructionIndex) <= to_stdlogicvector(vInstruction);  --Save vInstruction into the signal instructionStored (type: vector_of_mem)
            instructionIndex := instructionIndex + 1;                                --update the file index line
            
          end loop;
          file_close(fileInstructions);
          wait;
      end process loadMemory;
      --Don't consider last 2 bit so it's like we jump of 4 and all the system still works
      instruction <= instructionStored(to_integer(unsigned(instrMemIn(31 downto 2)))); --save into the signal instruction the selected instruction
      
end behavioral;
