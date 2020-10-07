---=============================================================================
-- DATE:     2013 Feb 26
-- REVISION: 1.0
-- AUTHOR:   E. POIRIER - ADVANSEE
--=============================================================================
-- DESCRIPTION:
-- Interface with EZ-USB3 chip from Cypress
--=============================================================================


--=======================================================
--  LIBRARIES
--=======================================================

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.ez_interface_pkg.all;

--=======================================================
--  ENTITY
--=======================================================

entity ez_interface is 
	generic (
		DATA_WIDTH : integer := 16
	);
	port (
		-- Main clock
		clk :  in std_logic;                                            -- EZ Clock

		-- System reset
		rst :  in std_logic;                                            -- Active high System Reset

		-- Data source interface
		fifo_rdreq :  out std_logic;                                    -- Active high Read request to the FIFO
		--fifo_rdusedw :  in std_logic_vector(16 downto 0);              -- Nb of word in the FIFO
		fifo_almost_full : in std_logic;
		fifo_rdempty :  in std_logic;                                   -- Empty signal from the FIFO
		fifo_data :  in std_logic_vector(DATA_WIDTH - 1 downto 0);                 -- Data read from the FIFO (data to be sent over USB)
		fifo_last_data :  in std_logic;                                 -- Active high signal indicating the last word of the USB message (Packet End)
		single_access_mode : in std_logic;								-- Mode that need to be able to retrieve 1-word from the FIFO (bypassing the Threshold)
																						
		-- Data sink interface
		sink_data :  out std_logic_vector(DATA_WIDTH - 1 downto 0);                -- Data coming from the USB (data to be used by other blocks)
		sink_data_valid :  out std_logic;                               -- Data valid flag

		-- EZ GPIF II Slave FIFO interface
		ez_data_out :  out std_logic_vector(DATA_WIDTH - 1  downto 0);              -- 32-bit Data to EZ GPIF II Slave FIFO
		ez_data_in :  in std_logic_vector(DATA_WIDTH - 1  downto 0);                -- 32-bit Data from EZ GPIF II Slave FIFO
		ez_addr :  out std_logic_vector(1 downto 0);                   -- 2-bit Address to EZ GPIF II Slave FIFO
		ez_rd :  out std_logic;                                         -- Active low Read signal to EZ GPIF II Slave FIFO
		ez_cs :  out std_logic;                                         -- Active low Chip Select signal to EZ GPIF II Slave FIFO
		ez_wr :  out std_logic;                                         -- Active low Write signal to EZ GPIF II Slave FIFO
		ez_oe :  out std_logic;                                         -- Active low Output Enable signal to EZ GPIF II Slave FIFO
		ez_pktend :  out std_logic;                                     -- Active low Packet End signal to EZ GPIF II Slave FIFO
		ez_flaga :  in std_logic;                                       -- Active low Full (Written Fifo) signal from EZ GPIF II Slave FIFO
		ez_flagb :  in std_logic;                                       -- Active low Watermark reached (Written Fifo) signal from EZ GPIF II Slave FIFO
		ez_flagc :  in std_logic;                                       -- Active low Empty (Read Fifo) signal from EZ GPIF II Slave FIFO
		ez_flagd :  in std_logic                                        -- Active low Watermark reached (Read Fifo) signal from EZ GPIF II Slave FIFO
);
end entity; 


architecture rtl of ez_interface is 

--=======================================================
--  SIGNALS
--=======================================================

signal fifo_rdreq_i : std_logic;
signal fifo_data_avail : std_logic;
signal ez_flagc_d : std_logic;
signal ez_flagc_dd : std_logic;
signal ctrl_state : EZ_CTRL_STATE_TYPE;
signal postdelay_cnt : std_logic_vector(7  downto 0);
signal read_delay_cnt : std_logic_vector(7  downto 0);
signal xfer_pending : std_logic;
signal ez_rd_d : std_logic;
signal get_read_data : std_logic;
signal sink_data_tmp : std_logic_vector(DATA_WIDTH - 1  downto 0);
signal fifo_rdreq_tmp : std_logic;
signal ez_rd_tmp : std_logic;


--=======================================================
--  COMPONENTS DECLARATION
--=======================================================


--=======================================================
--  CONSTANTS
--=======================================================

-- Refer to the associated package ez_interface_pkg


--=======================================================
--  BEHAVIORAL
--=======================================================
    
begin 

-- FIFO Read Request ----------------------------------

fifo_rdreq_tmp <= '1' when ((fifo_rdreq_i = '1') and (ez_flagb = '1')) else '0';  -- Inhibit FIFO read if EZ fifo becomes full

-- FIFO Data availability ---------------------------

-- Data is available from FIFO 1 cycle after Read request
process (clk, rst)
begin
    if (rst = '1') then 
        fifo_data_avail <= '0';
    elsif (rising_edge(clk)) then
        if ((fifo_rdreq_tmp = '1') and (fifo_rdempty = '0')) then
            fifo_data_avail <= '1';
        else
            fifo_data_avail <= '0';
        end if;
    end if;
end process;


-- Flag resynchronization ---------------------------

process (clk, rst)
begin
    if (rst = '1') then 
        ez_flagc_d <= '0';
        ez_flagc_dd <= '0';
    elsif (rising_edge(clk)) then
        ez_flagc_d <= ez_flagc;
        ez_flagc_dd <= ez_flagc_d;
    end if;
end process;


-- EZ Control signals -------------------------------

