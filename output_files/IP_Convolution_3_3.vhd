library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IP_Convolution_3_3 is
    port (
	 
	 CLOCK    :  in std_logic;

    RESET_N     :  in std_logic;
    
	 in_data    :  in std_logic_vector(7 downto 0);
	 in_dv		:	in std_logic;
	 in_sop		:	in std_logic;
	 in_eop		:	in std_logic;
	 
	 
	 out_data   :  out std_logic_vector(7 downto 0);
	 out_dv		:	out std_logic;
	 out_sop		:	out std_logic;
	 out_eop		:	out std_logic);
end entity; 

architecture dataflow of IP_Convolution_3_3 is

type line_3pixel is array (0 to 2) of std_logic_vector (7 downto 0);
type line_buffer is array (0 to 1276) of std_logic_vector (7 downto 0);
 
signal line_1_img : line_3pixel;
signal line_2_img : line_3pixel;
signal line_3_img : line_3pixel;

constant line_1_kernel : line_3pixel := (x"00", x"01", x"00");
constant line_2_kernel : line_3pixel := (x"00", x"00", x"00");
constant line_3_kernel : line_3pixel := (x"00", x"01", x"00");

signal buffer_1_img : line_buffer;
signal buffer_2_img : line_buffer;


signal conv : std_logic_vector (7 downto 0);
signal col : std_logic_vector (7 downto 0);
signal raw : std_logic_vector (7 downto 0);

begin 
	
	process (CLOCK, RESET_N) is
	begin

		if(RESET_N = '0') then 

			line_1_img <= (others => x"00");
			line_2_img <= (others => x"00");
			line_3_img <= (others => x"00");
			
			buffer_1_img  <= (others => x"00");
			buffer_2_img  <= (others => x"00");

			conv	<= (others => '0');
			out_data <= (others => '0');
			
			out_dv		<= '0';
			out_sop		<= '0';
			out_eop		<= '0';
			
		elsif(CLOCK'event and CLOCK = '1') then 
		
			if (in_dv = '1') then 
					line_1_img(0) 	<= in_data;
					line_2_img(0)	<= buffer_1_img(1276); 
					line_3_img(0)	<= buffer_2_img(1276);
					
					
					buffer_1_img(0) <= line_1_img(2);
					buffer_2_img(0) <= line_2_img(2);
				
					------------------------Shift kernel image -----------------------
				for i in 1 to 2 loop
					line_1_img(i) <= line_1_img(i-1);
					line_2_img(i) <= line_2_img(i-1);
					line_3_img(i) <= line_3_img(i-1);
				end loop;
				
					------------------------Shift buffer image -----------------------
				for i in 1 to (1276) loop
					buffer_1_img(i) <= buffer_1_img(i-1);
					buffer_2_img(i) <= buffer_2_img(i-1);
				end loop;
				
				
				if (line_1_img(1) > line_3_img(1)) then
					col <= line_1_img(1) - line_3_img(1);
				else 
					col <= line_3_img(1) - line_1_img(1);
				end if;
				
				if (line_2_img(0) > line_2_img(2)) then
					raw <= line_2_img(0) - line_2_img(2);
				else 
					raw <= line_2_img(2) - line_2_img(0);
				end if;
				
				conv <= raw + col;
				
				--conv <= 	line_1_kernel(0)*line_1_img(0) + line_1_kernel(1)*line_1_img(1) + line_1_kernel(2)*line_1_img(2) + 
				--			line_2_kernel(0)*line_2_img(0) + line_2_kernel(0)*line_2_img(0) + line_2_kernel(0)*line_2_img(0) +
				--			line_3_kernel(0)*line_3_img(0) + line_3_kernel(0)*line_3_img(0) + line_3_kernel(0)*line_3_img(0);
				
				
				out_data 	<= conv;
				
						
			end if;
			
				out_dv		<= in_dv;
				out_sop		<= in_sop;
				out_eop		<= in_eop;
		end if;
		
	end process;
	

end architecture;