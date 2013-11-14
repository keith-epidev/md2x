library ieee;
use ieee.std_logic_1164.all;

entity N_add_sub is
	generic(
		size:integer := 8
	);
	port (
		A,B : in std_logic_vector(size-1 downto 0); 
		Cin : in std_logic;
		mode : in std_logic;
		sum : out std_logic_vector(size-1 downto 0);
		Cout : out std_logic 
	);
end N_add_sub;

architecture arch of N_add_sub is
	signal C : std_logic_vector (size downto 0);
	signal A_val, B_val: std_logic_vector (size-1 downto 0);	
	
	component FULL_ADDER 
	port (
		A,B,Cin : in std_logic;
		sum,CARRY : out std_logic
	);
	end component;



begin

-- mode
-- 0 add
-- 1 sub

C(0) <= 	Cin when mode = '0' else
			'1' when Cin = '0' else
			'0';


A_val <= A;

B_val <= B when mode='0' else
	 not B;


Cout <= C(size);


GEN_REG: for I in 0 to size-1 generate
		UX : FULL_ADDER port map (A_val(I), B_val(I), C(I), sum(I), C(I+1));
end generate GEN_REG;

end arch;
