library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_lib.all;

entity pulser is
	generic(
		delay:integer := 500000
	);
	port(
		 clk: in std_logic;
		 enable: in std_logic;
		 output: out std_logic
	);
end pulser;

architecture Behavioral of pulser is
	signal timer: std_logic_vector(f_log2(delay)-1 downto 0);
	signal pulse: std_logic;
begin

output <= pulse;

pulser_signal:process(clk)
begin		
	if(clk'event and clk = '1')then

		if(pulse = '1')then
		pulse <= '0';
		end if;


		if(enable = '1') then
			if(timer < delay -1)then
				timer <= timer + 1;
			else
				pulse <= '1';
				timer <= (others=>'0');
			end if;

		else
			timer <= (others=>'0');
		end if;

	end if;
	

end process;

end Behavioral;

