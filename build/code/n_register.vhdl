library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity n_register is
	generic ( 
		width:integer := 8
	);
	port (
		input : in std_logic_vector(width-1 downto 0); 
		output : out std_logic_vector(width-1 downto 0); 
		clk : in std_logic;
		rst : in std_logic
	);
end n_register;

architecture arch of n_register is
	signal data : std_logic_vector(width-1 downto 0);
begin

output <= data;

latch: process (clk,input,rst)
begin
	if (rst = '1')  then
		data <= (others=>'0');
	else if (clk'event and clk = '1') then
		data <= input; 
	end if;
end if;
end process ;

end arch;
