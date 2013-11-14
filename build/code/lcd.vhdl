library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.my_lib.all;

entity lcd is
port(
	clk:		in 	std_logic; 
	reset:		in std_logic;
	rs:		out	std_logic;
	rw:		out 	std_logic;
	e:		out 	std_logic;
	data:		out	std_logic_vector(7 downto 0);
	disp: 		in disp_chars
);
end lcd;

architecture Behavioral of lcd is

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
      

	
	signal lcd_clk : std_logic;
	signal state : std_logic_vector(f_log2(8)-1 downto 0);
	--signal index : std_logic_vector(f_log2(16*2)-1 downto 0) := (others=>'0');
	
	type  cmd_list is  array(0 to 7) of std_logic_vector(7 downto 0);
	signal init_data :cmd_list :=  ( X"30", X"30", X"30", X"38", X"0C", X"01", X"06",X"01");


	signal e_state: std_logic := '0';

	signal align: std_logic := '0';


	
	begin
	  p1: pulser      generic map(delay=>50000) port map(clk, '1', lcd_clk);

e <= e_state;






process(lcd_clk,reset)
variable index : integer := 0;
begin
if(reset = '1')then
	index:= 0;
	state <= (others=>'0');
elsif(lcd_clk'event and lcd_clk = '1')then
if(e_state = '1')then
e_state <= '0';
		if(state < 8) then
	data <= init_data(conv_integer(state));

			
			rs <= '0';
			rw <= '0';
			state <= state+1;
		else
		


			if( align = '0'  and (index = 0   or index = 16 ) )then 

			rs <= '0';
			rw <= '0';
			align <= '1';
			
			if(index = 0)then
			data <=X"80";
			else
			data <= X"C0";
			end if;

			else
			if( disp(index) = "00000000" )then
					data <= X"20";
			else
					data <= disp(index);
			end if;
			
			
				index := index+1;
				align <= '0';
				rs <= '1';
				rw <= '0';
				
			if(index = 16*2)then
				index := 0;
			end if;
			
			end if;

		end if;
	
else

e_state <= not e_state;

end if;





	end if; 
end process;

end Behavioral;
