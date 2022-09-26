--##lab1.vhd (top file)##

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab1 is
  Port (clk, rst, sdata : in std_logic;
        LED_out : out std_logic_vector(7 downto 0));
end lab1;

architecture Behavioral of lab1 is

component receiver is
     port ( clk : in std_logic; -- clock input
    reset : in std_logic; -- reset, active high
    sdata : in std_logic; -- serial data in
    pdata : out std_logic_vector(7 downto 0); -- parallel data out
    ready : out std_logic); -- ready strobe, active high
end component;

signal pdata_i : std_logic_vector(7 downto 0);
signal ready_i : std_logic;
signal state_i : std_logic_vector(1 downto 0);

begin

uut: receiver port map(clk => clk,
                       reset => rst,
                       sdata => sdata,
                       pdata => pdata_i,
                       ready => ready_i);
                      

process(ready_i)
begin
    if ready_i = '1' then
        LED_out <= pdata_i;
    end if;
end process;

end Behavioral;

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


--entity UART_Rx_Top is
--     Port (clk, rst, sdata : in std_logic;
--               LED_out : out std_logic_vector(7 downto 0) );
--end UART_Rx_Top;

--architecture Behavioral of UART_Rx_Top is
--component receiver is
--    port ( clk : in std_logic; -- clock input
--    reset : in std_logic; -- reset, active high
--    sdata : in std_logic; -- serial data in
--    pdata : out std_logic_vector(7 downto 0); -- parallel data out
--    ready : out std_logic); -- ready strobe, active high
--end component;

--signal clkin: std_logic;
--signal rst_in: std_logic;
--signal sdata_in: std_logic;
--signal data_out: std_logic_vector(7 downto 0);
--signal rdy: std_logic;


--begin
--R: receiver port map(    clk => clk,
--                         reset => rst,
--                         sdata => sdata,
--                         pdata => LED_out,
--                         ready => rdy);
 
--end Behavioral;