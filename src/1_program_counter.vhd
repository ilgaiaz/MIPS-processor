--Michele Gaiarin
--University project for the development of a MIPS
--Program counter : get the new instruction to do
--1_program_counter.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity programCounter is
  port (
    clk            : in std_logic;
    resetPC        : in std_logic;
    nextAddress    : in std_logic_vector(31 downto 0);
    currentAddress : out std_logic_vector(31 downto 0)
  );
end programCounter;

architecture behavioral of programCounter is
  
  signal address : std_logic_vector(31 downto 0);
  begin
    
    loadAddress : process(clk, resetPC)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPC = '1' then 
            address <= "00000000000000000000000000000000";
          elsif clk = '1' and clk'event then 
            address <= nextAddress;
          end if;
    end process loadAddress;
    
    currentAddress <= address;
    
end behavioral;
