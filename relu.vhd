library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity relu is
    port (data : in std_logic_vector(15 downto 0);
    
          outdata : out std_logic_vector(15 downto 0));
    end entity;
    
    architecture relu_beh of relu is
    begin
    process(data)
    begin
        if(data(15)= '1') then
            outdata <= "0000000000000000";
        else 
            outdata <= data;
        end if;
    end process;
    end relu_beh;