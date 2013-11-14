library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.my_lib.all;


entity top is
	port (
		CLK: in std_logic;
		SW : in std_logic_vector(17 downto 0); 
		KEY : in std_logic_vector(3 downto 0); 
		LEDR : out std_logic_vector(17 downto 0);
		LEDG : out std_logic_vector(7 downto 0);
		HEX : out hex_array;
		LCD_RS: out std_logic;
		LCD_RW: out std_logic;
		LCD_EN: out std_logic;
		LCD_DATA: out std_logic_vector (7 downto 0);
		LCD_ON: out std_logic;
		PS2_CLK: in std_logic;
		PS2_DAT: in std_logic
	);
end top;




architecture arch of top is


component lcd is
port(
	clk:		in 	std_logic; 
	reset:		in std_logic;
	rs:		out	std_logic;
	rw:		out 	std_logic;
	e:		out 	std_logic;
	data:		out	std_logic_vector(7 downto 0);
	disp: 		in 	disp_chars
);
end component;



component keyboard is
	port(
		sys_clk: in std_logic;
		reset: in std_logic;
		PS2C: in std_logic;
		PS2D: in std_logic;
		output: out std_logic_vector(8*3-1 downto 0);
		new_val: out std_logic;
		leds: out std_logic_vector(8 downto 0)
		);
end component;


component keyboard2 IS
	PORT( keyboard_clk, keyboard_data, clock_25Mhz ,reset, reads : IN STD_LOGIC;
	scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	scan_ready : OUT STD_LOGIC
	);
END component;

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


component seven_segment is
	port (
		clk : in std_logic;
		val : in std_logic_vector(3 downto 0); 
		led : out std_logic_vector(6 downto 0);
		mode: in std_logic
	);
end component;


signal reset : std_logic;




--LCD
signal data:	std_logic_vector(7 downto 0);
signal e: std_logic;
signal lcd_disp : disp_chars;

	
--Keyboard
signal clr: std_logic;
signal keys : std_logic_vector(7downto 0);
signal key_buffer : std_logic_vector(3*8-1 downto 0);
signal key_output : std_logic_vector(3*8-1 downto 0);
signal new_key :std_logic;	
	
	
	signal counter : std_logic_vector(3 downto 0);
	
	signal clk25 : std_logic;
	signal reads : std_logic;
	signal send : std_logic;
	
		signal o : std_logic;
begin
reset <= not KEY(0);
LCD_DATA <= data;
LCD_EN <= e;
LEDG <= data;
--LEDR(0) <= e;


LEDR(0) <= o;
LEDR(4 downto 1) <= counter;

lcd1 : lcd port map(clk,reset,LCD_RS,LCD_RW,e,data,lcd_disp);
LCD_ON <= '1';
--0lcd_latch <= '1';
--lcd_disp(0 to 4) <=  (X"4B",X"45",X"49",X"54",X"48");
--lcd_disp(16 to 16+1) <=  (X"48",X"49");

--keyb: keyboard2 port map( PS2_CLK, PS2_DAT, clk25, '0',reads, keys, new_key);

  p1: pulser      generic map(delay=>2) port map(clk, '1', clk25);

  p2: pulser      generic map(delay=>50000000) port map(clk, '1', send);
keyb : keyboard port map(clk,reset,PS2_CLK,PS2_DAT,key_output,new_key,LEDR(16 downto 8));

hex0: seven_segment port map(clk,key_output(3 downto 0),HEX(0),'0');
hex1: seven_segment port map(clk,key_output(7 downto 4),HEX(1),'0');
----
hex2: seven_segment port map(clk,key_output(11 downto 8),HEX(2),'0');
hex3: seven_segment port map(clk,key_output(15 downto 12),HEX(3),'0');
----
hex4: seven_segment port map(clk,key_output(19 downto 16),HEX(4),'0');
hex5: seven_segment port map(clk,key_output(23 downto 20),HEX(5),'0');
--





process(clk,reset)
variable index : integer := 0;
begin
	if(reset = '1')then
		index := 0;
		lcd_disp <= (others=>(X"20"));
	elsif(clk'event and clk = '1')then
	
	
			
		if(new_key  = '1')then
			key_buffer <= key_output;
			lcd_disp(index) <= key_output(7 downto 0);
			index := index +1;
			
			if(index = 32)then
			index := 0;
			end if;
			counter <= counter +1;
		end if;
			
			
			
			
	end if;
end process;






	
end arch;
