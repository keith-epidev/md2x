library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use IEEE.math_real.all;

package my_lib is
	
	function f_log2 (x : positive) return natural;
	type int_array is array(0 to 7) of integer;
	
	type hex_array is array(0 to 7) of std_logic_vector(6 downto 0);
	type disp_chars is array(0 to 16*2-1) of std_logic_vector(0 to 7);
end;

package body my_lib is

function f_log2 (x : positive) return natural is
	variable i : natural;
	begin
	i := 0;  
	while (2**i < x) and i < 31 loop
	i := i + 1;
	end loop;
	return i;
end function;

end;
