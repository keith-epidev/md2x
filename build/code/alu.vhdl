library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port (
		A,B : in std_logic_vector(7 downto 0); 
		S : in std_logic_vector(3 downto 0);
		Cin : in std_logic;
		F : out std_logic_vector(7 downto 0); 
		Cout : out std_logic
	);
end alu;

architecture arch of alu is
	

component N_add_sub is
	generic(
		size:integer := 8
	);
	port (
		A,B : in std_logic_vector(size-1 downto 0); 
		Cin : in std_logic;
		mode : in std_logic;
		sum : out std_logic_vector(size-1 downto 0);
		Cout : out std_logic 
	);
end component;

component logic_unit is
	port (
		A,B : in std_logic_vector(7 downto 0); 
		Cin : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		F : out std_logic_vector(7 downto 0)
	);
end component;


component sr_unit is
	port (
		A : in std_logic_vector(7 downto 0); 
		Cin : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		F : out std_logic_vector(7 downto 0);
		Cout : out std_logic
	);
end component;

	signal A_val, B_val: std_logic_vector (7 downto 0);

	signal U1_F :std_logic_vector(7 downto 0);
	signal U1_cout : std_logic;
	signal U1_mode : std_logic;
	
	signal U2_F :std_logic_vector(7 downto 0);

	
	signal U3_F :std_logic_vector(7 downto 0);
	signal U3_mode : std_logic_vector(1 downto 0);
	signal U3_cout : std_logic;

begin
	U1 : N_add_sub port map(A_val,B_val,Cin,U1_mode,U1_F,U1_cout);
	U2 : logic_unit port map(A_val,B_val,Cin,S(1 downto 0),U2_F);
	U3 : sr_unit port map(A_val,Cin,U3_mode,U3_F,U3_cout);
	
	U3_mode <= S(1 downto 0);
	
with S(3 downto 2) select 
F <= U3_F when "10",
		U2_F when "11",
		U1_F when others;
	
with S(3 downto 2) select 
Cout <= '0' when "10",
		U3_Cout when "11",
		U1_Cout when others;	
		
	

mode: process(A,B,S,Cin) begin
-- swizzle inputs
if(S(3) = '0')then
	case S(2 downto 0) is
		when "000" =>
			A_val <= (others=>'0');
			B_val <= (others=>'0');
			U1_mode <= '0';
		when "001" =>
			A_val <= (others=>'0');
			B_val <= (others=>'0');
				U1_mode <= '1';
		when "010" =>
			A_val <= A;
			B_val <= (others=>'0');
				U1_mode <= '0';
		when "011" =>
			A_val <= A;
			B_val <= (others=>'0');
				U1_mode <= '1';
	when "100" =>
			A_val <= A;
			B_val <= B;	
			U1_mode <= '0';
		when "101" =>
			A_val <= A;
			B_val <= A;	
			U1_mode <= '0';
			
			when "110" =>
			A_val <= A;
			B_val <= B;	
			U1_mode <= '1';
			
		when others =>
			A_val <= B;
			B_val <= A;	
			U1_mode <= '1';
	end case;
	else
			A_val <= A;
			B_val <= B;	
end if;
end process mode;



end arch;
