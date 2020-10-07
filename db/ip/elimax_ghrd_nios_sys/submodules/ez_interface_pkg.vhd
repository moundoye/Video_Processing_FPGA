--=============================================================================
-- DATE:     2013 Feb 26
-- REVISION: 1.0
-- AUTHOR:   E. POIRIER - ADVANSEE
--=============================================================================
-- DESCRIPTION:
-- Package to be used by ez_interface.vhd
--=============================================================================

--=======================================================
--  LIBRARIES
--=======================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

--=======================================================
--  PACKAGE FOR EZ_INTERFACE
--=======================================================

package ez_interface_pkg is
 
-- Customizable parameters ----------------------------

-- The following parameters can be modified to adapt the
-- design

-- FIFO read threshold
constant EZ_FIFO_THRESHOLD : integer := 32;

-- Address of EZ Fifo Sockets
constant EZ_SOCKET_0 : std_logic_vector(1 downto 0) := "00";
constant EZ_SOCKET_3 : std_logic_vector(1 downto 0) := "11";

-- Design parameters ----------------------------------

-- The following parameters are not intended to be 
-- modified

-- EZ Control signals sequencer
type EZ_CTRL_STATE_TYPE is (EZ_CTRL_STATE_IDLE,
                             EZ_CTRL_STATE_WRITE,
                             EZ_CTRL_STATE_POSTDELAY,
                             EZ_CTRL_STATE_READ_START,
                             EZ_CTRL_STATE_READ,
                             EZ_CTRL_STATE_READ_END);

end package;
