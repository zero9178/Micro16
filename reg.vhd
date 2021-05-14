
library ieee;
use ieee.numeric_bit.all;

entity reg is
    port(input : in bit_vector;
         clk : in bit;
         rst : in bit := '1';
         output : out bit_vector);
end entity;

architecture behaviour of reg is
    signal mem : bit_vector(input'RANGE);
begin

    changes : process (clk,rst) is
    begin
        if rst = '0' then
            mem <= (others => '0');
        elsif rising_edge(clk) then
            mem <= input;
        end if;
    end process;
    
    output <= mem;

end architecture;