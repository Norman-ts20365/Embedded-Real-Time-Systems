library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;

ENTITY cm0_wrapper IS
  PORT(
    -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 -- AHB Master records --------------
 ahbmi : in ahb_mst_in_type;
 ahbmo : out ahb_mst_out_type
 );
END cm0_wrapper;
 
ARCHITECTURE structural of cm0_wrapper is
  
--declare a component for cortex M0

--------------CortexM0-----------------------------------  
  --component cortexm0 is
	  --port (
		   --HCLK: in std_logic;
		   --HRESETn: in std_logic;
		   --HADDR : out std_logic_vector (31 downto 0); -- AHB transaction address
       --HSIZE : out std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
       --HTRANS : out std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
       --HWDATA : out std_logic_vector (31 downto 0); -- AHB write-data
       --HWRITE : out std_logic; -- AHB write control
       --HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data
       --HREADY : out std_logic;
	     --);
    --end component;
    
  COMPONENT CORTEXM0DS 
	PORT(
  -- CLOCK AND RESETS ------------------
  --input  wire        HCLK,              -- Clock
  --input  wire        HRESETn,           -- Asynchronous reset
  HCLK : IN std_logic;              -- Clock
  HRESETn : IN std_logic;           -- Asynchronous reset

  -- AHB-LITE MASTER PORT --------------
  --output wire [31:0] HADDR,             -- AHB transaction address
  --output wire [ 2:0] HBURST,            -- AHB burst: tied to single
  --output wire        HMASTLOCK,         -- AHB locked transfer (always zero)
  --output wire [ 3:0] HPROT,             -- AHB protection: priv; data or inst
  --output wire [ 2:0] HSIZE,             -- AHB size: byte, half-word or word
  --output wire [ 1:0] HTRANS,            -- AHB transfer: non-sequential only
  --output wire [31:0] HWDATA,            -- AHB write-data
  --output wire        HWRITE,            -- AHB write control
  --input  wire [31:0] HRDATA,            -- AHB read-data
  --input  wire        HREADY,            -- AHB stall signal
  --input  wire        HRESP,             -- AHB error response
  HADDR : OUT std_logic_vector (31 downto 0);             -- AHB transaction address
  HBURST : OUT std_logic_vector (2 downto 0);            -- AHB burst: tied to single
  HMASTLOCK : OUT std_logic;         -- AHB locked transfer (always zero)
  HPROT : OUT std_logic_vector (3 downto 0);              -- AHB protection: priv; data or inst
  HSIZE : OUT std_logic_vector (2 downto 0);             -- AHB size: byte, half-word or word
  HTRANS : OUT std_logic_vector (1 downto 0);            -- AHB transfer: non-sequential only
  HWDATA : OUT std_logic_vector (31 downto 0);             -- AHB write-data
  HWRITE : OUT std_logic;            -- AHB write control
  HRDATA : IN std_logic_vector (31 downto 0);            -- AHB read-data
  HREADY : IN std_logic;            -- AHB stall signal
  HRESP : IN std_logic;             -- AHB error response

  -- MISCELLANEOUS ---------------------
  --input  wire        NMI,               -- Non-maskable interrupt input
  --input  wire [15:0] IRQ,               -- Interrupt request inputs
  --output wire        TXEV,              -- Event output (SEV executed)
  --input  wire        RXEV,              -- Event input
  --output wire        LOCKUP,            -- Core is locked-up
  --output wire        SYSRESETREQ,       -- System reset request
  NMI : IN std_logic;               -- Non-maskable interrupt input
  IRQ : IN std_logic_vector (15 downto 0);               -- Interrupt request inputs
  TXEV : OUT std_logic;              -- Event output (SEV executed)
  RXEV : IN std_logic;              -- Event input
  LOCKUP : OUT std_logic;            -- Core is locked-up
  SYSRESETREQ : OUT std_logic;       -- System reset request

  -- POWER MANAGEMENT ------------------
  --output wire        SLEEPING           -- Core and NVIC sleeping
  SLEEPING : OUT std_logic          -- Core and NVIC sleeping
  );
  END COMPONENT; -- end cortexm0 declaration


