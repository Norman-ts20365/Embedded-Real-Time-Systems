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

ENTITY STATE_MACHINE IS
  PORT(
  -- Clock and Reset -----------------
 clkm : in std_logic;
 rstn : in std_logic;
 
  -- AHBLITE Master records --------------
 dmai : out ahb_dma_in_type;
 dmao : in ahb_dma_out_type;
 
  -- AHBBridge to StateMachine ----------------------------
 HADDR  : IN std_logic_vector (31 downto 0);   -- AHBLITE transaction address
 HSIZE  : IN std_logic_vector (2 downto 0);    -- AHBLITE size: byte, half-word or word
 HTRANS : IN std_logic_vector (1 downto 0);   -- AHBLITE transfer: non-sequential only
 HWDATA : IN std_logic_vector (31 downto 0);  -- AHBLITE write-data
 HWRITE : IN std_logic;                       -- AHBLITE write control
 HREADY : OUT std_logic                      -- AHBLITE stall signal
 );
END STATE_MACHINE;



ARCHITECTURE structural of STATE_MACHINE is
  
  SIGNAL reg_dmai_start : std_logic;
  
  TYPE state_type IS (IDLE,INSTR_FETCH);
    SIGNAL curState, nextState: state_type;
    
    BEGIN
    
    dmai.start <= reg_dmai_start;
    
    --------- Next State Logic -----------------------------
    next_state_logic: PROCESS(curState,dmao,HTRANS)
      BEGIN
        CASE curState IS
          WHEN IDLE =>
            IF HTRANS = "10" THEN
              reg_dmai_start <= '1';
              nextState <= INSTR_FETCH;
              
            ELSE
              nextState <= curState;
            END IF;
            
          WHEN INSTR_FETCH =>
            IF dmao.ready = '1' THEN
              HREADY <= '1';
              nextState <= IDLE;
              
            ELSE
              nextState <= curState;
            END IF;
          END CASE;
        END PROCESS; -- Next state logic
        
      ------- State Register -----------------------------------------
      state_register: PROCESS(clkm,rstn)
        BEGIN
          IF rstn = '1' THEN
            curState <= INSTR_FETCH;
          ELSIF clkm'event AND clkm = '1' THEN
            curState <= nextState;
          END IF;
        END PROCESS; -- Next state clock
      
      
      ------- Output State Logic ------------------------------
      out_state: PROCESS(curState)
      BEGIN
        IF curState = IDLE THEN
          HREADY <= '1';
          reg_dmai_start <= '0';
        ELSE
           HREADY <= '0';
          reg_dmai_start <= '0';
        END IF;
      END PROCESS; -- Output STate Logic
          
      
      
      
      END;
