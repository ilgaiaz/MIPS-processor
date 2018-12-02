--Michele Gaiarin
--University project for the development of a MIPS
--3_pipeline.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pipeline3 is
  port (
    clk             : in std_logic;
    resetPL        : in std_logic;
    --Store control unit signal
    --WB:
    storedMemToReg  : in std_logic;
    storedRegWrite  : in std_logic;
    --M:
    storedJump      : in std_logic;
    storedBranch    : in std_logic;        
    storedMemRead   : in std_logic;
    storedMemWrite  : in std_logic;
    --BranchAddr
    storedJumpAddr  : in std_logic_vector(31 downto 0);
    storedBranchAddr: in std_logic_vector(31 downto 0);
    --ALU 
    storedZero      : in std_logic;
    storedAluResult : in std_logic_vector(31 downto 0);
    --Store data from registers
    storedReadData2 : in std_logic_vector(31 downto 0);
    --Stored write registers
    storedWriteReg  : in std_logic_vector(4 downto 0);
    --OUTPUT
    getMemToReg   : out std_logic;
    getRegWrite   : out std_logic;
    getJump       : out std_logic;
    getBranch     : out std_logic;        
    getMemRead    : out std_logic;
    getMemWrite   : out std_logic;
    getJumpAddr   : out std_logic_vector(31 downto 0);
    getBranchAddr : out std_logic_vector(31 downto 0);
    getZero       : out std_logic;
    getAluResult  : out std_logic_vector(31 downto 0);
    getReadData2  : out std_logic_vector(31 downto 0);
    getWriteReg   : out std_logic_vector(4 downto 0)
  );
end pipeline3;

architecture behavioral of pipeline3 is
  
  signal TestJump : std_logic;
  begin
    
    loadAddress : process(clk, resetPL)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPL = '1' then 
            getMemToReg   <= '0';
            getRegWrite   <= '0';
            getJump       <= '0';
            getBranch     <= '0';        
            getMemRead    <= '0';
            getMemWrite   <= '0';
            getJumpAddr   <= "00000000000000000000000000000000";
            getBranchAddr <= "00000000000000000000000000000000";
            getZero       <= '0'; 
            getAluResult  <= "00000000000000000000000000000000";
            getReadData2  <= "00000000000000000000000000000000";
            getWriteReg   <= "00000";
          elsif clk = '1' and clk'event then
            getMemToReg   <= storedMemToReg;
            getRegWrite   <= storedRegWrite;
            getJump       <= storedJump;
            getBranch     <= storedBranch;        
            getMemRead    <= storedMemRead;
            getMemWrite   <= storedMemWrite;
            getJumpAddr   <= storedJumpAddr;
            getBranchAddr <= storedBranchAddr;
            getZero       <= storedZero;
            getAluResult  <= storedAluResult;
            getReadData2  <= storedReadData2;
            getWriteReg   <= storedWriteReg;
          end if;
    end process loadAddress;
end behavioral;
