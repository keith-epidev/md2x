library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_lib.all;

entity timer is
	port (
		clk : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		output : out std_logic_vector(26 downto 0)
	);
end timer;

architecture arch of timer is

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

	
component modn is
	generic(
		n:integer := 4
	);
	port (
		clk : in std_logic;
		inc : in std_logic;
		enable: in std_logic;
		reset: in std_logic;
		overflow: out std_logic;
		output : out std_logic_vector(f_log2(n)-1 downto 0)
	);
end component;

	signal timer_clk: std_logic;
	
	signal seconds_hundrendth_overflow : std_logic;
	signal seconds_tenths_overflow : std_logic;
	signal seconds_ones_overflow : std_logic;
	
	signal seconds_units_overflow : std_logic;
	signal seconds_tens_overflow : std_logic;

	signal mins_units_overflow : std_logic;
	signal mins_tens_overflow : std_logic;
	
	
	begin
	
	p1: pulser 	generic map(delay=>50000) port map(clk,enable,timer_clk);
	seconds_hundredth: modn generic map(n=>10) port map(clk,timer_clk,enable,reset,seconds_hundrendth_overflow,output(3 downto 0));
	seconds_tenths: modn generic map(n=>10) port map(clk,seconds_hundrendth_overflow,enable,reset,seconds_tenths_overflow,output(7 downto 4));
	seconds_ones: modn generic map(n=>10) port map(clk,seconds_tenths_overflow,enable,reset,seconds_ones_overflow,output(11 downto 8));
	
	seconds_units: modn generic map(n=>10) port map(clk,seconds_ones_overflow,enable,reset,seconds_units_overflow,output(15 downto 12));
	seconds_tens: modn generic map(n=>6) port map(clk,seconds_units_overflow,enable,reset,seconds_tens_overflow,output(18 downto 16)); --padd '0'

	mins_units: modn generic map(n=>10) port map(clk,seconds_tens_overflow,enable,reset,mins_units_overflow,output(23 downto 20));
	mins_tens: modn generic map(n=>6) port map(clk,mins_units_overflow,enable,reset,open,output(26 downto 24)); --padd '0'
end arch;
