library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART_Rx_Top is
     Port (clk, rst, sdata : in std_logic;
               LED_out : out std_logic_vector(7 downto 0) );
end UART_Rx_Top;

architecture Behavioral of UART_Rx_Top is
component receiver is
    port ( clk : in std_logic; -- clock input
    reset : in std_logic; -- reset, active high
    sdata : in std_logic; -- serial data in
    pdata : out std_logic_vector(7 downto 0); -- parallel data out
    ready : out std_logic); -- ready strobe, active high
end component;

signal clkin: std_logic;
signal rst_in: std_logic;
signal sdata_in: std_logic;
signal data_out: std_logic_vector(7 downto 0);
signal rdy: std_logic;


begin
R: receiver port map( clk=> clkin ,
                             reset=> rst_in,
                             sdata=> sdata_in,
                             pdata=> data_out,
                             ready=> rdy);
BigBoy : UART_Rx_Top port map (clk => clkin,
                                rst => rst_in,
                                sdata => sdata_in,
                                LED_out => data_out);



end Behavioral;