--declare a component for ahbbridge
--------------AHB Bridge-----------------------------------  
  component AHB_bridge is
	  port (
		   clkm: in std_logic;
		   rstn: in std_logic;
		   ahbi: in ahb_mst_in_type;
       ahbo : out ahb_mst_out_type;
		   HADDR : in std_logic_vector (31 downto 0); -- AHB transaction address
       HSIZE : in std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
       HTRANS : in std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
       HWDATA : in std_logic_vector (31 downto 0); -- AHB write-data
       HWRITE : in std_logic; -- AHB write control
       HRDATA : out std_logic_vector (31 downto 0); -- AHB read-data
       HREADY : out std_logic

	     );
    end component;



  SIGNAL HADDR_sig : std_logic_vector (31 downto 0); -- AHB transaction address
  SIGNAL HSIZE_sig : std_logic_vector (2 downto 0); -- AHB size: byte, half-word or word
  SIGNAL HTRANS_sig : std_logic_vector (1 downto 0); -- AHB transfer: non-sequential only
  SIGNAL HWDATA_sig : std_logic_vector (31 downto 0); -- AHB write-data
  SIGNAL HWRITE_sig : std_logic; -- AHB write control
  SIGNAL HRDATA_sig : std_logic_vector (31 downto 0); -- AHB read-data
  SIGNAL HREADY_sig : std_logic;
  signal HBurst_sig : std_logic_vector (2 downto 0):= "000";
  signal dummy : STD_LOGIC_VECTOR (2 downto 0);
  signal HProt : std_logic_vector (3 downto 0);
  signal Led1 :  STD_LOGIC; -- sleep
  signal Led2 :  STD_LOGIC; -- lock

begin
--instantiate state_machine component and make the connections}
--instantiate state_machine component and make the connections
--instantiate the ahbmst component and make the connections 
--instantiate the data_swapper component and make the connections

---------CortexM0 Port Mapping ---------------------------------
Processor : CORTEXM0DS	port map (
	-- CLOCK AND RESETS ------------------
  HCLK => clkm,              -- Clock
  HRESETn => rstn,           -- Asynchronous reset

  -- AHB-LITE MASTER PORT --------------
  HADDR => HADDR_sig,             -- AHB transaction address
  HBURST =>  HBurst_sig,            -- AHB burst: tied to single (N: 00 because single transfer only)
  HMASTLOCK => dummy(0),        -- AHB locked transfer (always zero)
  HPROT => HProt ,             -- AHB protection: priv; data or inst
  HSIZE => HSize_sig,             -- AHB size: byte, half-word or word
  HTRANS => HTrans_sig ,            -- AHB transfer: non-sequential only
  HWDATA => HWData_sig,            -- AHB write-data
  HWRITE => HWrite_sig,            -- AHB write control
  HRDATA => HRData_sig,            -- AHB read-data
  HREADY => HREADY_sig,            -- AHB stall signal
  HRESP => '0',             -- AHB error response

  -- MISCELLANEOUS ---------------------
  NMI => '0',               -- Non-maskable interrupt input
  IRQ => "0000000000000000", --Interrupciones(15 downto 0),               -- Interrupt request inputs
  TXEV => dummy(1),              -- Event output (SEV executed)
  RXEV => '0',              -- Event input
  LOCKUP => Led2,            -- Core is locked-up
  SYSRESETREQ => dummy(2),       -- System reset request

  -- POWER MANAGEMENT ------------------
  SLEEPING => Led1           -- Core and NVIC sleeping
	);


---------AHB Bridge Port Mapping ---------------------------------
  AHB_bridge_comp: AHB_bridge port map(clkm, rstn, ahbmi, ahbmo, HADDR_sig, HSIZE_sig, HTRANS_sig, HWDATA_sig, HWRITE_sig, HRDATA_sig ,HREADY_sig);
    
end structural;
 
