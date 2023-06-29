library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
-- empty
end entity; 

architecture beh of testbench is
signal clk: std_logic:='0';
signal reset: std_logic:='1';

begin
  DUT: entity work.network port map(clk, reset);
  process
  begin
  wait for 1 ns;
  reset<='0';
  for i in 1 to 240000 loop
    for j in 1 to 3 loop
	clk <= '1';
	wait for 1 ns;
	clk <= '0';
	wait for 1 ns;
	end loop;
	end loop;
	wait;
    --assert false report "Test done." severity note;
  end process;
end beh;