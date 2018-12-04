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
    --Store PC +4 and Jump
    storedJumpAddr  : in std_logic_vector(31 downto 0);
    storedPC        : in std_logic_vector(31 downto 0);
    --Store data from component "registers"
    storedReadData1 : in std_logic_vector(31 downto 0);
    storedReadData2 : in std_logic_vector(31 downto 0);
    --Save the instruction extended
    storedSignExt   : in std_logic_vector(31 downto 0);
    --Stored write registers from "getInstruction"
    --2 type of instruction Rtype or Itype -> save both of them 
    --then control unit select the right one
    storedWriteRegRT : in std_logic_vector(4 downto 0);
    storedWriteRegRD : in std_logic_vector(4 downto 0);
    --OUTPUT
    getMemToReg   : out std_logic;
    getRegWrite   : out std_logic;
    getJump       : out std_logic;
    getBranch     : out std_logic;        
    getMemRead    : out std_logic;
    getMemWrite   : out std_logic;
    getRegDst     : out std_logic;
    getAluSrc     : out std_logic;
    getAluOp      : out std_logic_vector(3 downto 0);
    getJumpAddr   : out std_logic_vector(31 downto 0);
    getPC         : out std_logic_vector(31 downto 0);
    getReadData1  : out std_logic_vector(31 downto 0);
    getReadData2  : out std_logic_vector(31 downto 0);
    getSignExt    : out std_logic_vector(31 downto 0);
    getWriteRegRT : out std_logic_vector(4 downto 0);
    getWriteRegRD : out std_logic_vector(4 downto 0) 
    
  );
end pipeline2;

architecture behavioral of pipeline2 is
  
  signal sMemToReg, sRegWrite, sJump, sBranch, sMemRead, sMemWrite, sRegDst, sAluSrc : std_logic;
  signal sAluOP : std_logic_vector(3 downto 0);
  signal sJumpAddr, sPC, sReadData1, sReadData2, sSignExt : std_logic_vector(31 downto 0);
  signal sWriteRegRT, sWriteRegRD : std_logic_vector(4 downto 0);
  
  begin
    
    loadAddress : process(clk, resetPL)       --Activate the process when the clock change his status 
      begin
        checkClock : 
          if resetPL = '1' then 
            sMemToReg  <= '0';
            sRegWrite  <= '0';
            sJump      <= '0';
            sBranch    <= '0';        
            sMemRead   <= '0';
            sMemWrite  <= '0';
            sRegDst    <= '0';
            sAluSrc    <= '0';
            sAluOp     <= "0000";
            sJumpAddr  <= "00000000000000000000000000000000";
            sPC        <= "00000000000000000000000000000000";
            sReadData1 <= "00000000000000000000000000000000";
            sReadData2 <= "00000000000000000000000000000000";
            sSignExt   <= "00000000000000000000000000000000";
            sWriteRegRT <= "00000";
            sWriteRegRD <= "00000";
          elsif clk = '1' and clk'event then 
            sMemToReg   <= storedMemToReg;
            sRegWrite   <= storedRegWrite;
            sJump       <= storedJump;
            sBranch     <= storedBranch;        
            sMemRead    <= storedMemRead;
            sMemWrite   <= storedMemWrite;
            sRegDst     <= storedRegDst;
            sAluSrc     <= storedAluSrc;
            sAluOp      <= storedAluOp;
            sJumpAddr   <= storedJumpAddr;
            sPC         <= storedPC;
            sReadData1  <= storedReadData1;
            sReadData2  <= storedReadData2;
            sSignExt    <= storedSignExt;
            sWriteRegRT <= storedWriteRegRT;
            sWriteRegRD <= storedWriteRegRD;
          end if;
    end process loadAddress;
    
    getMemToReg   <= sMemToReg;
    getRegWrite   <= sRegWrite;
    getJump       <= sJump;
    getBranch     <= sBranch;        
    getMemRead    <= sMemRead;
    getMemWrite   <= sMemWrite;
    getRegDst     <= sRegDst;
    getAluSrc     <= sAluSrc;
    getAluOp      <= sAluOp;
    getJumpAddr   <= sJumpAddr;
    getPC         <= sPC;
    getReadData1  <= sReadData1;
    getReadData2  <= sReadData2;
    getSignExt    <= sSignExt;
    getWriteRegRT <= sWriteRegRT;
    getWriteRegRD <= sWriteRegRD;
    
end behavioral;
