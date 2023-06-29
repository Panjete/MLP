library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity clock is
 Port ( clk_in  :  in std_logic;
        N :  in integer range 0 to 2048;
        clk_out: out std_logic;
        stage: in integer range 0 to 3
 );
end entity;

architecture Behavioral of clock is
                signal temp: integer range 0 to 2048:=0;
                signal clk_temp: std_logic:='0';                                                                                                                                                        
begin

    process(clk_in)
    begin
    if(rising_edge(clk_in)) then
        if(temp=N) then
            temp<=0;
            if(stage<3) then
                clk_temp<= not(clk_temp);
            end if;
        else
            temp<= temp+1;
        end if;
        end if;
    end process;
    
      clk_out<=clk_temp;
end Behavioral;