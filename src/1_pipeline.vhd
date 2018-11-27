--Michele Gaiarin
--University project for the development of a MIPS
--Pipeline1 : first pipeline in the mips. Store PC+4 and getInstruction
--1_pipeline.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pipeline1 is
  port (
    clk               : in std_logic;
    resetPL1          : in std_logic;
    storedPC          : in std_logic_vector(31 downto 0);
    storedInstruction : in std_logic_vector(31 downto 0);
    --OUTPUT
    getPC             : out std_logic_vector(31 downto 0);
    getInstruction    : out std_logic_vector(31 downto 0)
  );
end pipeline1;

architecture behavioral of pipeline1 is
  
  begin
    
    loadAddress : process(clk, resetPL1)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPL1 = '1' then 
            getInstruction  <= "00000000000000000000000000000000";
            getPC           <= "00000000000000000000000000000000";
          elsif clk = '1' and clk'event then 
            getInstruction  <= storedInstruction;
            getPC           <= storedPC;
          end if;
    end process loadAddress;
    
end behavioral;
