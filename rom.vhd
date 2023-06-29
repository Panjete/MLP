library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;

entity rommem is
port (raddr : in INTEGER RANGE 0 TO 51913;

	  clk: in std_logic;  
	  re: in std_logic;
	 
	  outdata8 : out std_logic_vector(7 downto 0)
      
    );
end entity;

architecture rommem_beh of rommem is

type mem is array(0 to 51913) of std_logic_vector(7 downto 0);

         impure function init_mem(mif_img_name : in string; mif_datafile_name: in string) return mem is
             file mif_img_file : text open read_mode is mif_img_name;
             file mif_data_file : text open read_mode is mif_datafile_name;
             variable mif_line : line;
             variable temp_bv : bit_vector(7 downto 0);
             variable temp_mem : mem;
         begin
             for i in 0 to 783 loop
                readline(mif_img_file, mif_line);
                read(mif_line, temp_bv);
                temp_mem(i) := to_stdlogicvector(temp_bv);
            end loop;

			for i in 784 to 1023 loop
              	temp_mem(i) := "00000000";
            end loop;
              
            for i in 1024 to 51913 loop
                readline(mif_data_file, mif_line);
                read(mif_line, temp_bv);
                temp_mem(i) := to_stdlogicvector(temp_bv);
            end loop;

            return temp_mem;
         end function;
         signal rom_block: mem := init_mem("imgdata_digit4.mif", "weights_bias.mif");
         
begin

	process(raddr, re) is
	begin
    if(re = '1') then
			outdata8 <= rom_block(raddr);
	else
	       outdata8<= "00000000";
    end if;
	end process;

	
end  rommem_beh;

