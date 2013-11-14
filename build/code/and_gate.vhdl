library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity and_gate is
	generic ( 
		width:integer := 2
	);
	port (
		input : in std_logic_vector(width-1 downto 0); 
		output : out std_logic
	);
end and_gate;

architecture arch of and_gate is
begin
	output <= and_reduce(input);
end arch;
