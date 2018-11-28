--Michele Gaiarin
--University project for the development of a MIPS
--   
--3_block_CPU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataElaboration is
  port(
    clk               : in std_logic;
    resetPipeline3    : in std_logic;
    --Control signal
    memToRegIn3       : in std_logic;
    regWriteIn3       : in std_logic;
    jumpIn3           : in std_logic;
    branchIn3         : in std_logic;        
    memReadIn3        : in std_logic;
    memWriteIn3       : in std_logic;
    regDstIn3         : in std_logic;
    aluSrcIn3         : in std_logic;
    aluOpIn3          : in std_logic_vector(3 downto 0);
    --Various datas get from instruction
    programCounterIn3 : in std_logic_vector(31 downto 0);
    readData1In3      : in std_logic_vector(31 downto 0);
    readData2In3      : in std_logic_vector(31 downto 0);
    extendedSignalIn3 : in std_logic_vector(31 downto 0);
    registerRTIn3     : in std_logic_vector(4 downto 0);
    registerRDIn3     : in std_logic_vector(4 downto 0);
    --OUTPUT
    memToRegOut3      : out std_logic;
    regWriteOut3      : out std_logic;
    jumpOut3          : out std_logic;
    branchOut3        : out std_logic;        
    memReadOut3       : out std_logic;
    memWriteOut3      : out std_logic;
    branchAddrOut3    : out std_logic_vector(31 downto 0);
    zeroFlagOut3      : out std_logic;
    aluResultOut3     : out std_logic_vector(31 downto 0);
    readData2Out3     : out std_logic_vector(31 downto 0);
    registerOut3      : out std_logic_vector(4 downto 0)
  );
end dataElaboration;

architecture behavioral of dataElaboration is
  
  component alu is
    port(
      input1            : in  std_logic_vector(31 downto 0);
      input2            : in  std_logic_vector(31 downto 0);
      aluControlInput   : in  std_logic_vector(3 downto 0); 
      zeroControl       : out std_logic;
      aluResult         : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component pipeline3 is
    port (
      clk             : in std_logic;
      resetPL2        : in std_logic;
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
      getBranchAddr : out std_logic_vector(31 downto 0);
      getZero       : out std_logic;
      getAluResult  : out std_logic_vector(31 downto 0);
      getReadData2  : out std_logic_vector(31 downto 0);
      getWriteReg   : out std_logic_vector(4 downto 0)
    );
  end component;
  
  component adder is
    generic(
      dimension : natural := 32
    );  
    port(
      addend1  : in std_logic_vector(dimension - 1 downto 0);
      addend2  : in std_logic_vector(dimension - 1 downto 0);
      sum      : out std_logic_vector(dimension - 1 downto 0)
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
  
  component mux is
    generic(
      dimension : natural := 32
    );  
    port(
      controlSignal  : in std_logic;
      signal1        : in std_logic_vector(dimension - 1 downto 0);
      signal2        : in std_logic_vector(dimension - 1 downto 0);
      selectedSignal : out std_logic_vector(dimension - 1 downto 0)
    );
  end component;
  
  signal sZero : std_logic;
  signal sSelectedWriteReg : std_logic_vector(4 downto 0);
  signal sAluData2 , sAluResult : std_logic_vector(31 downto 0);
  signal sExtendedSignal, sBranchAddrRes : std_logic_vector(31 downto 0);
  
  begin
  
    selectRegister : mux
      generic map (5)
      port map (controlSignal => regDstIn3, signal1 => registerRTIn3, signal2 => registerRDIn3, selectedSignal => sSelectedWriteReg );
      
    selectSecondData : mux 
      generic map (32)
      port map (controlSignal => aluSrcIn3, signal1 => readData2In3, signal2 => extendedSignalIn3, selectedSignal => sAluData2);

    shiftSignal : shifterLeft
      generic map (32, 32, 2)
      port map (inputV => extendedSignalIn3, outputV => sExtendedSignal);
      
    aluElaboration : alu
      port map (input1 => readData1In3, input2 => sAluData2, aluControlInput => aluOpIn3, zeroControl => sZero, aluResult => sAluResult);
      
    branchAdd : adder
      generic map (32)
      port map (addend1 => programCounterIn3, addend2 => sExtendedSignal, sum => sBranchAddrRes);
      
    pipeline : pipeline3
      port map (clk => clk, resetPL2 => resetPipeline3, storedMemToReg => memToRegIn3, storedRegWrite => regWriteIn3, storedJump => jumpIn3, 
        storedBranch => branchIn3, storedMemRead => memReadIn3, storedMemWrite => memWriteIn3, storedBranchAddr => sBranchAddrRes, storedZero => sZero,
        storedAluResult => sAluResult, storedReadData2 => readData2In3, storedWriteReg => sSelectedWriteReg, getMemToReg => memToRegOut3, 
        getRegWrite => regWriteOut3, getJump => jumpOut3, getBranch => branchOut3, getMemRead => memReadOut3, getMemWrite => memWriteOut3, 
        getBranchAddr => branchAddrOut3, getZero => zeroFlagOut3, getAluResult => aluResultOut3, getReadData2 => readData2Out3, getWriteReg => registerOut3);
      
end behavioral;
