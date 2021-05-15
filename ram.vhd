
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;
use work.isa.all;

entity ram is
    port(clk, write_enable : in bit;
         address : in unsigned;
         write_data : in bit_vector;
         read_data : out bit_vector);
end entity;

architecture behavioural of ram is

    type memory_t is array (0 to 2**16 - 1) of bit_vector(write_data'length - 1 downto 0);
    signal memory : memory_t;
    
begin

    rd_wr : process(clk) is
    begin
        if rising_edge(clk) then
            read_data <= memory(to_integer(address));
            
            if write_enable = '1' then
                memory(to_integer(address)) <= write_data;
            end if;
        end if;
    end process;
    
end architecture;