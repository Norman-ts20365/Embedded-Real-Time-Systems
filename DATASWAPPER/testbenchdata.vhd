library ieee;
use ieee.std_logic_1164.all;


entity tb_data_swapper is
end tb_data_swapper;

architecture tb of tb_data_swapper is
  component data_swapper is
   port(
     dmao:in  std_logic_vector (31 downto 0);
     HRDATA:out std_logic_vector (31 downto 0)); 
   end component;

  signal Dmao :std_logic_vector (31 downto 0);
  signal hrdataa :std_logic_vector (31 downto 0);
 
  begin 
  DUT : entity work.data_swapper 
   port map (
     dmao => Dmao,
     HRDATA => hrdataa
     ); 
     
  process begin 
    wait for 20ns; 
    --Dmao <= "11110000111100001111000011110000";
    Dmao <= "00010011000100010001001000010100";
    wait;
  end process; 
  
end architecture tb;