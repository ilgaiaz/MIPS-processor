--Michele Gaiarin
--University project for the development of a MIPS
--Pipeline2 save all control signal, datas from register unit and all instructions signal.
--2_pipeline.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pipeline2 is
  port (
    clk             : in std_logic;
    resetPL         : in std_logic;
    --Store control unit signal
    --WB:
    storedMemToReg  : in std_logic;
    storedRegWrite  : in std_logic;
    --M:
    storedJump      : in std_logic;
    storedBranch    : in std_logic;        
    storedMemRead   : in std_logic;
    storedMemWrite  : in std_logic;
    --Ex:
    storedRegDst    : in std_logic;
    storedAluSrc    : in std_logic;
    storedAluOp     : in std_logic_vector(3 downto 0);
    --Store PC +4
    storedPC        : in std_logic_vector(31 downto 0);
    --Store data from component "registers"
    storedReadData1 : in std_logic_vector(31 downto 0);
    storedReadData2 : in std_logic_vector(31 downto 0);
    --Save the instruction extended
    storedSignExt   : in std_logic_vector(31 downto 0);
    --Stored write registers from "getInstruction"
    --2 type of instruction Rtype or Itype -> save both of them 
    --then control unit select the right one
    storedWriteReg1 : in std_logic_vector(4 downto 0);
    storedWriteReg2 : in std_logic_vector(4 downto 0);
    --OUTPUT
    getMemToReg  : out std_logic;
    getRegWrite  : out std_logic;
    getJump      : out std_logic;
    getBranch    : out std_logic;        
    getMemRead   : out std_logic;
    getMemWrite  : out std_logic;
    getRegDst    : out std_logic;
    getAluSrc    : out std_logic;
    getAluOp     : out std_logic_vector(3 downto 0);
    getPC        : out std_logic_vector(31 downto 0);
    getReadData1 : out std_logic_vector(31 downto 0);
    getReadData2 : out std_logic_vector(31 downto 0);
    getSignExt   : out std_logic_vector(31 downto 0);
    getWriteReg1 : out std_logic_vector(4 downto 0);
    getWriteReg2 : out std_logic_vector(4 downto 0) 
    
  );
end pipeline2;

architecture behavioral of pipeline2 is
  
  begin
    
    loadAddress : process(clk, resetPL)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPL = '1' then 
            getMemToReg  <= '0';
            getRegWrite  <= '0';
            getJump      <= '0';
            getBranch    <= '0';        
            getMemRead   <= '0';
            getMemWrite  <= '0';
            getRegDst    <= '0';
            getAluSrc    <= '0';
            getAluOp     <= "0000";
            getPC        <= "00000000000000000000000000000000";
            getReadData1 <= "00000000000000000000000000000000";
            getReadData2 <= "00000000000000000000000000000000";
            getSignExt   <= "00000000000000000000000000000000";
            getWriteReg1 <= "00000";
            getWriteReg2 <= "00000";
          elsif clk = '1' and clk'event then 
            getMemToReg  <= storedMemToReg;
            getRegWrite  <= storedRegWrite;
            getJump      <= storedJump;
            getBranch    <= storedBranch;        
            getMemRead   <= storedMemRead;
            getMemWrite  <= storedMemWrite;
            getRegDst    <= storedRegDst;
            getAluSrc    <= storedAluSrc;
            getAluOp     <= storedAluOp;
            getPC        <= storedPC;
            getReadData1 <= storedReadData1;
            getReadData2 <= storedReadData2;
            getSignExt   <= storedSignExt;
            getWriteReg1 <= storedWriteReg1;
            getWriteReg2 <= storedWriteReg2;
          end if;
    end process loadAddress;
    
end behavioral;
