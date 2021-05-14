
library ieee;
use ieee.numeric_bit.all;

entity micro_inst_reg is
	port(jump_address : in bit_vector(7 downto 0);
		  clk,do_jump : in bit;
		  rst : in bit := '1';
		  output : out bit_vector(7 downto 0 ));
end entity;

architecture behavioural of micro_inst_reg is

	subtype bv is bit_vector(7 downto 0);

	signal next_addr,this_addr : bv;
begin

	count_reg : entity work.reg
						port map(input => next_addr,
									clk => clk,
									rst => rst,
									output => this_addr);
									
	next_addr <= jump_address when do_jump = '1' else bv(unsigned(this_addr) + 1);
	output <= this_addr;

end architecture;