
library ieee;
use ieee.numeric_bit.all;
use work.isa.all;

entity alu_tb is
end entity;

architecture test of alu_tb is

constant T : time := 20 ns;

signal operation : alu_op;
signal a_operand,b_operand,s_operand : data_word;
signal negative_flag,zero_flag : bit;

begin

	alu : entity work.alu
				port map(operation => operation,
							a_operand => a_operand,
							b_operand => b_operand,
							s_operand => s_operand,
							negative_flag => negative_flag,
							zero_flag => zero_flag);
							
	process is
	
	begin
	
		-- Testing a passthrough and no flags
		operation <= alu_abus;
		a_operand <= X"0007";
		wait for T;
		assert s_operand = 7;
		assert negative_flag = '0';
		assert zero_flag = '0';
		
		-- Testing flags
		operation <= alu_abus;
		a_operand <= X"FFF9";
		wait for T;
		assert (not s_operand) + 1 = 7;
		assert negative_flag = '1';
		assert zero_flag = '0';
		
		operation <= alu_abus;
		a_operand <= X"0000";
		wait for T;
		assert s_operand = 0;
		assert negative_flag = '0';
		assert zero_flag = '1';
		
		-- Addition
		operation <= alu_add;
		a_operand <= to_unsigned(8, data_word_size);
		b_operand <= to_unsigned(5, data_word_size);
		wait for T;
		assert s_operand = 13;
		assert negative_flag = '0';
		assert zero_flag = '0';
		
		-- Two complement
		operation <= alu_add;
		a_operand <= to_unsigned(7, data_word_size);
		b_operand <= (not to_unsigned(5, data_word_size)) + 1;
		wait for T;
		assert s_operand = 2;
		assert negative_flag = '0';
		assert zero_flag = '0';
		
		operation <= alu_add;
		a_operand <= to_unsigned(5, data_word_size);
		b_operand <= (not to_unsigned(7, data_word_size)) + 1;
		wait for T;
		assert (not s_operand) + 1 = 2;
		assert negative_flag = '1';
		assert zero_flag = '0';
		
		-- And
		operation <= alu_and;
		a_operand <= to_unsigned(11, data_word_size);
		b_operand <= to_unsigned(5, data_word_size);
		wait for T;
		assert s_operand = 1;
		assert negative_flag = '0';
		assert zero_flag = '0';
		
		-- Not
		operation <= alu_neg;
		a_operand <= to_unsigned(11, data_word_size);
		wait for T;
		assert not s_operand = 11;
		assert negative_flag = '1';
		assert zero_flag = '0';
		
		operation <= alu_neg;
		a_operand <= not to_unsigned(11, data_word_size);
		wait for T;
		assert s_operand = 11;
		assert negative_flag = '0';
		assert zero_flag = '0';
	
		wait;
	end process;

end architecture;