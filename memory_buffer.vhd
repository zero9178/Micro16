
library ieee;
use ieee.std_logic_1164.all;
use work.isa.all;

entity memory_buffer is
	port(clk,rd_wr,enable : in bit;
		  rst : in bit := '1';
		  input : in data_word;
		  bus_com : inout std_logic_vector(data_word'RANGE);
		  output : out data_word);
end entity;

architecture behavioural of memory_buffer is

	subtype bv is bit_vector(data_word'RANGE);

	signal enabled_clk : bit;
	signal reg_output : bv;
	signal reg_input : bv;

begin
	
	reg : entity work.reg
				port map(clk => enabled_clk,
							rst => rst,
							input => reg_input,
							output => reg_output);
							
	output <= data_word(reg_output);
	enabled_clk <= clk and (enable or rd_wr);
	
	reg_input <= to_bitvector(bus_com) when rd_wr = '1' else bv(input);
	bus_com <= to_stdLogicVector(reg_output) when rd_wr = '0' else (others => 'Z');
	
end architecture;