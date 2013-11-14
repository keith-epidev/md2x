library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_lib.all;


entity mux is
	generic(
		size:integer := 4
	);
	port (
		s : in std_logic_vector(f_log2(size)-1 downto 0); 
		input : in std_logic_vector(size-1 downto 0); 
		output : out std_logic
	);
end mux;

architecture arch of mux is
	signal y : std_logic_vector(size-1 downto 0);
	signal z : std_logic_vector( ( size * (s'length+1)  ) -1 downto 0);
	
	
	component or_gate is
		generic ( 
			width:integer := 2
		);
		port (
			input : in std_logic_vector(width-1 downto 0); 
			output : out std_logic
		);
	end component;
	
	component and_gate is
		generic ( 
			width:integer := 2
		);
		port (
			input : in std_logic_vector(width-1 downto 0); 
			output : out std_logic
		);
	end component;

begin


	ORX: or_gate generic map(width=>size) port map(y,output); 

	
GEN_REG: 
   for I in 0 to size-1 generate
		z(I*(s'length+1)+s'length downto I*(s'length+1)) <= (s  xor std_logic_vector(to_unsigned(I,s'length))) & input(size-1-I);
      REGX : and_gate generic map(width=> s'length+1  ) port map ( z(I*(s'length+1)+s'length downto I*(s'length+1))   ,y(I) );
end generate ;

end arch;
