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
    constant FULL_COUNT : integer:= 100e6 / 115200;
    constant HALF_COUNT : integer:= FULL_COUNT / 2;
    signal bit_count: integer range 0 to 7 := 0;
    signal flag_count : integer range 0 to 10 := 5;
    signal f_count : integer range 0 to FULL_COUNT:= FULL_COUNT;
    signal data_buffer : std_logic_vector(7 downto 0);


begin
    process(clk,reset)
        begin
            if reset='1' then 
                state_rx <= IDLE;
                ready <= '0';
                bit_count<= 0 ;
                data_buffer <= x"00";
                flag_count <= 5;
            elsif rising_edge(clk) then
                case state_rx is  
                    when IDLE =>
                        flag_count <= 5;
                        ready <= '0'; 
                        state_rx <= IDLE;
                        ready <= '0';
                        bit_count<= 0 ;
                        data_buffer <= x"00";
                        if sdata = '0' then
                            state_rx <= START_BIT;
                        else
                            state_rx <= IDLE;
                        end if;
                        
                    when START_BIT =>
                        f_count <= FULL_COUNT;
                        if f_count <= half_count and sdata = '0' then 
                            state_rx <= DATA;
                            f_count <= FULL_COUNT;
                            ready <= '0'; 
                        else 
                            f_count <= f_count - 1;
                        end if;
                    when DATA =>
                        if  bit_count <= 7 and f_count = 0 then 
                            data_buffer(bit_count) <= sdata;
                            bit_count <= bit_count + 1;
                            f_count <= FULL_COUNT;
                        elsif bit_count = 8 then
                            state_rx <= STOP_BIT;
                            f_count <= FULL_COUNT;
                        else
                            f_count <= f_count - 1;
                        end if;
                    when STOP_BIT=>
                        if f_count <= 0 then 
                            pdata <= data_buffer;
                            if flag_count <= 0 then 
                                state_rx <= IDLE;
                                ready <= '0';
                            else 
                                flag_count <= flag_count - 1;
                                ready <= '1';
                            end if;
                        else
                            f_count <= f_count - 1;
                        end if;
                end case;
            end if;
    end process;
end Behavioral;