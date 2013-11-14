library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER is
	port (
		A,B,CIN : in std_logic; 
		SUM,CARRY : out std_logic
	);
end FULL_ADDER;

architecture arch of FULL_ADDER is
	signal I1, I2, I3 : std_logic;

	component HALF_ADDER 
	port (
		A,B : in std_logic;
		SUM,CARRY : out std_logic
	);
	end component;

	component OR_GATE 
	port (
		A,B : in std_logic;
		Z : out std_logic
	);
	end component;

begin
	u1:HALF_ADDER port map(A,B,I1,I2);
	u2:HALF_ADDER port map(I1,CIN,SUM,I3);
	u3:OR_GATE port map(I3,I2,CARRY);
end arch;
