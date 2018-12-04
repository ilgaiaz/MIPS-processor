--Michele Gaiarin
--University project for the development of a MIPS
--4_pipeline.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pipeline4 is
  port (
    clk               : in std_logic;
    resetPL           : in std_logic;
    --Store control unit signal
    --WB:
    storedMemToReg    : in std_logic;
    storedRegWrite    : in std_logic;
    --Store data read from memory
    storedReadDataMem : in std_logic_vector(31 downto 0);
    --ALU
    storedAluResult   : in std_logic_vector(31 downto 0);
    --Stored write registers
    storedWriteReg    : in std_logic_vector(4 downto 0);
    --OUTPUT
    getMemToReg       : out std_logic;
    getRegWrite       : out std_logic;
    getReadDataMem    : out std_logic_vector(31 downto 0);
    getAluResult      : out std_logic_vector(31 downto 0);
    getWriteReg       : out std_logic_vector(4 downto 0)
    
  );
end pipeline4;

architecture behavioral of pipeline4 is
  
  signal sMemToReg, sRegWrite : std_logic;
  signal sAluresult, sReadDataMem : std_logic_vector(31 downto 0);
  signal sWriteReg : std_logic_vector(4 downto 0);
  
  begin
    
    loadAddress : process(clk, resetPL)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPL = '1' then 
            sMemToReg     <= '0';
            sRegWrite     <= '0';
            sReadDataMem  <= "00000000000000000000000000000000";
            sAluResult    <= "00000000000000000000000000000000";
            sWriteReg     <= "00000";
          elsif clk = '1' and clk'event then 
            sMemToReg     <= storedMemToReg;
            sRegWrite     <= storedRegWrite;
            sReadDataMem  <= storedReadDataMem;
            sAluResult    <= storedAluResult;
            sWriteReg     <= storedWriteReg;
          end if;
    end process loadAddress;
    
    getMemToReg     <= sMemToReg;
    getRegWrite     <= sRegWrite;
    getReadDataMem  <= sReadDataMem;
    getAluResult    <= sAluResult;
    getWriteReg     <= sWriteReg;
    
end behavioral;
