
library ieee;
use ieee.numeric_bit.rising_edge,ieee.numeric_bit.falling_edge;

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
		if falling_edge(rst) then
			mem <= (others => '0');
		elsif rising_edge(clk) then
			mem <= input;
		end if;
	end process;
	
	output <= mem;

end architecture;