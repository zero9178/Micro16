
library ieee;
use ieee.numeric_bit.all;
use work.isa.all;

entity shifter is
	port(operand : in data_word;
		  shifter_operation : in shifter_op;
		  result : out data_word);
end entity;

architecture behavioural of shifter is

begin

	with shifter_operation select
		result <= operand when shifter_noop,
					 shift_left(operand,1) when shifter_left,
					 shift_right(operand,1) when shifter_right;

end architecture;