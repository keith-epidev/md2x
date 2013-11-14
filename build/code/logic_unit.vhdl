library ieee;
use ieee.std_logic_1164.all;



entity logic_unit is
	port (
		A,B : in std_logic_vector(7 downto 0); 
		Cin : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		F : out std_logic_vector(7 downto 0)
	);
end logic_unit;

architecture arch of logic_unit is

signal F_buffer: std_logic_vector(7 downto 0);

begin
process(mode,A,B)
begin
	case(mode) is
		when "00" =>
			F_buffer <= A;
		when "01" =>
			F_buffer <= A or B;
		when "10" =>
			F_buffer <= A xor B;
		when others =>
			F_buffer <= A and B;
		
	end case;
end process;


		
with Cin select 
F <= not F_buffer  when '1',
		F_buffer when others;	
	


end arch;
