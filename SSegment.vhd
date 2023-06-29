library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SSegment is
 Port ( sw  :  in STD_LOGIC_VECTOR (0  to  3);
        C :  out STD_LOGIC_VECTOR (0 to 6)
 );
end SSegment;

architecture Behavioral of SSegment is
                                                                                                                                                                        
begin
      process(sw)
            begin         
            C(6) <= (not(sw(0)) and not(sw(1)) and not(sw(2))) or ( sw(1) and sw(2) and sw(3)); 
            C(5) <= (not(sw(0)) and not(sw(1)) and sw(3)) or (sw(2) and sw(3)) or (not(sw(1)) and sw(2)); 
            C(4) <= (sw(1) and not(sw(2))) or sw(3);
            C(3) <= (not(sw(0)) and not(sw(1)) and not(sw(2)) and sw(3)) or (sw(1) and not(sw(3)) and not(sw(2))) or (sw(1) and sw(2) and sw(3));
            C(2) <= (not(sw(1)) and sw(2) and not(sw(3)));
            C(1) <= (sw(1) and not(sw(2)) and sw(3)) or (sw(1) and not(sw(3)) and sw(2));
            C(0) <= (sw(1) and not(sw(2)) and not(sw(3))) or (not(sw(0)) and not(sw(1)) and sw(3) and not(sw(2)));
    end process;   
   
end Behavioral;