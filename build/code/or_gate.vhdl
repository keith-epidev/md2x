library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity or_gate is
	generic ( 
		width:integer := 2
	);
	port (
		input : in std_logic_vector(width-1 downto 0); 
		output : out std_logic
	);
end or_gate;

architecture arch of or_gate is
begin
	output <= or_reduce(input);
end arch;
