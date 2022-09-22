library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;   

 
entity receiver is
    port ( clk : in std_logic; -- clock input
    reset : in std_logic; -- reset, active high
    sdata : in std_logic; -- serial data in
    pdata : out std_logic_vector(7 downto 0); -- parallel data out
    ready : out std_logic); -- ready strobe, active high
end receiver;

architecture Behavioral of receiver is
    type STATES is (IDLE, START_BIT, DATA, STOP_BIT);    
    signal state_rx : STATES := IDLE;
    signal parallel_data : std_logic_vector(7 downto 0);
    constant FULL_COUNT : natural:= 100e6 / 115200;
    constant HALF_COUNT : natural:= FULL_COUNT / 2;
    signal p_data_count : std_logic_vector(7 downto 0);
    signal bit_count: natural range 0 to 7 := 0;
    signal h_count : natural range 0 to HALF_COUNT:= HALF_COUNT;
    signal f_count : natural range 0 to FULL_COUNT:= FULL_COUNT;


begin
    process(clk,reset)
        
        begin
            if reset='1' then 
                state_rx <= IDLE;
                ready <= '1';
                bit_count<= 0 ;
            elsif rising_edge(clk) then
                case state_rx is  
                    when IDLE =>
                        if sdata = '0' then
                            state_rx <= START_BIT;
                            ready <= '0'; 
                            --bit_count:=0;
                        else
                            state_rx <= IDLE;
                            ready <= '0'; 
                            --bit_count:=0;
                        end if;
                    when START_BIT =>
                        if h_count = 0 and sdata = '0' then 
                            state_rx <= DATA;
                            ready <= '0'; 
                        else 
                            h_count <= h_count - 1;
                        end if;
                    when DATA =>
                        if  bit_count <= 7 and f_count = 0 then 
                            pdata(bit_count) <= sdata;
                            bit_count <= bit_count + 1;
                           -- wait thing here
                        elsif bit_count = 8 then
                            state_rx <= STOP_BIT;
                            f_count <= FULL_COUNT;
                            h_count <= 1;
                        else
                            -- state_rx <= IDLE;
                            -- ready <= '0'; 
                            f_count <= f_count - 1;
                        end if;
                    when STOP_BIT=>
                        if f_count <= 0 then 
                            if h_count <= 0 then 
                                ready <= '0';   
                                state_rx <= IDLE;
                            else 
                                h_count <= h_count - 1;
                                ready <= '1';
                            end if;
                        else
                            f_count <= f_count - 1;
                        end if;
                end case;
            end if;
    end process;
end Behavioral;