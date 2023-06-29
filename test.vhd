library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity network is
  PORT(
       main_clk : in std_logic;
       reset : in std_logic;
       anodes: out std_logic_vector(3 downto 0);
       cathodes: out std_logic_vector(6 downto 0) ;
       dp: out std_logic
       );
end entity;

architecture bev OF network is

signal rom_addr: INTEGER RANGE 0 TO 51913:=0;
signal rom_read: std_logic:='1';
signal rom_out: std_logic_vector(7 downto 0):="00000000";

signal ram_addr: std_logic_vector(7 downto 0):="00000000";
signal ram_read: std_logic:='1';
signal ram_write: std_logic:='0';
signal get_relu: std_logic:='0';
signal ram_out : std_logic_vector(15 downto 0):="0000000000000000";

signal fstate : INTEGER RANGE 0 TO 11:=5;

signal register1_read: std_logic:='1';
signal register1_write: std_logic:='0';
signal register2_read: std_logic:='1';
signal register2_write: std_logic:='0';
signal register3_read: std_logic:='1';
signal register3_write: std_logic:='0';
signal data_out1, data_out2: std_logic_vector(7 downto 0):="00000000";
signal data_out3: std_logic_vector(15 downto 0):="0000000000000000";

signal cntrl : std_logic:='0'; -- for telling mac whether first element or not



signal lyr1_out: INTEGER RANGE 0 to 63 := 0; --for indexing the 1x64 hidden layer
signal lyr2_out: INTEGER RANGE 0 to 9 := 0; --for indexing output 1x10
signal i_1: INTEGER RANGE 0 to 784 := 0; --for indexing image input, matrix indices
signal i_2: INTEGER RANGE 0 to 64 := 0; --for indexing hidden layer for matrix multiplication and addn
signal layer: std_logic:='0'; -- 0 for layer 1, 1 for layer 2

signal mac_in1: std_logic_vector(15 downto 0):="0000000000000000";
signal mac_in2: std_logic_vector(7 downto 0):="00000000";
signal mac_out: std_logic_vector(15 downto 0):="0000000000000000";
signal stage: INTEGER RANGE 0 to 3 := 0;-- if 0 then multiplying, if 1 then finding max from 1x10, if 2 then output
signal curmax: std_logic_vector(15 downto 0):="0000000000000000";
signal curmax_ind: INTEGER RANGE 0 to 9;

signal relu_indata: std_logic_vector(15 downto 0):="0000000000000000";
signal relu_outdata: std_logic_vector(15 downto 0):="0000000000000000";
signal ram_indata: std_logic_vector(15 downto 0):="0000000000000000";
signal cur_maxind: std_logic_vector(3 downto 0):="0101";
signal flg: std_logic := '0';
signal flg2: std_logic:= '0';
signal flg3: std_logic:= '0';
signal flg4: std_logic:= '0';
signal flg5: std_logic:= '0';

signal clk:  std_logic:='0';

signal digit0: std_logic_vector(15 downto 0):="0000000000000000";

signal ans: integer range 0 to 20;
begin

--clock_change: entity work.clock port map(main_clk, 5, clk, stage);
clk<=main_clk;

ROM: entity work.rommem port map(rom_addr, clk, rom_read, rom_out);

RAM: entity work.ram port map(ram_indata, ram_addr, ram_write, ram_read, clk, ram_out,ans);

mac: entity work.mac port map(clk, cntrl, fstate, mac_in2, mac_in1, mac_out);

fsm: entity work.fsm port map( clk, fstate,  reset, stage, layer, get_relu, flg3, flg4, i_1, i_2, register1_write, register2_write, 
                                register3_write, cntrl, ram_write);

data: entity work.datapath port map( clk, fstate, i_1, i_2, lyr1_out, lyr2_out, layer, get_relu, flg3, stage, 
                                    data_out1, data_out2, ram_out, mac_out, relu_outdata, rom_addr, ram_addr, mac_in1, 
                                    mac_in2, relu_indata, ram_indata);

Register1: entity work.rf port map(rom_out, register1_write, register1_read, clk, data_out1);

Register2: entity work.rf port map(rom_out, register2_write, register2_read, clk, data_out2);

Register3: entity work.rf16 port map(mac_out, register3_write, register3_read, clk, data_out3);

ReLU: entity work.relu port map(relu_indata, relu_outdata);

ss: entity work.SSegment port map(cur_maxind, cathodes);
--cathodes<="1000000";
anodes <= "1110";
dp<='1';
process(clk, layer, fstate, get_relu, flg5)
begin
        if(stage = 0) then
            
            if(layer = '0') then
            --anodes <= "1010";
                if (rising_edge(clk) and fstate=2) then -- changed
                    if (i_1 = 784) then --write in ram 
                        get_relu<='1';
                        if (lyr1_out +1 = 64) then --end of layer1
                            flg<= '1'; --flag to indicate end of l1
                            lyr1_out <= lyr1_out;
                        else 
                            lyr1_out <= lyr1_out + 1;
                            flg<='0';
                        end if;
                        i_1<=0;
                    else
                        i_1 <= i_1 + 1;
                        get_relu<='0';
                        lyr1_out <= lyr1_out;
                        
                    end if;
                    layer<=flg; --next cycle main layer ki value updated
                end if;

                if(rising_edge(clk) and get_relu='1') then
                    lyr1_out <= lyr1_out;
                    i_1 <= 0; --start over for the next lyr1_out
                    get_relu<='0';
                end if;

            elsif(layer = '1') then
                lyr1_out <= lyr1_out;
                if (rising_edge(clk) and fstate=2) then -- changed
                    if (i_2 = 64) then --write in ram
                        if (lyr2_out +1 = 10) then --end of layer1
                            stage<= 1;
                            lyr2_out <= lyr2_out+1-1;
                            
                        else
                            lyr2_out <= lyr2_out + 1;
                            stage<= 0;
                        end if;
                        i_2 <= 0; --start over for the next lyr1_out
                    else
                        if(flg2='1') then
                            i_2 <= i_2 + 1;
                        else
                            flg2<='1';
                            i_2<=i_2;
                        end if;
                    end if;
                end if;
                
            end if;
        elsif(stage = 1) then 
        lyr1_out <= lyr1_out;    
            if(rising_edge(clk) and fstate = 0) then--changed
                flg5<='1';
                if i_2< 10 then
                    i_2<=i_2+1;
                else
                    i_2<=i_2;
                end if;
            end if;
            if(rising_edge(clk) and fstate = 3 and flg5='1') then   --changed
                if i_2 < 10 then
                    if(unsigned(ram_out) > unsigned(curmax)) then
                        curmax_ind <= i_2-1;
                        curmax <= ram_out;
                    
                    end if;  
                elsif(i_2=10) then
                    
                    stage <= 2;
                end if;
            end if;
        elsif(stage=2) then
            lyr1_out <= lyr1_out;
            if (ans>=0 and ans<10) then
                cur_maxind<= std_logic_vector(to_unsigned(ans, 4));
            end if;
        end if;
    end process;
--FINAL FINAL SUBMISSION
--3 5 4 6 13 4 5 7 5 10
end bev;
