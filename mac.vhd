library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mac is
  Port (clk: in std_logic;
        cntrl: in std_logic; --cntrl 1 when first prod 
        fstate: in INTEGER RANGE 0 TO 11;
        weights: in std_logic_vector(7 downto 0);
        inpOrAc: in std_logic_vector(15 downto 0);
        output: out std_logic_vector(15 downto 0):="0000000000000000");
       
end mac;

architecture Behavioral of mac is
    
begin
process(clk, fstate)
variable temp: std_logic_vector(23 downto 0):= "000000000000000000000000";
variable sum_till_now: std_logic_vector(15 downto 0):="0000000000000000";
begin

if(rising_edge(clk) and fstate=2) then
temp := std_logic_vector(signed(weights) * signed(inpOrAc));

  if (cntrl = '0') then
    sum_till_now := std_logic_vector(signed(sum_till_now) + signed(temp(23) & temp(14 downto 0)));
  else
    sum_till_now := temp(23) & temp(14 downto 0); --shifter, control signal dekhna padega ek baar
  end if;   

  output<=sum_till_now;
end if;
end process;

end Behavioral;