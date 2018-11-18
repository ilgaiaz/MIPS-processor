--Michele Gaiarin
--University project for the development of a MIPS
--Shifter : shift a signal by generic value
--0_shifter_left.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity shifter_left is
  generic(
    inputDim     : natural := 32;
    outputDim    : natural := 32;
    bitToShift   : natural := 2 
  );  
  port(
    inputV   : in std_logic_vector(inputDim - 1 downto 0);
    outputV  : out std_logic_vector(outputDim - 1 downto 0)
  );
end shifter_left;

architecture behavioral of shifter_left is

  signal resize_input : std_logic_vector(outputDim - 1 downto 0);
  
  begin
    --If the input have different lenght
    resize_input <= std_logic_vector(resize(unsigned(inputV), outputDim));
    outputV <= std_logic_vector(shift_left(signed(resize_input), bitToShift));
      
end behavioral;