process (clk, rst)
begin
    if (rst = '1') then 
        ctrl_state <= EZ_CTRL_STATE_IDLE;
        fifo_rdreq_i <= '0';
        ez_wr <= '1';
        ez_rd_tmp <= '1';
        ez_oe <= '1';
        ez_cs <= '1';
        ez_addr <= (others => '0');
        postdelay_cnt <= (others => '0');
        read_delay_cnt <= (others => '0');
        xfer_pending <= '0';
        
    elsif (rising_edge(clk)) then
        case  (ctrl_state) is 
            when 
                EZ_CTRL_STATE_IDLE => 
                postdelay_cnt <= (others => '0');
                read_delay_cnt <= (others => '0');
                
                if (ez_flagc_dd = '1') then 
                    ctrl_state <= EZ_CTRL_STATE_READ_START;             -- Goto Read_Start state
                    ez_addr <= EZ_SOCKET_3;                             -- Address the Socket 3
                    
                -- If EZ Fifo is not too full and FPGA FIFO is full enough 
                --  or FPGA FIFO is not over threshold but there are still bytes from the previous partial transfer in it)
                --  or FPGA FIFO is not over threshold but the 1-word single read is requested (Registers access mode)
                elsif ((ez_flaga = '1') and (ez_flagb = '1') and ((fifo_almost_full = '1') or (xfer_pending = '1') or (single_access_mode = '1'))) then 
                        xfer_pending <= '0';                            -- Reset flag
                        fifo_rdreq_i <= '1';                            -- Request a data to the FIFO
                        ez_addr <= EZ_SOCKET_0;                         -- Address the Socket 0
                        ctrl_state <= EZ_CTRL_STATE_WRITE;              -- Goto Write state
                        if (xfer_pending = '1') then
                            ez_wr <= '0';                                      
                            ez_cs <= '0';
                        end if;
                end if;
                
            when 
                EZ_CTRL_STATE_WRITE => 
                ez_wr <= '0';                                          -- Perform a write into EZ Fifo
                ez_cs <= '0';
                ez_oe <= '1';
                
                -- FIFO is empty or EZ Fifo is becoming full: stop filling into the EZ Fifo
                if ((fifo_rdempty = '1') or (ez_flagb = '0')) then 
                    if ((ez_flagb = '0')  and (fifo_rdempty = '0')) then -- If the stop is due to EZ Fifo becoming full,
                        xfer_pending <= '1';                            -- the transfer must continue as soon as EZ Fifo becomes ready
                    end if;                                            -- (even if the FIFO level has not reached the threshold)
                    fifo_rdreq_i <= '0';                               -- Stop requesting data from the FIFO
                    ez_wr <= '1';                                       -- End of the write into EZ Fifo
                    ez_cs <= '1';                                          
                    ctrl_state <= EZ_CTRL_STATE_POSTDELAY;              -- Goto Post Delay state
                end if;
                
            when 
                EZ_CTRL_STATE_POSTDELAY => 
                if (postdelay_cnt = X"2") then                       -- Wait 2 cycles here so that flaga has been updated
                    ctrl_state <= EZ_CTRL_STATE_IDLE;                   -- Goto Idle state
                end if;
                postdelay_cnt <= conv_std_logic_vector(conv_integer(postdelay_cnt) + 1, postdelay_cnt'length);
                
            when 
                EZ_CTRL_STATE_READ_START => 
                ez_oe <= '0';                                            -- Activate Output Enable of EZ
                ez_rd_tmp <= '0';                                            -- Perform a read from EZ Fifo
                ez_cs <= '0';
                ctrl_state <= EZ_CTRL_STATE_READ;                       -- Goto Read state
                
            when 
                EZ_CTRL_STATE_READ => 
                if (ez_flagc_dd = '0') then 
                    ez_rd_tmp <= '1';                                       -- Stop reading from EZ fifo
                    ctrl_state <= EZ_CTRL_STATE_READ_END;
                end if;
                
            when 
                EZ_CTRL_STATE_READ_END => 
                if (read_delay_cnt = X"2") then                      -- Wait 2 cycles here so that last data is actually output
                    ctrl_state <= EZ_CTRL_STATE_IDLE;                   -- Goto Idle state
                    ez_oe <= '1';                                      -- De-activate Output Enable of EZ
                    ez_cs <= '1';
                end if;
                read_delay_cnt <= conv_std_logic_vector(conv_integer(read_delay_cnt) + 1, read_delay_cnt'length);
            when 
                 others  =>                                             -- should never be reached
                 
        end case;
    end if;
end process;


-- Data from USB retrieving -------------------------

process (clk, rst)
begin
    if (rst = '1') then 
        ez_rd_d <= '0';
        get_read_data <= '0';
        sink_data_valid <= '0';
        sink_data_tmp <= (others => '0');
    elsif (rising_edge(clk)) then
        sink_data_valid <= '0';                                         -- To have a pulse
        
        -- The data is available 2 cycles after ez_rd
        ez_rd_d <= ez_rd_tmp;
        get_read_data <= not ez_rd_d;                                   -- Change polarity
        
        if (get_read_data = '1') then 
            sink_data_tmp <= ez_data_in;
            sink_data_valid <= '1';
        end if;
    end if;
end process;


--///////////////////////////////////////////////////////
-- Glue
--///////////////////////////////////////////////////////

ez_data_out <= fifo_data;
ez_pktend <= '0' when ((fifo_last_data = '1') and (fifo_data_avail = '1')) else '1';  -- Active low End of Packet signal

sink_data <= sink_data_tmp;
ez_rd <= ez_rd_tmp;
fifo_rdreq <= fifo_rdreq_tmp;


end; 


