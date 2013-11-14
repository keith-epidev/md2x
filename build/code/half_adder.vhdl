library ieee;
use ieee.std_logic_1164.all;

entity HALF_ADDER is
	port (
		A,B : in std_logic; 
		SUM,CARRY : out std_logic
	);
end HALF_ADDER;

architecture arch of HALF_ADDER is
begin
	SUM <= A XOR B;
	CARRY <= A AND B;
end arch;
