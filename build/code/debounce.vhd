----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- 
-- Create Date:    02:29:35 08/22/2012
-- Design Name:
-- Module Name:    debounce - Behavioral
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


entity debounce is
        generic(
                delay:integer := 5000000
        );
        port(
                 clk: in std_logic;
                 input: in std_logic;
                 output: out std_logic
        );
end debounce;

architecture Behavioral of debounce is
        signal timer: std_logic_vector(19 downto 0);
        signal state: std_logic;

begin


debounce_signal:process(clk)
begin          
        if(clk'event and clk = '1')then


                if(input = state) then
                        if(timer < delay)then
                                timer <= timer + 1;
                        else
                                output <= state;
                                timer <= (others=>'0');
                        end if;

                else
                        state <= input;
                        timer <= (others=>'0');
                end if;

        end if;
       

end process;

end Behavioral;