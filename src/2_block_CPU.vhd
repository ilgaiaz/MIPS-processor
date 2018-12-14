--Michele Gaiarin
--University project for the development of a MIPS
--Second macro block of CPU.
--Components : registers, sign Extend, control unit and pipeline2
--2_block_CPU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instructionPartition is
  port(
    --pipeline signal
    clk                 : in std_logic;
    resetPipeline2      : in std_logic;
    --Registers external input
    regWriteFlagIn2     : in std_logic;
    regWriteIn2         : in std_logic_vector(4 downto 0);
    dataWriteIn2        : in std_logic_vector(31 downto 0);
    --Instruction to compute
    instructionIn2      : in std_logic_vector(31 downto 0);
    --Program counter + 4
    programCounterIn2   : in std_logic_vector(31 downto 0);
    --Cotrol unit signal
    memToRegOut2        : out std_logic;
    regWriteOut2        : out std_logic;
    jumpOut2            : out std_logic;
    branchOut2          : out std_logic;        
    memReadOut2         : out std_logic;
    memWriteOut2        : out std_logic;
    regDstOut2          : out std_logic;
    aluSrcOut2          : out std_logic;
    aluOpOut2           : out std_logic_vector(3 downto 0);
    --Various datas get from instruction
    jumpAddrOut2        : out std_logic_vector(31 downto 0);
    programCounterOut2  : out std_logic_vector(31 downto 0);
    readData1Out2       : out std_logic_vector(31 downto 0);
    readData2Out2       : out std_logic_vector(31 downto 0);
    extendedSignalOut2  : out std_logic_vector(31 downto 0);
    registerRTOut2      : out std_logic_vector(4 downto 0);
    registerRDOut2      : out std_logic_vector(4 downto 0)
  );
end instructionPartition;

architecture behavioral of instructionPartition is
  
  component control is
    port(
      opcode        : in std_logic_vector(5 downto 0);
      functField    : in std_logic_vector(5 downto 0);
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
  
  component shifterLeft is
    generic(
      inputDim     : natural := 32;
      outputDim    : natural := 32;
      bitToShift   : natural := 2 
    );  
    port(
      inputV   : in std_logic_vector(inputDim - 1 downto 0);
      outputV  : out std_logic_vector(outputDim - 1 downto 0)
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
      storedWriteRegRT  : in std_logic_vector(4 downto 0);
      storedWriteRegRD  : in std_logic_vector(4 downto 0);
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
  end component;
  
  signal sExtendResult : std_logic_vector(31 downto 0);
  signal sReadData1, sReadData2 : std_logic_vector(31 downto 0);
  signal sShiftedInstr : std_logic_vector(27 downto 0);
  signal sJumpAddr : std_logic_vector(31 downto 0);
  --Cotrol output signal
  signal sRegDst, sJump, sBranch, sMemRead, sMemWrite, sMemToReg, sAluSrc, sRegWrite : std_logic := '0';
  signal sAluOp : std_logic_vector(3 downto 0);
  signal prova : std_logic := '1';
  
  begin
    
    extendSignal : signExtend
      port map (input_signal => instructionIn2(15 downto 0), output_signal => sExtendResult);
    
    readRegister : registers
      port map (writeRegisterFlag => regWriteFlagIn2, readRegister1 => instructionIn2(25 downto 21), readRegister2 => instructionIn2(20 downto 16), 
      writeRegister => regWriteIn2, writeData => dataWriteIn2, readData1 => sReadData1, readData2 => sReadData2);
  
    setControlFlag : control
      port map (opcode => instructionIn2(31 downto 26), functField => instructionIn2(5 downto 0), regDst => sRegDst, jump => sJump, branch => sBranch, 
        memRead => sMemRead, memWrite => sMemWrite, memToReg => sMemToReg, aluSrc => sAluSrc, regWrite => sRegWrite, aluOperation => sAluOp);
    
    shiftInstruction : shifterLeft
      generic map (26, 28, 2)
      port map (inputV => instructionIn2(25 downto 0), outputV => sShiftedInstr);
      
    sJumpAddr <= programCounterIn2(31 downto 28) & sShiftedInstr;
    
    pipeline : pipeline2 
      port map (clk => clk, resetPL => resetPipeline2, storedMemToReg => sMemToReg, storedRegWrite => sRegWrite, storedJump => sJump, storedBranch => sBranch,
        storedMemRead => sMemRead, storedMemWrite => sMemWrite, storedRegDst => sRegDst, storedAluSrc => sAluSrc, storedAluOp => sAluOp, 
        storedJumpAddr => sJumpAddr, storedPC => programCounterIn2, storedReadData1 => sReadData1, storedReadData2 => sReadData2, storedSignExt => sExtendResult, 
        storedWriteRegRT => instructionIn2(20 downto 16) , storedWriteRegRD => instructionIn2(15 downto 11), getMemToReg => memToRegOut2, 
        getRegWrite =>regWriteOut2, getJump => jumpOut2, getBranch => branchOut2, getMemRead => memReadOut2, getMemWrite => memWriteOut2, getRegDst => regDstOut2, getAluSrc => aluSrcOut2, getAluOp => aluOpOut2, getJumpAddr => jumpAddrOut2 ,getPC => programCounterOut2, getReadData1 => readData1Out2, 
        getReadData2 => readData2Out2, getSignExt => extendedSignalOut2, getWriteRegRT => registerRTOut2, getWriteRegRD => registerRDOut2);
        
end behavioral;
