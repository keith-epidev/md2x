library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_lib.all;

entity multi_mux is
	generic(
		size:integer := 4;
		width:integer := 2
	);
	port (
		s : in std_logic_vector(f_log2(size)-1 downto 0); 
		input : in std_logic_vector((width*size)-1 downto 0); 
		output : out std_logic_vector(width-1 downto 0)
	);
end multi_mux;

architecture arch of multi_mux is
	signal z : std_logic_vector( size*width-1 downto 0 );



component mux is
	generic(
		size:integer := 4
	);
	port (
		s : in std_logic_vector(f_log2(size)-1 downto 0); 
		input : in std_logic_vector(size-1 downto 0); 
		output : out std_logic
	);
end component;
	
	
begin


	GEN_SWIZ1: 
		for I in 0 to width-1 generate
		GEN_SWIZ2: 
			for J in 0 to size-1 generate
			z( I*size + J  ) <= input(J*width + I );
		end generate GEN_SWIZ2;
	end generate GEN_SWIZ1;
	
	GEN_MUX: 
		for I in 0 to width-1 generate
		 MUX_X : mux generic map(size=>size)  port map ( s, z( I*size +(size-1) downto I*size  )  , output(I) ); -- width not correct
	end generate ;

end arch;
