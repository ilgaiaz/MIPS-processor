--Michele Gaiarin
--University project for the development of a MIPS
--Final design of MIPS pipeline
--5_complete_CPU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity completeCPU is
  port(
    clock : in std_logic;
    rstPC : in std_logic;
    rstPL : in std_logic
    );
end completeCPU;

architecture behavioral of completeCPU is

  component instructionFetch is
    port(
      clk                 : in std_logic;
      resetProgCounter    : in std_logic;
      resetPipeline1      : in std_logic;
      muxBranchControlIn1 : in std_logic;
      muxBranchExtIn1     : in std_logic_vector(31 downto 0);
      muxJumpControlIn1   : in std_logic;
      muxJumpExtIn1       : in std_logic_vector(31 downto 0);
      pcOut1              : out std_logic_vector(31 downto 0);
      instructionOut1     : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component instructionPartition is
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
  end component;
  
  component dataElaboration is
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
      jumpAddrIn3       : in std_logic_vector(31 downto 0);
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
      jumpAddrOut3      : out std_logic_vector(31 downto 0);
      branchAddrOut3    : out std_logic_vector(31 downto 0);
      zeroFlagOut3      : out std_logic;
      aluResultOut3     : out std_logic_vector(31 downto 0);
      readData2Out3     : out std_logic_vector(31 downto 0);
      registerOut3      : out std_logic_vector(4 downto 0)
    );
  end component;
  
  component memoryOperations is
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
  
  --Block 1 in / Block 4 out
  signal sBranchToFetch, sJumpToFetch : std_logic;
  signal sBranchAdrrToFetch, sJumpAddrToFetch : std_logic_vector(31 downto 0);
  --Block 2 In / Block 1 out
  signal sPcToPartition, sInstructionToPartition : std_logic_vector(31 downto 0);
  --Block 2 in / Block 4 out
  signal sRegWriteFlagToFetch : std_logic;
  signal sWriteRegToFetch : std_logic_vector(4 downto 0);
  --Block 2 in / Mux out
  signal sDataWriteToFetch : std_logic_vector(31 downto 0);
  --Block 3 in / Block 2 out
    --Control signal
  signal sMemToRegToElab, sRegWriteToElab, sJumpToElab, sBranchToElab   : std_logic;
  signal sMemReadToElab, sMemWriteToElab, sRegDstToElab, sAluSrcToElab  : std_logic;
  signal sAluOpToElab : std_logic_vector(3 downto 0);
    --Various Data
  signal sJumpAddrToElab, sProgramCounterToElab, sReadData1ToElab : std_logic_vector(31 downto 0);
  signal sReadData2ToElab, sExtdSignToElab : std_logic_vector(31 downto 0);
  signal sRegRtToElab, sRegRdToElab : std_logic_vector(4 downto 0);
  --Block 4 in / Block 3 out
    --Control
  signal sMemToRegToMemOp, sRegWriteToMemOp, sJumpToMemOp  : std_logic; 
  signal sBranchToMemOp, sMemReadToMemOp, sMemWriteToMemOp, sZeroFlagToMemOp : std_logic;
    --Varios Data
  signal sJumpAddrToMemOp, sBranchAdrrToMemOp : std_logic_vector(31 downto 0);
  signal sReadData2ToMemOp, sAluResultToMemOp : std_logic_vector(31 downto 0);
  signal sWriteRegToMemOp : std_logic_vector(4 downto 0);
  --Mux in / Block 4 out
  signal sMemToRegToMux : std_logic;
  signal sReadDataMemToMux, sAluResultToMux : std_logic_vector(31 downto 0);
  
  begin
  
    fetching : instructionFetch
      port map (clk => clock, resetProgCounter => rstPC, resetPipeline1 => rstPL, muxBranchControlIn1 => sBranchToFetch, muxBranchExtIn1 => sBranchAdrrToFetch,
        muxJumpControlIn1 => sJumpToFetch, muxJumpExtIn1 => sJumpAddrToFetch, pcOut1 => sPcToPartition, instructionOut1 => sInstructionToPartition);
    
    instrPartition : instructionPartition
      port map (clk => clock, resetPipeline2 => rstPL, regWriteFlagIn2 => sRegWriteFlagToFetch, regWriteIn2 => sWriteRegToFetch, dataWriteIn2 => sDataWriteToFetch,
        instructionIn2 => sInstructionToPartition, programCounterIn2 => sPcToPartition, memToRegOut2 => sMemToRegToElab, regWriteOut2 => sRegWriteToElab,
        jumpOut2 => sJumpToElab, branchOut2 => sBranchToElab, memReadOut2 => sMemReadToElab, memWriteOut2 => sMemWriteToElab, regDstOut2 => sRegDstToElab,
        aluSrcOut2 => sAluSrcToElab, aluOpOut2 => sAluOpToElab, jumpAddrOut2 => sJumpAddrToElab, programCounterOut2 => sProgramCounterToElab, 
        readData1Out2 => sReadData1ToElab, readData2Out2 => sReadData2ToElab, extendedSignalOut2 => sExtdSignToElab, registerRTOut2 => sRegRtToElab,
        registerRDOut2 => sRegRdToElab);
        
    elaboration : dataElaboration
      port map (clk => clock, resetPipeline3 => rstPL, memToRegIn3 => sMemToRegToElab, regWriteIn3 => sRegWriteToElab,
        jumpIn3 => sJumpToElab, branchIn3 => sBranchToElab, memReadIn3 => sMemReadToElab, memWriteIn3 => sMemWriteToElab, regDstIn3 => sRegDstToElab,
        aluSrcIn3 => sAluSrcToElab, aluOpIn3 => sAluOpToElab, jumpAddrIn3 => sJumpAddrToElab, programCounterIn3 => sProgramCounterToElab, 
        readData1In3 => sReadData1ToElab, readData2In3 => sReadData2ToElab, extendedSignalIn3 => sExtdSignToElab, registerRTIn3 => sRegRtToElab,
        registerRDIn3 => sRegRdToElab, memToRegOut3 => sMemToRegToMemOp, regWriteOut3 => sRegWriteToMemOp, jumpOut3 => sJumpToMemOp, branchOut3 => sBranchToMemOp,
        memReadOut3 => sMemReadToMemOp, memWriteOut3 => sMemWriteToMemOp, jumpAddrOut3 => sJumpAddrToMemOp, branchAddrOut3 => sBranchAdrrToMemOp,
        zeroFlagOut3  => sZeroFlagToMemOp, aluResultOut3 => sAluResultToMemOp, readData2Out3 => sReadData2ToMemOp, registerOut3 => sWriteRegToMemOp);
        
    memOp : memoryOperations
      port map (clk => clock, resetPipeline4 => rstPL, memToRegIn4 => sMemToRegToMemOp, regWriteIn4 => sRegWriteToMemOp, jumpIn4 => sJumpToMemOp, 
      branchIn4 => sBranchToMemOp, memReadIn4 => sMemReadToMemOp, memWriteIn4 => sMemWriteToMemOp, jumpAddrIn4 => sJumpAddrToMemOp, 
      branchAddrIn4 => sBranchAdrrToMemOp, zeroFlagIn4  => sZeroFlagToMemOp, aluResultIn4 => sAluResultToMemOp, readData2In4 => sReadData2ToMemOp, 
      registerIn4 => sWriteRegToMemOp, memToRegOut4 => sMemToRegToMux, regWriteOut4 => sRegWriteFlagToFetch, jumpOut4 => sJumpToFetch, 
      branchOut4 => sBranchToFetch, jumpAddrOut4 => sJumpAddrToFetch, branchAddrOut4 => sBranchAdrrToFetch, aluResultOut4 => sAluResultToMux, 
      readDataMemOut4 => sReadDataMemToMux, registerOut4 => sWriteRegToFetch);
      
    memToRegSelector : mux 
      generic map (32)
      port map (controlSignal => sMemToRegToMux, signal1 => sAluResultToMux, signal2 => sReadDataMemToMux, selectedSignal => sDataWriteToFetch);
    
end behavioral;
