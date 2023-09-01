-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_traffic_light_controller is
end tb_traffic_light_controller;

architecture driver of tb_traffic_light_controller is
    -- Component Declaration for the traffic light controller 
    Component tlight
     port(NS,EW : out std_logic_vector(1 downto 0);
		  SEN,CK: in std_logic;
          SW: inout std_logic);
    end component;
   signal sensor : std_logic := '0';
   signal clk : std_logic := '0';
   signal tb_sw : std_logic  := '0';
  --Outputs
   signal tb_NS : std_logic_vector(1 downto 0);--
   signal tb_EW : std_logic_vector(1 downto 0);--
   constant clk_period : time := 1000000000 ns;
   
   

-- Instantiate the traffic light controller
begin

   UUT:tlight PORT MAP (
          SEN => sensor ,
          CK => clk,
          SW => tb_sw,
          NS => tb_NS,
          EW => tb_EW);
   --Clock process definitions
 
process
  begin
   for i in 1 to 660 loop
    clk <= not clk;
      wait for 500000000 ns;
      clk <= not clk;
      wait for 500000000 ns;
     --  clock period <= 10 ns
    end loop;
    wait;
 end process;
   
  
   

sensor<= '1' after 90000000000 ns;--, '0' after 180 ns;
end driver;
