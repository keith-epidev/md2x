library ieee;
use ieee.std_logic_1164.all;
use work.my_lib.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity keyboard is
	port(
		sys_clk: in std_logic;
		reset: in std_logic;
		PS2C: in std_logic;
		PS2D: in std_logic;
		output: out std_logic_vector(8*3-1 downto 0);
		new_val: out std_logic;
		leds: out std_logic_vector(8 downto 0)
		);
end keyboard;

architecture Behavioral of keyboard is


	type state_type is (wait_start_bit, get_bits, get_parity, wait_stop);
	signal state: state_type;
	signal clk, last_clk, data: std_logic;
	signal PS2C_filter,PS2D_filter: std_logic_vector(7 downto 0);
	signal bit_count: std_logic_vector(3 downto 0);
	
	signal temp : std_logic_vector(7 downto 0);
	signal parity : std_logic;
	signal available : std_logic;
	signal calc_parity: std_logic;
	signal delay_count: std_logic_vector(7 downto 0);
	signal ready : std_logic;
	signal newval : std_logic;
	
	signal output_buffer : std_logic_vector(8*3-1 downto 0);

	signal temp_buffer : std_logic_vector(8*3-1 downto 0);
	
	
--	signal shift1,shift2,shift3: std_logic_vector(10 downto 0);
--	signal keyval1s,keyval2s,keyval3s: std_logic_vector(7 downto 0);
--	signal bit_count: std_logic_vector(3 downto 0);
--	constant bit_count_max: std_logic_vector(3 downto 0) := "1011";
	
	begin
	calc_parity <= temp(0) xor temp(1) xor temp(2) xor temp(3) xor temp(4) xor temp(5) xor temp(6) xor temp(7);
	output <= output_buffer;
	new_val <= newval;
	
	
	
	leds(7 downto 0) <= temp;
	leds(8) <= data;
--	leds <= "1000" when state = wait_start_bit else999999999999
--			"0100" when state = get_bits else
--			"0010" when state = get_parity else
--			"0001" when state = wait_stop else
--			"0000";
	
	--filter the signal
filterC: process(sys_clk,reset)
	begin
		if reset = '1' then
			PS2C_filter <= (others=>'0');
			clk <= '1';
			last_clk <= '1';
		else if (sys_clk'event and sys_clk ='1' ) then
		--shift down
			PS2C_filter(7) <= PS2C;
			PS2C_filter(6 downto 0) <= PS2C_filter(7 downto 1);
				
			if PS2C_filter = X"FF" then
				clk <= '1';
				last_clk <= clk;
			else if PS2C_filter = X"00" then
				clk <= '0';
				last_clk <= clk;
			end if;
			end if;
		
		end if;	
		end if;
end process filterC;

	--filter the signal
filterD: process(sys_clk,reset)
	begin
		if reset = '1' then
			PS2D_filter <= (others=>'0');	
			data <= '1';
		else if (sys_clk'event and sys_clk ='1' ) then
		--shift down
			PS2D_filter(7) <= PS2D;
			PS2D_filter(6 downto 0) <= PS2D_filter(7 downto 1);
		
			
			if PS2D_filter = X"FF" then
				data <= '1';
			else if PS2D_filter = X"00" then
				data <= '0';
			end if;
			end if;		
			
		end if;
		end if;		
	end process filterD;
		
		
		
		
		
		--state machine
		
skey: process(sys_clk,reset)
begin
	if(reset = '1') then
			state <= wait_start_bit;
			bit_count <= (others=>'0');
			output_buffer <= (others=>'0');
			newval <= '0';
			ready <= '0';
			available <= '0';
			
		else if (sys_clk'event and sys_clk = '0') then
			case state is
				when wait_start_bit =>
						if(last_clk = '1' and clk = '0') then
							if(data = '0')then
									state <= get_bits;
							end if;
						end if;
						
							if(available = '1')then
								if(delay_count= "11111111")then
									available <= '0';
									delay_count <= (others=>'0');
									temp_buffer <= (others=>'0');
									output_buffer <= temp_buffer;
								else
									delay_count <= delay_count + 1;
								end if;
				
							end if;
		
							
				when get_bits =>
						delay_count <= (others=>'0');
					if(last_clk = '1' and clk = '0') then
						temp <=  data & temp(7 downto 1) ;
						if(bit_count = 7)then
							state <= get_parity;
							bit_count <= (others => '0');
						else
							bit_count <= bit_count +1;
						end if;
							end if;	
				when get_parity =>
					if(last_clk = '1' and clk = '0') then
						parity <= data;
						state <= wait_stop;
								end if;
				when wait_stop =>			
					if(last_clk = '1' and clk = '0') then		
						state <= wait_start_bit;	
						temp_buffer <= temp & temp_buffer(3*8-1 downto 8);
						available <= '1';
						end if;		
				end case;
		end if;
		 



end if;			
end process skey;		
		
		
end Behavioral;