LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- RAM entity
ENTITY RF IS
  PORT(
       datain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       -- Write when 1
       write : IN STD_LOGIC;
       read : IN STD_LOGIC;
       clk: in std_logic;
       data_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF RF IS
signal memory: std_logic_vector(7 downto 0):="00000000";
BEGIN

--process(clk, write, datain)
--begin
--    IF(write='1')THEN
--      memory<=datain;    
--    END IF;
--end process;
 
--process(clk, read)
--begin
--    if(read= '1') then 
--        data_out <= memory;
--    else
--        data_out <="00000000";
--    end if;
--end process;

memory<= datain when write = '1';
data_out<= memory when read = '1';

END BEV;