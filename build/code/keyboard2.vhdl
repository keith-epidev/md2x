LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY keyboard2 IS
	PORT( keyboard_clk, keyboard_data, clock_25Mhz ,reset, reads : IN STD_LOGIC;
	scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	scan_ready : OUT STD_LOGIC
	);
END keyboard2;

ARCHITECTURE a OF keyboard2 IS
	SIGNAL INCNT: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL SHIFTIN: STD_LOGIC_VECTOR( 8 DOWNTO 0 );
	SIGNAL READ_CHAR : STD_LOGIC;
	SIGNAL INFLAG, ready_set : STD_LOGIC;
	SIGNAL keyboard_clk_filtered : STD_LOGIC;
	SIGNAL filter: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	signal scanready: std_logic;

BEGIN

--PROCESS ( reads, ready_set )
--	BEGIN
--		IF (reads = '1' ) THEN
--			scanready <= '0';
--		ELSIF (ready_set'EVENT AND ready_set = '1') THEN
--			scanready <= '1';
--		END IF;
--END PROCESS;
	scan_ready <= scanready;
	
	
	
Clock_filter: PROCESS ( clock_25Mhz) BEGIN
IF(  clock_25Mhz'EVENT AND clock_25Mhz = '1')then
		filter ( 6 DOWNTO 0 ) <= filter( 7 DOWNTO 1 ) ;
		filter( 7 ) <= keyboard_clk;
		
		IF filter = "11111111" THEN
			keyboard_clk_filtered <= '1';
		ELSIF filter = "00000000" THEN
			keyboard_clk_filtered <= '0';
		END IF;


END IF;
END PROCESS Clock_filter;
	
	
keys : PROCESS (KEYBOARD_CLK_filtered) BEGIN 
	IF(KEYBOARD_CLK_filtered'EVENT AND KEYBOARD_CLK_filtered = '1')then
		IF RESET = '1' THEN
			INCNT <= "0000";
			READ_CHAR <= '0';
		else
		IF KEYBOARD_DATA = '0' AND READ_CHAR = '0' THEN

				READ_CHAR <= '1';
				ready_set <= '0';
		ELSE
-- Shift in next 8 data bits to assemble a scan code
			IF READ_CHAR = '1' THEN
				IF INCNT < "1001" THEN
				INCNT <= INCNT + 1 ;
				SHIFTIN( 7 DOWNTO 0 ) <= SHIFTIN( 8 DOWNTO 1 );
				SHIFTIN( 8 ) <= KEYBOARD_DATA;
				ready_set <= '0';
				-- End of scan code character, so set flags and exit loop
				ELSE
				scan_code <= SHIFTIN( 7 DOWNTO 0 );
				READ_CHAR <='0';
				ready_set <= '1';
				scanready <= '1';
				INCNT <= "0000";
				END IF;
			END IF;
		END IF;


		END IF;
		if(scanready = '1')then
		scanready <= '0';
		end if;
END IF;
END PROCESS keys;



END a;
	