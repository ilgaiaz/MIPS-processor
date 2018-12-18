library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_completeCPU is
end tb_completeCPU;

--TESTING 
--Arith/Logical (non immediate)
--Instruction   opcode    RS      RT      RD      funct        
--    ADD       000000  00000   00001   00010    110000  
--    AND       000000  00101   00110   00111    110010          
--    OR        000000  01000   01001   01010    110011 
--    NOR       000000  01011   01100   01101    110100
--    SUB       000000  00010   00011   00100    110001
--note: sub is in the end because is used the add's RD register for data reading 
--      but if i use it too early the data is't propagate corectly

--Arith/Logical (immediate)
--Instruction   opcode    RS      RT           value
--    ADDI      001000  00001   11100     0000000000000011
--    ANDI      001001  00101   11101     0000000010101010
--    ORI       001010  00101   11110     1100110110110011

--Shift Left/Right
--Instruction   opcode    RS      RT      RD    sftAmout   funct     
--   Left       000000  00000   11111   10000    00001     110101
--   Right      000000  00001   11111   10001    00010     110110

--Memory operation
--Instruction   opcode    RS      RT            value  
--    Store     010001  00000   00000     0000000000000100
--    Load      010000  00000   00000     0000000000000100

--Branch
--Opcode   RS     RT         address
--000100  00010  00011   0000000000000001    Jump to instr 1 and make control with reg: 00001 (1)

--Jump
--Opcode             address
--000100    00000000000000000000000001   Jump to instr 1 (AND)


architecture tb_behavioral of tb_completeCPU is

  component completeCPU is
    port(
      clock     : in std_logic;
      rstPC     : in std_logic;
      rstPL     : in std_logic
    );
  end component;
  
  signal clk, resetPC, resetPL : std_logic;

  begin
  
  UUT : completeCPU
    port map (clock => clk, rstPC => resetPC, rstPL => resetPL);
    
  clock_p : process
      variable clk_tmp : std_logic :='0';
      begin
        clk_tmp := not clk_tmp;
        clk <= clk_tmp;
        wait for 50 ns;
    end process;
  
  reset : process
    begin
      resetPC <= '1';
      resetPL <= '1';
      wait for 1 ns;
      
      resetPC <= '0';
      resetPL <= '0';
      wait;
  end process;
  
end tb_behavioral;

  
