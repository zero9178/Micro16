
library ieee;
use ieee.numeric_bit.all;

entity clock_phase is
	port(clk : in bit;
		  phases : out bit_vector);
end entity;

architecture behavioural of clock_phase is
begin

	process(clk) is
		variable var : bit_vector(phases'RANGE) := (0 => '1',others => '0');
	begin
		if rising_edge(clk) then
			phases <= var;
			var := var rol 1;
		end if;
	end process;

end architecture;