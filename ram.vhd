library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       w, r: IN STD_LOGIC;
       clk : in std_logic;
       DATAOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
       ans: out integer range 0 to 20
       );
END ENTITY;


ARCHITECTURE BEV OF ram IS

TYPE MEM IS ARRAY (73 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MEMORY : MEM := (x"0000",others => x"0000");
SIGNAL ADDR : INTEGER RANGE 0 TO 73;
signal curmax: std_logic_vector(15 downto 0):="0000000000000000";

BEGIN

    ADDR<=to_integer(unsigned(ADDRESS));
    process(clk)
        begin   
        if (rising_edge(clk)) then
            IF(w='1')THEN
                MEMORY(ADDR)<=DATAIN;
                    if(unsigned(DATAIN)>unsigned(curmax) and ADDR>63) then
                        curmax<=DATAIN;
                        ans<=ADDR-64;
                    end if;
            end if;
            IF(r='1')THEN
                DATAOUT<=MEMORY(ADDR);
            else
                DATAOUT<="0000000000000000";
            end if;
        end if;
  END PROCESS;
END BEV;