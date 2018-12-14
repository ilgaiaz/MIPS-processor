--Michele Gaiarin
--University project for the development of a MIPS
--Control unit : read the opcode then set the muxs/components flag and bus signal for alu control unit 
--2_control.vhd

--Definition of the opcode and control flag

--OPCODE -> ALUop
--TYPE        OPCODE  ALUop
--Load        010000  000
--Store       010001  000
--R-type      000000  001
--AddI        001000  010
--AndI        001001  011
--OrI         001010  100
--BEQ         0001XX  101
--jump        00001X  XXX

--OPCODE    FUNCT     FUNCT(bit)  OPRTN     regDst    memToReg    regW    memR    memW    branch   aluSrc    jump

--Arithmetic
--000000    add       110000      0000        1         0         1        0       0        0       0         0   
--000000    sub       110001      0001        1         0         1        0       0        0       0         0
--001000    addI      XXXXXX      0000        0         0         1        0       0        0       1         0

--Data transfer
--010000    load      XXXXXX      0000        0         1         1        1       0        0       1         0
--010001    store     XXXXXX      0000        X         X         0        0       1        0       1         0

--Logical
--000000    and       110010      0010        1         0         1        0       0        0       0         0
--000000    or        110011      0011        1         0         1        0       0        0       0         0
--000000    nor       110100      0100        1         0         1        0       0        0       0         0
--001001    andI      XXXXXX      0010        0         0         1        0       0        0       1         0
--001010    orI       XXXXXX      0011        0         0         1        0       0        0       1         0
--000000    shL       110101      0101        1         0         1        0       0        0       1         0
--000000    shR       110110      0110        1         0         1        0       0        0       1         0

--cond. branch
--000100    beq       XXXXXX      0001       X         X         0        0       0        1       0         0


--uncod. jump
--000010    jump      XXXXXX      XXXX        X         X         0        0       0        X       0         1


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity control is
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
end control;

architecture behavioral of control is
  
  begin
    --Set controls flag based on opcode
    muxControlLines : process(opcode, functField)
      begin
        category : case opcode is
          --R-type
          when "000000" =>
            regDst    <= '1';
            jump      <= '0';
            branch    <= '0';
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '0';
            regWrite  <= '1';
            --Check function field and set the alu operation to do
            if (unsigned(functField) = "110000") then      --add
              aluSrc  <= '0';
              aluOperation  <= "0000";
            elsif (unsigned(functField) = "110001") then  --sub
              aluSrc  <= '0';
              aluOperation  <= "0001";
            elsif (unsigned(functField) = "110010") then  --and
              aluSrc  <= '0';
              aluOperation  <= "0010";
            elsif (unsigned(functField) = "110011") then  --or
              aluSrc  <= '0';
              aluOperation  <= "0011";
            elsif (unsigned(functField) = "110100") then  --nor
              aluSrc  <= '0';
              aluOperation  <= "0100";
            elsif (unsigned(functField) = "110101") then  --shft left
              aluSrc  <= '1';
              aluOperation  <= "0101";
            elsif (unsigned(functField) = "110110") then  --shft right
              aluSrc  <= '1';
              aluOperation  <= "0110";
            elsif (unsigned(functField) = "000000") then  --pipeline reset case
              regWrite  <= '0';                           --Avoid bad write on register
              aluOperation  <= "1111";
            else
              regWrite  <= '0';
              aluOperation  <= "1111";
            end if;
            
          --Data transfer "01XXXX"
          when "010000" =>     --Load
            regDst        <= '0';
            jump          <= '0';
            branch        <= '0';
            memRead       <= '1';
            memWrite      <= '0';
            memToReg      <= '1';
            aluSrc        <= '1';
            regWrite      <= '1';
            aluOperation  <= "0000";
                
          when "010001" =>     --Store
            regDst        <= '0';  --X?
            jump          <= '0';
            branch        <= '0';
            memRead       <= '0';
            memWrite      <= '1';
            memToReg      <= '1';  --X?
            aluSrc        <= '1';
            regWrite      <= '0';
            aluOperation  <= "0000";
            
          --Immediate "001XXX"
          when "001000" =>        --add immediate
            regDst    <= '0';
            jump      <= '0';
            branch    <= '0';
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '0';
            aluSrc    <= '1';
            regWrite  <= '1';
            aluOperation  <= "0000"; 
          
          when "001001" =>        --and immediate
            regDst    <= '0';
            jump      <= '0';
            branch    <= '0';
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '0';
            aluSrc    <= '1';
            regWrite  <= '1';
            aluOperation  <= "0010"; 
          
          when "001010" =>        --or immediate
            regDst    <= '0';
            jump      <= '0';
            branch    <= '0';
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '0';
            aluSrc    <= '1';
            regWrite  <= '1';
            aluOperation  <= "0011"; 
          
          --Conditional branch "0001XX"
          when "000100" =>      --BEQ
            regDst    <= '0';   --X?
            jump      <= '0';
            branch    <= '1';
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '1';   --X?
            aluSrc    <= '0';
            regWrite  <= '0';
            aluOperation  <= "0001";
            
          --Unconditional jump "00001X"
          when "000010" => 
            regDst    <= '0';   --X?
            jump      <= '1';
            branch    <= '0';   --X?
            memRead   <= '0';
            memWrite  <= '0';
            memToReg  <= '1';   --X?
            aluSrc    <= '0';   --X?
            regWrite  <= '0';
            aluOperation  <= "XXXX";
          
          when others => null; 
          
        end case category;
    end process muxControlLines;
    
end behavioral;
