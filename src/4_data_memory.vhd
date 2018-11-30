--Michele Gaiarin
--University project for the development of a MIPS
--Data memory : write/read from/to memory
--4_data_memory.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataMemory is
  port(
    memWriteFlag  : in std_logic;
    memReadFlag   : in std_logic;
    address       : in std_logic_vector(31 downto 0);
    writeData     : in std_logic_vector(31 downto 0);
    readData      : out std_logic_vector(31 downto 0)
  );
end dataMemory;

architecture behavioral of dataMemory is

  type vector_of_mem is array(0 to 31) of std_logic_vector (31 downto 0);
  signal memory : vector_of_mem := ( 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000"
    );
  begin
  
  readData <= memory(to_integer(unsigned(address(6 downto 2)))) when memReadFlag = '1' else X"00000000";
  
  operationToDo : process(memWriteFlag, address, writeData)
    begin
      if memWriteFlag = '1' then
        memory(to_integer(unsigned(address(6 downto 2)))) <= writeData;
      end if;
  end process operationToDo;
end behavioral;
