library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IP_custom is
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

architecture dataflow of IP_custom is

type state_type is (pending, start_count);
signal state : state_type; 

signal count_col : integer range 0 to 1280;
signal count_raw : integer range 0 to 960;
signal sig_out_data  : std_logic_vector(7 downto 0);
signal sig_out_dv		:	 std_logic;
signal sig_out_sop		:	 std_logic;
signal sig_out_eop		:	 std_logic;

signal sig_out_data_2  : std_logic_vector(7 downto 0);
signal sig_out_dv_2 		:	 std_logic;
signal sig_out_sop_2 		:	 std_logic;
signal sig_out_eop_2 		:	 std_logic;

component IP_Filtre_Moyenneur is
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
end component; 

component IP_Convolution_3_3 is
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
end component; 


begin 

	My_IP1 : IP_Filtre_Moyenneur port map (CLOCK, RESET_N, in_data, in_dv,in_sop, in_eop, sig_out_data, sig_out_dv, sig_out_sop, sig_out_eop);
	My_IP2 : IP_Convolution_3_3 port map (CLOCK, RESET_N, in_data, in_dv,in_sop, in_eop, sig_out_data_2, sig_out_dv_2, sig_out_sop_2, sig_out_eop_2);
	process (CLOCK, RESET_N) is
	begin

		if(RESET_N = '0') then 

			state <= pending;
			
			count_col <= 0;
			count_raw <= 0;
			
			out_data <= (others => '0');
			
			out_dv		<= '0';
			out_sop		<= '0';
			out_eop		<= '0';
			
		elsif(CLOCK'event and CLOCK = '1') then 
		
			if (in_dv = '1') then 
			
				count_col <= count_col + 1;
				
				if (count_col = 1279) then
					count_raw <= count_raw + 1;
					count_col <= 0;
				end if;
				
				if (count_raw = 960) then
					count_raw <= 0;
				end if;
				
				if (count_col >= 639 and count_col < 1280 and count_raw >= 0 and count_raw < 479) then
					out_data <= in_data;
				elsif (count_col >= 0 and count_col < 639 and count_raw >= 479 and count_raw < 960) then
					out_data <= "11111111" - in_data;
				elsif (count_col >= 0 and count_col < 639 and count_raw >= 0 and count_raw < 479) then
					out_data <= sig_out_data;
				elsif (count_col >= 639 and count_col < 1279 and count_raw >= 479 and count_raw < 960) then
					out_data <= sig_out_data_2;
				else
					out_data <= "00000000";
				end if;
				
			end if;
			
				out_dv		<= in_dv;
				out_sop		<= in_sop;
				out_eop		<= in_eop;
		end if;
		
	end process;
	
	

end architecture;