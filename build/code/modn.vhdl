library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_lib.all;


entity modn is
	generic(
		n:integer := 4
	);
	port (
		clk : in std_logic;
		inc: in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		overflow: out std_logic;
		output : out std_logic_vector(f_log2(n)-1 downto 0) 
	);
end modn;

architecture arch of modn is
	signal count: std_logic_vector(f_log2(n)-1 downto 0);
	signal overflow_buffer: std_logic;
begin
	output <= count;
	overflow <= overflow_buffer;
counter:process(clk, inc) begin
if(clk'event and clk = '1')then	

	if(reset = '1') then
		overflow_buffer <= '0';
		count <= (others=>'0');
	else
	if(inc = '1') then
		if(enable = '1')   then
			if(count < std_logic_vector(to_unsigned(n-1,count'length))) then
				overflow_buffer <= '0';
				count <= std_logic_vector(unsigned(count) + 1);
			else
				overflow_buffer <= '1';
				count <= (others=>'0');
			end if;
		end if;
				end if;
	end if;

if(overflow_buffer = '1')then
overflow_buffer <= '0';
end if;
	
end if;
end process;

end arch;
