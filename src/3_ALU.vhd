--Michele Gaiarin
--University project for the development of a MIPS
--ALU : make logical and arithmetical operations
--3_ALU.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity alu is
  port(
    input1            : in  std_logic_vector(31 downto 0);
    input2            : in  std_logic_vector(31 downto 0);
    aluControlInput   : in  std_logic_vector(3 downto 0); 
    zeroControl       : out std_logic;
    aluResult         : out std_logic_vector(31 downto 0)
  );
end alu;

architecture behavioral of alu is
  
  --Operations set:
    --0000 --add
    --0001 --subtract
    --0010 --and
    --0011 --or
    --0100 --nor
    --0101 --shift left 
    --0110 --shift right
    --1111  --no op
  
  begin
    
    makeOperation : process(input1, input2, aluControlInput)
      
      constant OPERATIONS_LENGTH : integer := 7;
      variable zeroTemp : std_logic_vector(31 downto 0);
      
      begin
      
        zeroControl <= '0';
        case aluControlInput is
          when "0000" => aluResult <= input1 + input2;
          
          when "0001" =>
            aluResult <= input1 - input2;
            zeroTemp := input1 - input2;
            if (signed(zeroTemp) = x"00000000") then
              zeroControl <= '1';
            end if;
          
          when "0010" => aluResult <= input1 and input2;
            
          when "0011" => aluResult <= input1 or input2;
            
          when "0100" => aluResult <= input1 nor input2;
            
          when "0101" => aluResult <= std_logic_vector(shift_left(unsigned(input1),to_integer(unsigned(input2(10 downto 6)))));
            
          when "0110" => aluResult <= std_logic_vector(shift_right(unsigned(input1),to_integer(unsigned(input2(10 downto 6)))));
            
          when "1111" => aluResult <= (others => 'Z');
          
          when others => aluResult <= (others => 'Z');
        end case;
        
    end process makeOperation;
  
end behavioral;
