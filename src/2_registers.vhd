--Michele Gaiarin
--University project for the development of a MIPS
--Registers : read/write from/to register data 
--2_registers.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity registers is
  port(
    writeRegisterFlag : in  std_logic;
    readRegister1     : in  std_logic_vector(4 downto 0);
    readRegister2     : in  std_logic_vector(4 downto 0);
    writeRegister     : in  std_logic_vector(4 downto 0);
    writeData         : in  std_logic_vector(31 downto 0);
    readData1         : out std_logic_vector(31 downto 0);
    readData2         : out std_logic_vector(31 downto 0)
  );
end registers;

architecture behavioral of registers is
  
  type vector_of_mem is array(0 to 31) of std_logic_vector (31 downto 0); --Define the memory of the registers (5 bit for readRegister : 128 byte register memory)
  signal registersMem: vector_of_mem := (                                 --Initialize the value in the registers 
        "00000000000000000000000000000010", --0 
        "00000000000000000000000000000001", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000011", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000011111", --5
        "00000000000000000000000000001010",
        "00000000000000000000000000000000",
        "00000000000000000000000000011010",
        "00000000000000000000000000001101",
        "00000000000000000000000000000000", --10
        "00000000000000000000000000001101",
        "00000000000000000000000000011100",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --15
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --20
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --25
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --30
        "00000000000000000000000000000000"
    );
    
    begin
    
      
      readData1 <= registersMem(to_integer(unsigned(readRegister1)));      --Select the register value (using the address saved in readRegister1/2)
      readData2 <= registersMem(to_integer(unsigned(readRegister2)));      --and put it in the output port readData1/2 

      updateMemory : process(writeRegisterFlag, writeData)
        begin
          checkWrite : if (writeRegisterFlag = '1') then                    --Check if clock is rising and writeRegister flag is set to 1
            registersMem(to_integer(unsigned(writeRegister))) <= writeData; --Update the registersMem with writeData in writeRegister (if the if is true)
          end if checkWrite;
      end process updateMemory;
      
end behavioral;
