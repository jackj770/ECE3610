library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver_tb is
--  Port ( );
end receiver_tb;

architecture Behavioral of receiver_tb is
component receiver is
    port ( clk : in std_logic; -- clock input
    reset : in std_logic; -- reset, active high
    sdata : in std_logic; -- serial data in
    pdata : out std_logic_vector(7 downto 0); -- parallel data out
    ready : out std_logic); -- ready strobe, active high
end component;
signal clk_tb, reset_tb, ready_tb: std_logic:= '0';
signal sdata_tb : std_logic:= '1';
signal pdata_tb: std_logic_vector(7 downto 0);
constant BIT_PERIOD: time := 8680ns;-- 868E-6; 

procedure TX_BITS(
        data : in std_logic_vector(7 downto 0);
        signal tx_serial : out std_logic) is
    begin
        tx_serial <= '0';
        wait for BIT_PERIOD; -- BIT_PERIOD is a constant that you need to calculate
        
        for ii in 0 to 7 loop
            tx_serial <= data(ii);
            wait for BIT_PERIOD;
        end loop;
         
        tx_serial <= '1';
        wait for BIT_PERIOD;
         
    end TX_BITS;
begin
clk_tb<= not clk_tb after 5ns;
UUT: receiver port map( clk => clk_tb,
                  reset=> reset_tb,
                  sdata=> sdata_tb,
                  pdata=> pdata_tb,
                  ready=> ready_tb);


process
begin
wait for BIT_PERIOD;
TX_BITS(x"AB", sdata_tb);
-- wait until falling_edge(clk_tb);
TX_BITS(x"C5", sdata_tb);
wait for 50 us;
TX_BITS(x"55", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"26", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"24", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"12", sdata_tb);
-- TX_BITS(x"00", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"16", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"26", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"24", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"12", sdata_tb);
-- TX_BITS(x"00", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"16", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"26", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"24", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"12", sdata_tb);
-- TX_BITS(x"00", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"16", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"26", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"24", sdata_tb);
-- wait until falling_edge(clk_tb);
-- TX_BITS(x"12", sdata_tb);
--wait until rising_edge(clk_tb);
--TX_BITS(x"00", sdata_tb);
--wait until rising_edge(clk_tb);
--TX_BITS(x"18", sdata_tb);
--wait until rising_edge(clk_tb);
--TX_BITS(x"56", sdata_tb);
--wait until rising_edge(clk_tb);
--TX_BITS(x"18", sdata_tb);
--wait until rising_edge(clk_tb);
--TX_BITS(x"56", sdata_tb);
wait;
end process;
end Behavioral;
