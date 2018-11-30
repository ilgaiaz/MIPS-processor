--Michele Gaiarin
--University project for the development of a MIPS
--Last macro block of 4_block_CPU
--components : data memory and pipeline4
--4_block_CPU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memoryOperations is
  port(
    clk              : in std_logic;
    resetPipeline4   : in std_logic;
    
    memToRegIn4      : in std_logic;
    regWriteIn4      : in std_logic;
    jumpIn4          : in std_logic;
    branchIn4        : in std_logic;        
    memReadIn4       : in std_logic;
    memWriteIn4      : in std_logic;
    jumpAddrIn4      : in std_logic_vector(31 downto 0);
    branchAddrIn4    : in std_logic_vector(31 downto 0);
    zeroFlagIn4      : in std_logic;
    aluResultIn4     : in std_logic_vector(31 downto 0);
    readData2In4     : in std_logic_vector(31 downto 0);
    registerIn4      : in std_logic_vector(4 downto 0);
    --OUTPUT
    memToRegOut4     : out std_logic;
    regWriteOut4     : out std_logic;
    jumpOut4         : out std_logic;
    branchOut4       : out std_logic;
    jumpAddrOut4     : out std_logic_vector(31 downto 0);
    branchAddrOut4   : out std_logic_vector(31 downto 0);
    aluResultOut4    : out std_logic_vector(31 downto 0);
    readDataMemOut4  : out std_logic_vector(31 downto 0);
    registerOut4     : out std_logic_vector(4 downto 0)
  );
end memoryOperations;

architecture behavioral of memoryOperations is
  
  component pipeline4 is
    port (
      clk               : in std_logic;
      resetPL          : in std_logic;
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
  end component;
  
  component dataMemory is
    port(
      memWriteFlag  : in std_logic;
      memReadFlag   : in std_logic;
      address       : in std_logic_vector(31 downto 0);
      writeData     : in std_logic_vector(31 downto 0);
      readData      : out std_logic_vector(31 downto 0)
    );
  end component;
  
  signal sDataFromMem : std_logic_vector(31 downto 0);
  
  begin
    
    jumpOut4        <= jumpIn4;
    jumpAddrOut4    <= jumpAddrIn4;
    branchOut4      <= branchIn4 and zeroFlagIn4;
    branchAddrOut4  <= branchAddrIn4;
    
    dataMemoryOp : dataMemory
      port map (memWriteFlag  => memWriteIn4, memReadFlag => memReadIn4, address => aluResultIn4, writeData => readData2In4, readData => sDataFromMem);
    
    storeReg : pipeline4
      port map (clk => clk, resetPL => resetPipeline4, storedMemToReg => memToRegIn4, storedRegWrite => regWriteIn4, storedReadDataMem => sDataFromMem,
        storedAluResult => aluResultIn4, storedWriteReg => registerIn4, getMemToReg => memToRegOut4, getRegWrite => regWriteOut4, getReadDataMem => readDataMemOut4, getAluResult => aluResultOut4, getWriteReg => registerOut4);
        
end behavioral;
