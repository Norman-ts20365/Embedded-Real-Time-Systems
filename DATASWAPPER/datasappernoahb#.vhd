library ieee;
use ieee.std_logic_1164.all;


entity data_swapper is
port(
     dmao:in  std_logic_vector (31 downto 0) ;
     HRDATA:out std_logic_vector (31 downto 0)); 
end data_swapper;

architecture data_swapper_arch of data_swapper is 
Type data_list is array (0 to 3) of std_logic_vector ( 7 downto 0); 

begin 
  swapping: process(dmao)
     variable data_list_original: data_list; 
     variable data_list_swapped: data_list;
     variable data_list_sum: std_logic_vector(31 downto 0); 
     begin
          data_list_original(0):= dmao(7 downto 0);
          data_list_original(1):= dmao(15 downto 8);
          data_list_original(2):= dmao(23 downto 16);
          data_list_original(3):= dmao(31 downto 24);
          data_list_swapped(0):=  data_list_original(3);
          data_list_swapped(1):=  data_list_original(2);
          data_list_swapped(2):=  data_list_original(1);
          data_list_swapped(3):= data_list_original(0);
          data_list_sum(7 downto 0):= data_list_swapped(0); 
          data_list_sum(15 downto 8):= data_list_swapped(1);
          data_list_sum(23 downto 16):= data_list_swapped(2); 
          data_list_sum(31 downto 24):= data_list_swapped(3);
          HRDATA <= data_list_sum;     
   end process swapping;
          
end data_swapper_arch; 

