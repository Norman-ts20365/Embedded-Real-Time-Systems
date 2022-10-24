library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity led_blink is 
  port( 
     led : out std_logic; 
     data : in  std_logic_vector (31 downto 0);
     clk : in std_logic; 
     reset: in std_logic); 
end led_blink ; 

architecture behavioural of led_blink is 
  component DetectorBus is
    Port ( Clock : in  STD_LOGIC;
           DataBus : in  STD_LOGIC_VECTOR (31 downto 0);
           Detector : out  STD_LOGIC);
  end component;
  
  begin
  Inst_Detector: DetectorBus 
    Port map ( Clock => clk,
           DataBus => data,
           Detector => led);
 
  
end behavioural; 
