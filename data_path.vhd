library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath is
  PORT(
        clk : in std_logic;
        fstate : in INTEGER RANGE 0 TO 11;
        i_1: in INTEGER RANGE 0 to 784;
        i_2: in INTEGER RANGE 0 to 64;
        lyr1_out: in INTEGER RANGE 0 to 63;
        lyr2_out: in INTEGER RANGE 0 to 9;
        layer: in std_logic;
        get_relu: in std_logic;
        flg3: in std_logic;
        stage: in INTEGER RANGE 0 to 2;
        data_out1: in std_logic_vector(7 downto 0);
        data_out2: in std_logic_vector(7 downto 0);
        ram_out: in std_logic_vector(15 downto 0);
        mac_out: in std_logic_vector(15 downto 0);
        relu_outdata: in std_logic_vector(15 downto 0);
        rom_addr: inout INTEGER RANGE 0 TO 51913;
        ram_addr: inout std_logic_vector(7 downto 0);
        mac_in1: inout std_logic_vector(15 downto 0);
        mac_in2: inout std_logic_vector(7 downto 0);
        relu_indata: inout std_logic_vector(15 downto 0);
        ram_indata: inout std_logic_vector(15 downto 0)
       );
end entity;

architecture bev OF datapath is
begin

    process(clk, stage, layer, get_relu, relu_outdata, ram_indata)
    begin
        if(stage = 0) then
            if(layer = '0') then
                if(rising_edge(clk)) then

                    if(fstate=4) then   --changed
                        rom_addr <= i_1;
--                    else
--                        rom_addr<=rom_addr;
                    end if;

                    if (fstate=2 and i_1 = 784) then -- changed
                            ram_addr  <= std_logic_vector(to_unsigned(lyr1_out, 8));
                            relu_indata <= mac_out;
--                    else
--                        ram_addr<=ram_addr;
--                        relu_indata<=relu_indata;
                    end if;
                    
                    if (fstate = 5) then    --changed
                        if(i_1=784) then
                            rom_addr <= 1024 + 784*64 + lyr1_out; 
                        else
                            rom_addr <= i_1+ 784*lyr1_out +1024; 
                        end if;
--                    else
--                        rom_addr<=rom_addr;
                    end if;
                    
                   if (fstate=1) then       --changed
                        if(i_1 = 784) then 
                            mac_in1 <= "00000000" & "00000001"; --16bit
                        else
                            mac_in1 <= "00000000" & data_out1; --16bit
                        end if;
                        mac_in2 <= data_out2; --8bit
--                    else
--                        mac_in2<=mac_in2;
--                        mac_in1<=mac_in1;
                    end if;
                      
                end if;

                if(get_relu='1') then
                    ram_indata <= "00000" & relu_outdata(15 downto 5); 
                else
                    ram_indata<=ram_indata;
                end if;

            elsif(layer='1') then
                if(rising_edge(clk)) then

                    if(fstate=4) then --changed
                        ram_addr <= std_logic_vector(to_unsigned(i_2, 8)); --outputs val of img data
--                    else
--                        ram_addr<=ram_addr;
                    end if;

                    if (fstate=2 and i_2 = 64) then -- changed
                            ram_addr  <= std_logic_vector(to_unsigned(lyr2_out+64, 8));
--                    else
--                            ram_addr <= ram_addr;
                    end if;
                    
                     if (fstate = 5) then   --changed
                        if(i_2=64) then
                            rom_addr <= 785*64 +1024 + 64*10 + lyr2_out; --output bias
                        else
                            rom_addr <= i_2 + lyr2_out*64 + 785*64 +1024; --output weight
                        end if;
                    else
                        rom_addr<=rom_addr;
                    end if;
                    
                    if (fstate=1) then      --changed
                        if(i_2 = 64) then 
                            mac_in1 <= "0000000000000001"; --16bit
                        else
                            mac_in1 <= ram_out;
                        end if;
                        mac_in2 <= data_out2; --8bit
                    end if;

                    if(flg3='1' and fstate = 3) then        --changed
                        if(mac_out(15)='0') then
                            ram_indata <= "00000" & mac_out(15 downto 5);
                        else
                            ram_indata <= "0000000000000000";
                        end if;
                    end if;

                end if;

                
            end if;
        elsif(stage = 1) then
            if(rising_edge(clk)) then
                if(fstate = 0) then
                    ram_addr <= std_logic_vector(to_unsigned(i_2 + 64, 8));
                end if;
            end if;
        end if;
    end process;

end bev;