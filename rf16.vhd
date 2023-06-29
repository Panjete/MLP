LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- RAM entity
ENTITY RF16 IS
  PORT(
       datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       -- Write when 1
       w : IN STD_LOGIC;
       r : IN STD_LOGIC;
       clk: in std_logic;
       data_out : out STD_LOGIC_VECTOR(15 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF RF16 IS
signal memory: std_logic_vector(15 downto 0):="0000000000000000";
BEGIN

--process(clk, w, datain)
--begin
--    IF(w='1')THEN
--      memory<=datain;    
--    END IF;
--end process;
 
--process(clk, r)
--begin
--    if(r= '1') then 
--        data_out <= memory;
--    else
--        data_out <="0000000000000000";
--    end if;
--end process;

memory<= datain when w = '1';
data_out<= memory when r = '1';

END BEV;