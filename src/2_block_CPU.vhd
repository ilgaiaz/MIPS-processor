--Michele Gaiarin
--University project for the development of a MIPS
--Sign extend : extend logic vector from 16 to 32 bit
--2_block_CPU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instructionPartition is
  port(
    --pipeline signal
    clk               : in std_logic;
    resetPipeline2     : in std_logic;
    --Registers external input
    regWriteFlag      : in std_logic;
    regWrite          : in std_logic_vector(4 downto 0);
    dataWrite         : in std_logic_vector(31 downto 0);
    --Instruction to compute
    instruction       : in std_logic_vector(31 downto 0);
    --Program counter + 4
    programCounterIn  : in std_logic_vector(31 downto 0);
    --Cotrol unit signal
    memToRegOut2      : out std_logic;
    regWriteOut2      : out std_logic;
    jumpOut2          : out std_logic;
    branchOut2        : out std_logic;        
    memReadOut2       : out std_logic;
    memWriteOut2      : out std_logic;
    regDstOut2        : out std_logic;
    aluSrcOut2        : out std_logic;
    aluOpOut2         : out std_logic_vector(3 downto 0);
    --Various datas get from instruction
    programCounterOut2: out std_logic_vector(31 downto 0);
    readData1Out      : out std_logic_vector(31 downto 0);
    readData2Out      : out std_logic_vector(31 downto 0);
    extendedSignal    : out std_logic_vector(31 downto 0);
    registerRD        : out std_logic_vector(4 downto 0);
    registerRT        : out std_logic_vector(4 downto 0)
  );
end instructionPartition;

architecture behavioral of instructionPartition is
  
  component control is
    port(
      opcode        : in std_logic_vector(5 downto 0);
      functField   : in std_logic_vector(5 downto 0);
      regDst        : out std_logic;
      jump          : out std_logic;
      branch        : out std_logic;
      memRead       : out std_logic;
      memWrite      : out std_logic;
      memToReg      : out std_logic;
      aluSrc        : out std_logic;
      regWrite      : out std_logic;
      aluOperation  : out std_logic_vector (3 downto 0)
    );
  end component;
  
  component registers is
    port(
      writeRegisterFlag : in  std_logic;
      readRegister1     : in  std_logic_vector(4 downto 0);
      readRegister2     : in  std_logic_vector(4 downto 0);
      writeRegister     : in  std_logic_vector(4 downto 0);
      writeData         : in  std_logic_vector(31 downto 0);
      readData1         : out std_logic_vector(31 downto 0);
      readData2         : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component signExtend is
    port(
      input_signal  : in std_logic_vector(15 downto 0);
      output_signal : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component pipeline2 is
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
  end component;
  
  signal sExtendResult : std_logic_vector(31 downto 0);
  signal sReadData1, sReadData2 : std_logic_vector(31 downto 0);
  --Cotrol output signal
  signal sRegDst, sJump, sBranch, sMemRead, sMemWrite, sMemToReg, sAluSrc, sRegWrite : std_logic;
  signal sAluOp : std_logic_vector(3 downto 0);
  
  begin
    extendSignal : signExtend
      port map (input_signal => instruction(15 downto 0), output_signal => sExtendResult);
    
    readRegister : registers
      port map (writeRegisterFlag => regWriteFlag, readRegister1 => instruction(25 downto 21), readRegister2 => instruction(20 downto 16), 
      writeRegister => regWrite, writeData => dataWrite, readData1 => sReadData1, readData2 => sReadData2);
  
    setControlFlag : control
      port map (opcode => instruction(31 downto 26), functField => instruction(5 downto 0), regDst => sRegDst, jump => sJump, branch => sBranch, 
        memRead => sMemRead, memWrite => sMemWrite, memToReg => sMemToReg, aluSrc => sAluSrc, regWrite => sRegWrite, aluOperation => sAluOp);
        
    storeData : pipeline2 
      port map (clk => clk, resetPL => resetPipeline2, storedMemToReg => sMemToReg, storedRegWrite => sRegWrite, storedJump => sJump, storedBranch => sBranch,
        storedMemRead => sMemRead, storedMemWrite => sMemWrite, storedRegDst => sRegDst, storedAluSrc => sAluSrc, storedAluOp => sAluOp, 
        storedPC => programCounterIn, storedReadData1 => sReadData1, storedReadData2 => sReadData2, storedSignExt => sExtendResult, 
        storedWriteReg1 => instruction(20 downto 16) , storedWriteReg2 => instruction(15 downto 11), getMemToReg => memToRegOut2, getRegWrite => regWriteOut2,
        getJump => jumpOut2, getBranch => branchOut2, getMemRead => memReadOut2, getMemWrite => memWriteOut2, getRegDst => regDstOut2, getAluSrc => aluSrcOut2,
        getAluOp => aluOpOut2, getPC => programCounterOut2, getReadData1 => readData1Out, getReadData2 =>readData2Out, getSignExt => extendedSignal, 
        getWriteReg1 => registerRD, getWriteReg2 => registerRT);
        
end behavioral;
