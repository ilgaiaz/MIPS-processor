--Michele Gaiarin
--University project for the development of a MIPS
--Mux : select the output signal between 2 input signal
--0_mux.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity mux is
  generic(
    dimension : natural := 32
  );  
  port(
    controlSignal  : in std_logic;
    signal1        : in std_logic_vector(dimension - 1 downto 0);
    signal2        : in std_logic_vector(dimension - 1 downto 0);
    selectedSignal : out std_logic_vector(dimension - 1 downto 0)
  );
end mux;

architecture behavioral of mux is
  begin
  
    selectedSignal <= signal1 when (controlSignal = '0') else signal2;
    
end behavioral;
