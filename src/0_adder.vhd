--Michele Gaiarin
--University project for the development of a MIPS
--Adder : sum two vector of generic dim
--0_adder.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity adder is
  generic(
    dimension : natural := 32
  );  
  port(
    addend1  : in std_logic_vector(dimension - 1 downto 0);
    addend2  : in std_logic_vector(dimension - 1 downto 0);
    sum      : out std_logic_vector(dimension - 1 downto 0)
  );
end adder;

architecture behavioral of adder is
  begin
    sum <= addend1 + addend2;
end behavioral;
