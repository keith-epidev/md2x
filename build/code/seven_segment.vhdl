library ieee;
use ieee.std_logic_1164.all;

entity seven_segment is
	port (
		clk : in std_logic;
		val : in std_logic_vector(3 downto 0); 
		led : out std_logic_vector(6 downto 0);
		mode: in std_logic
	);
end seven_segment;



architecture arch of seven_segment is
	
	component pulser is
	generic(
		delay:integer := 500000
	);
	port(
		 clk: in std_logic;
		 enable: in std_logic;
		 output: out std_logic
	);
end component;

	
	
	signal spinner : std_logic_vector(5 downto 0) := "111110";
	signal spin_spinner: std_logic;
	
	begin


	p1: pulser 	generic map(delay=>5000000) port map(clk,'1',spin_spinner);

spinner_pro: process(spin_spinner)
begin		
	if(spin_spinner'event and spin_spinner = '1')then
		if(spinner = "011111")then
		spinner <= "111110";
		else
		spinner <= spinner(4 downto 0) & '1';
		end if;
	end if;		
end process spinner_pro;




disp_pro:	process(clk,val,mode)
		begin
		if(mode = '0') then
			case val is
				when "0001" => led <= "1111001";
				when "0010" => led <= "0100100";
				when "0011" => led <= "0110000";
				when "0100" => led <= "0011001";
				when "0101" => led <= "0010010";
				when "0110" => led <= "0000010";
				when "0111" => led <= "1111000";
				when "1000" => led <= "0000000";
				when "1001" => led <= "0010000";
				when "1010" => led <= "0001000";
				when "1011" => led <= "0000011";
				when "1100" => led <= "1000110";
				when "1101" => led <= "0100001";
				when "1110" => led <= "0000110";
				when "1111" => led <= "0001110";
				when others => led <= "1000000";
			end case;
		else
			if( val = "0001") then
			led <= 	"1000111";
		
			else if ( val = "0010") then
			led <= "0010010";
			else if ( val = "0011") then
			led <= '1'&spinner;
			else
			led <= "1111111";
			end if;
		end if;	
		end if;		
			end if;			
	end process disp_pro;
	
end arch;

