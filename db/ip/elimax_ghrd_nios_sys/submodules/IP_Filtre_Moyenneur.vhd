library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity IP_Filtre_Moyenneur is
    port (
	 
	 CLOCK    :  in std_logic;

    RESET_N     :  in std_logic;
    
	 in_data    :  in std_logic_vector(7 downto 0);
	 in_dv		:	in std_logic;
	 in_sop		:	in std_logic;
	 in_eop		:	in std_logic;
	 -----------Avalon Memory Map---------------------
	 a_write		: 	in std_logic;
	 a_read		: 	in std_logic;
	 addr			: 	in std_logic;
	 write_data	:	in std_logic_vector (31 downto 0);
	 read_data	:	out std_logic_vector (31 downto 0);
	 -------------------------------------------------
	 
	 out_data   :  out std_logic_vector(7 downto 0);
	 out_dv		:	out std_logic;
	 out_sop		:	out std_logic;
	 out_eop		:	out std_logic);
end entity; 

architecture dataflow of IP_Filtre_Moyenneur is

signal sig_data : std_logic_vector (28 downto 0);
signal treshold : std_logic_vector (7 downto 0);
signal my_reg : std_logic_vector (63 downto 0);
signal adder : std_logic_vector (13 downto 0);
signal treshold_new : std_logic_vector (7 downto 0);

begin 
	
	process (CLOCK, RESET_N) is
	begin

		if(RESET_N = '0') then 
			out_data   	<= "00000000";
			out_dv		<= '0';
			out_sop		<= '0';
			out_eop		<= '0';
		elsif(CLOCK'event and CLOCK = '1') then 
		
			if (in_dv = '1') then 
				
				--sig_data <= sig_data + in_data;
				
				--if(in_eop = '1') then
				--	treshold <= sig_data(28 downto 21);
				--	sig_data <= (others => '0');
				--	my_reg <= treshold & my_reg (63 downto 8);
					
				--	adder <= "000000" & my_reg (63 downto 56) + my_reg (55 downto 48) + my_reg (47 downto 40) + my_reg (39 downto 32) + 
				--				my_reg (31 downto 24) + my_reg (23 downto 16) + my_reg (15 downto 8) + my_reg (7 downto 0);
									  
				--	treshold_new <= adder (7 downto 0);
				--end if;

				
				if (in_data < treshold) then
					out_data <= "00000000";
				else
					out_data <= in_data;
				end if;
			end if;
			
			out_dv		<= in_dv;
			out_sop		<= in_sop;
			out_eop		<= in_eop;
		end if;
	end process;

	process (CLOCK, RESET_N) is
	begin

		if(RESET_N = '0') then 
			read_data <= (others => '0');
			treshold <= (others => '0');

		elsif(CLOCK'event and CLOCK = '1') then 
		
			if (a_write = '1' and addr = '0') then 
				treshold <= write_data(7 downto 0);
			end if;
			
		end if;
	end process;
	
	
	--out_data		<= "00000000" when in_data < "01100100" else
	--					in_data;
						
	--out_dv		<= in_dv;
	--out_sop		<= in_sop;
	--out_eop		<= in_eop;
end architecture;