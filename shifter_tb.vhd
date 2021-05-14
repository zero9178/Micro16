
library ieee;
use ieee.numeric_bit.all;
use work.isa.all;

entity shifter_tb is
end entity;

architecture test of shifter_tb is
	constant T : time := 20 ns;
	
	signal input,result : data_word;
	signal operation : shifter_op;
	
begin

	dut : entity work.shifter
				port map(operand => input,
							shifter_operation => operation,
							result => result);

	process is
	begin
	
		input <= X"0002";
		operation <= shifter_noop;
		wait for T;
		assert result = X"0002";
		
		operation <= shifter_left;
		wait for T;
		assert result = X"0004";
		
		operation <= shifter_right;
		wait for T;
		assert result = X"0001";
		
		-- is logical shift
		input <= X"FFFF";
		operation <= shifter_right;
		wait for T;
		assert result = X"7FFF";
	
		wait;
	end process;

end architecture;