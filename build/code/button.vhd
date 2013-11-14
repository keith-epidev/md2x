----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- 
-- Create Date:    02:29:35 08/22/2012
-- Design Name:
-- Module Name:    button - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity button is
        generic(
                active_high:boolean := true
        );
        port(
                 clk: in std_logic;
                 button: in std_logic;
                 pulse: out std_logic
        );
end button;

architecture Behavioral of button is
        signal state: std_logic;
        signal clean_signal: std_logic;
        signal pulse_val: std_logic;
       
        component debounce is
        generic(
                delay:integer := 512
        );
        port(
                 clk: in std_logic;
                 input: in std_logic;
                 output: out std_logic
        );     
        end component;
       
       
begin

pulse <= pulse_val;

        db_signal:debounce
        generic map (
                delay => 512
        )
        port map(
                clk => clk,
                input => button,
                output => clean_signal
        );


button_to_pulse:process(clk)
begin          
        if(clk'event and clk = '1')then
       
        if(not(clean_signal = state) )then
                state <= clean_signal;
               
        if((clean_signal = '1' and active_high) or (clean_signal = '0' and not active_high))then
        pulse_val <= '1';
        end if;
               
        end if;
               
        if(pulse_val = '1')then
                pulse_val <='0';
        end if;
       

        end if;
       

end process;

end Behavioral;