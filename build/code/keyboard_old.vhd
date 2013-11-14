library ieee;
use ieee.std_logic_1164.all;
use work.my_lib.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity keyboard is
	port(
		clk: in std_logic;
		clr: in std_logic;
		PS2C: in std_logic;
		PS2D: in std_logic;
		keyval1: out std_logic_vector(7 downto 0);
		keyval2: out std_logic_vector(7 downto 0);
		keyval3: out std_logic_vector(7 downto 0)
		);
end keyboard;

architecture Behavioral of keyboard is


	type state_type is (start, wait_clk_hi_1, wait_clk_lo_1, get_key_1, wait_clk_hi_2, wait_clk_lo_2, get_key_2, breakkey, wait_clk_hi_3, wait_clk_lo_3, get_key_3);
	signal state: state_type;
	signal PS2Cf, PS2Df: std_logic;
	signal PS2C_filter,PS2D_filter: std_logic_vector(7 downto 0);
	signal shift1,shift2,shift3: std_logic_vector(10 downto 0);
	signal keyval1s,keyval2s,keyval3s: std_logic_vector(7 downto 0);
	signal bit_count: std_logic_vector(3 downto 0);
	constant bit_count_max: std_logic_vector(3 downto 0) := "1011";
	
	begin
	
	
	
	
	--filter the signal
filterC: process(clk,clr)
	begin
		if clr = '1' then
			PS2C_filter <= (others=>'0');
			PS2Cf <= '1';
		else if (clk'event and clk ='1' ) then
		--shift down
			PS2C_filter(7) <= PS2C;
			PS2C_filter(6 downto 0) <= PS2C_filter(7 downto 1);
				
			if PS2C_filter = X"FF" then
				PS2Cf <= '1';
			else if PS2C_filter = X"00" then
				PS2Cf <= '0';
			end if;
			end if;
		
		end if;	
		end if;
end process filterC;

	--filter the signal
filterD: process(clk,clr)
	begin
		if clr = '1' then
			PS2D_filter <= (others=>'0');	
			PS2Df <= '1';
		else if (clk'event and clk ='1' ) then
		--shift down
			PS2D_filter(7) <= PS2D;
			PS2D_filter(6 downto 0) <= PS2D_filter(7 downto 1);
		
			
			if PS2D_filter = X"FF" then
				PS2Df <= '1';
			else if PS2D_filter = X"00" then
				PS2Df <= '0';
			end if;
			end if;		
			
		end if;
		end if;		
	end process filterD;
		
		
		
		
		
		--state machine
		
		skey: process(clk,clr)
begin
	if(clr = '1') then
			state <= start;
			bit_count <= (others=>'0');
			shift1 <= (others=>'0');
			shift2  <= (others=>'0');
			shift2  <= (others=>'0');
			keyval1s <= (others=>'0');
			keyval2s <= (others=>'0');
			keyval3s  <= (others=>'0');
		else if (clk'event and clk = '1') then
			case state is
				when start =>
							if PS2Df = '1' then
								
								state <=start;
							else
								state <= wait_clk_lo_1;
							end if;
				when wait_clk_lo_1 =>
							if bit_count < bit_count_max then
								if PS2Cf = '1' then
									state <= wait_clk_lo_1;
								else
									state <= wait_clk_hi_1;
									shift1 <= PS2Df & shift1(10 downto 1);
								end if;
							else
								state <= get_key_1;
							end if;
				when wait_clk_hi_1 =>
						if PS2Cf = '0' then
							state <= wait_clk_hi_1;
						else
							state <= wait_clk_lo_1;
							bit_count <= bit_count + 1;
						end if;
		
				when get_key_1 =>
						keyval1s <= shift1(8 downto 1);
						bit_count <= (others=>'0');
						state <= wait_clk_lo_2;
		----
		when wait_clk_lo_2 =>
							if bit_count < bit_count_max then
								if PS2Cf = '1' then
									state <= wait_clk_lo_2;
								else
									state <= wait_clk_hi_2;
									shift2 <= PS2Df & shift2(10 downto 1);
								end if;
							else
								state <= get_key_2;
							end if;
				when wait_clk_hi_2 =>
						if PS2Cf = '0' then
							state <= wait_clk_hi_2;
						else
							state <= wait_clk_lo_2;
							bit_count <= bit_count + 1;
						end if;
		
				when get_key_2 =>
						keyval2s <= shift2(8 downto 1);
						bit_count <= (others=>'0');
						state <= breakkey;	
			
				when breakkey =>
					if keyval2s = X"F0" then
						state <= wait_clk_lo_3;
					else
						if keyval1s = X"E0" then
							state <= wait_clk_lo_1;
						else
							state <= wait_clk_lo_2;
						end if;
					end if;
				when wait_clk_lo_3 =>
						if bit_count < bit_count_max then
							if PS2Cf = '1' then
								state <= wait_clk_lo_3;
							else
								state <= wait_clk_hi_3;
								shift3 <= PS2Df & shift3(10 downto 1);
							end if;
						else
							state <= get_key_3;
						end if;
						
				when wait_clk_hi_3 =>
						if PS2Cf = '0' then
							state <= wait_clk_hi_3;
						else
							state <= wait_clk_lo_3;
							bit_count <= bit_count +1;
						end if;
				when get_key_3 =>
							keyval3s <= shift3(8 downto 1);
							bit_count <= (others=>'0');
							state <= wait_clk_lo_1;
				end case;
		end if;
		
		
		end if;
		
		
		
	end process skey;
	
	keyval1 <= keyval1s;
	keyval2 <= keyval2s;
	keyval3 <= keyval3s;
	
		
		
end Behavioral;