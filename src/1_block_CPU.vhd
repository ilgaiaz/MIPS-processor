--Michele Gaiarin
--University project for the development of a MIPS
--Instruction_fetch : sub component of CPU (PC + instruction memory + adder (+4) + 2 x Mux)
--Mux components : select branch and jump signal if it's the operation to do. 
--1_instruction_fetch.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_fetch is
  port(
    --PC signal
    clk               : in std_logic;
    resetProgCounter  : in std_logic;
    --Pipeline signal
    resetPipeline     : in std_logic;
    --Branch mux signal
    muxBranchControl  : in std_logic;
    muxBranchExtIn    : in std_logic_vector(31 downto 0);
    --Jump mux signal
    muxJumpControl    : in std_logic;
    muxJumpExtIn      : in std_logic_vector(31 downto 0);
    --Output
    pcOut             : out std_logic_vector(31 downto 0);
    instructionOut    : out std_logic_vector(31 downto 0)
  );
end instruction_fetch;

architecture behavioral of instruction_fetch is

  component program_counter is
    port (
      clk            : in std_logic;
      resetPC        : in std_logic;
      nextAddress    : in std_logic_vector(31 downto 0);
      currentAddress : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component instruction_memory is
    port (
      instrMemIn    :  in std_logic_vector (31 downto 0); --Program Counter input
      instruction   :  out std_logic_vector (31 downto 0) --create an output that pass the instruction read from instruction.txt
    );
  end component;
  
  component adder is
    generic(
      dimension : natural := 32
    );  
    port(
      addend1   : in std_logic_vector(dimension - 1 downto 0);
      addend2   : in std_logic_vector(dimension - 1 downto 0);
      sum       : out std_logic_vector(dimension - 1 downto 0)
    );
  end component;
  
  component pipeline1 is
    port (
      clk               : in std_logic;
      resetPL1          : in std_logic;
      storedPC          : in std_logic_vector(31 downto 0);
      storedInstruction : in std_logic_vector(31 downto 0);
      getPC             : out std_logic_vector(31 downto 0);
      getInstruction    : out std_logic_vector(31 downto 0)
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
  
  signal pcIn         : std_logic_vector(31 downto 0);
  signal sOutPC       : std_logic_vector(31 downto 0);
  signal sPlusFour    : std_logic_vector(31 downto 0);
  signal sAddResult   : std_logic_vector(31 downto 0);
  signal sStoreInstr  : std_logic_vector(31 downto 0);
  signal sMuxBOut     : std_logic_vector(31 downto 0);
  
  begin
    
    sPlusFour <= "00000000000000000000000000000100";
    
    branchMux : mux
      generic map (32)
      port map (controlSignal => muxBranchControl, signal1 => sAddResult, signal2 => muxBranchExtIn, selectedSignal => sMuxBOut);
    
    jumpMux : mux
      generic map (32)
      port map (controlSignal => muxJumpControl, signal1 => sMuxBOut, signal2 => muxJumpExtIn, selectedSignal => pcIn);
      
    programCounter : program_counter
      port map (clk => clk, resetPC => resetProgCounter , nextAddress => pcIn, currentAddress => sOutPC);
    
    sum : adder
      generic map (32)
      port map (addend1 => sOutPC, addend2 => sPlusFour, sum => sAddResult);
    
    get_memory : instruction_memory
      port map (instrMemIn => sOutPC, instruction => sStoreInstr);
    
    storeData : pipeline1
      port map (clk => clk, resetPL1 => resetPipeline, storedPC => sAddResult, storedInstruction => sStoreInstr, getPC => pcOut, getinstruction => instructionOut);
end behavioral;
