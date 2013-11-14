library ieee;
use ieee.std_logic_1164.all;

entity sr_unit is
	port (
		A : in std_logic_vector(7 downto 0); 
		Cin : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		F : out std_logic_vector(7 downto 0);
		Cout : out std_logic
	);
end sr_unit;

architecture arch of sr_unit is
begin


process(mode,A,Cin) begin
	case(mode) is
		when "00" =>
		--shift left once
			F <= A(6 downto 0) & Cin;
			Cout <= A(7);
		when "01" =>
		--shift right once	
			F <= Cin & A(7 downto 1) ;
			Cout <= A(0);
		when "10" =>
		--rotate left
			Cout <= '0';
			if Cin = '0' then
				--once
				F <= A(6 downto 0) & A(7);
			else
				--double	
				F <= A(5 downto 0) & A(6)  & A(7);
			end if;
		when others =>
		--rotate right
			Cout <= '0';
			if Cin = '0' then
				--once
				F <= A(0) & A(7 downto 1);
			else
				--double
				F <= A(0) & A(1) & A(7 downto 2);
			end if;
	end case;
end process;
end arch;

