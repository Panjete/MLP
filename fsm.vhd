library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    port (
        clk: in std_logic;
        fstate : inout INTEGER RANGE 0 TO 11;
        reset: in std_logic;
        stage: in INTEGER RANGE 0 to 2;
        layer: in std_logic;
        get_relu: in std_logic;
        flg3: inout std_logic;
        flg4: in std_logic;
        i_1: in INTEGER RANGE 0 to 784;
        i_2: in INTEGER RANGE 0 to 64;
        r1_w: out std_logic;
        r2_w: out std_logic;
        r3_w: out std_logic;
        cntrl: out std_logic;
        ram_write: out std_logic

    );
end entity;


architecture beh of fsm is
    signal reg_fstate: INTEGER RANGE 0 TO 11:=0;
    begin
        process(fstate, reset)   
        begin   
            if (reset='1') then
                reg_fstate <= 0;
            else
                
                case fstate is
                    when 0 =>   
                        reg_fstate <= 6;
                    when 1 =>   
                        reg_fstate <= 7;
                    when 2 => 
                        reg_fstate <= 8;
                    when 3 => 
                        reg_fstate <= 9;
                    when 4 => 
                        reg_fstate <= 10;
                    when 5 => 
                        reg_fstate <= 11;
                    when 6 =>   
                        reg_fstate <= 1;
                    when 7 =>   
                        reg_fstate <= 2;
                    when 8 => 
                        reg_fstate <= 3;
                    when 9 => 
                        reg_fstate <= 4;
                    when 10 => 
                        reg_fstate <= 5;
                    when 11 => 
                        reg_fstate <= 0;
                    when others => 
                        reg_fstate <= 0;
                end case; 
            end if;
        end process;

        process (clk, stage, layer, fstate, get_relu, flg3, flg4)
        begin
            if(rising_edge(clk)) then
                fstate <= reg_fstate;
            end if; 

            if(stage = 0) then
                if(layer = '0') then
                    if(rising_edge(clk) and fstate=4) then  --changed
                        r1_w<='1';
                        r2_w<='0';
                    end if;
                    if (rising_edge(clk) and fstate = 5) then   --changed
                        r1_w<='0';
                        r2_w<='1';
                    --elsif((fstate = 0 and rising_edge(clk)) or fstate = 1 or fstate = 2) then
                        --r1_w<='0';
                        --r2_w<='0';
                    end if;

                    if(rising_edge(clk)) then
                        if (fstate=2) then  --changed
                            if (i_1 = 784) then
                                r3_w <= '0';
                            else
                                ram_write <= '0';
                            end if;
                        end if;

                        if(fstate=4) then           --changed
                            ram_write <= '0';
                        end if;
                    end if;
                    
                    
                    if(rising_edge(clk)) then
                        if (fstate=1) then              --changed
                            if (i_1 = 0) then
                                cntrl <= '1';
                            else
                                cntrl <= '0';
                            end if;
                            r3_w <= '1';
                        end if;
                    end if;

                    if(get_relu='1') then
                        ram_write <= '1';
                    end if;

                    
                elsif(layer = '1') then
                    if (rising_edge(clk) and fstate = 5) then       --changed
                        r1_w<='0';
                        r2_w<='1';
                    end if;

                    if(rising_edge(clk)) then
                        if (fstate=2) then              --changed
                            if (i_2 = 64) then 
                                flg3 <= '1';
                                r3_w <= '0';
                            else
                                ram_write <= '0';
                            end if;
                        end if;

                        if(fstate=4) then               --changed
                            ram_write<='0';
                        end if;

                    end if;

                    if(rising_edge(clk)) then
                        if (fstate=1) then          --changed
                            if (i_2 = 0) then 
                                cntrl <= '1';
                            else
                                cntrl <= '0';
                            end if;
                            r3_w <= '1';
                        end if;
                    end if;

                    if(flg3='1' and rising_edge(clk) and fstate = 3) then       --changed
                        ram_write<='1';
                        flg3<='0';
                    end if;

                end if;

            elsif(stage = 1) then 

                if(rising_edge(clk) and fstate = 3 and flg4='1') then   --changed
                    ram_write<='1';
                end if;
                
                if(rising_edge(clk) and fstate = 4) then                --changed
                    ram_write <= '0';
                end if;

            end if;
        end process;
end beh;