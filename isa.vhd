
library ieee;
use ieee.numeric_bit.all;

package isa is

	type alu_op is (alu_abus,alu_add,alu_and,alu_neg);
	
	type cond_op is (cond_no_jump,cond_neg,cond_zero,cond_none);
	
	type shifter_op is (shifter_noop,shifter_left,shifter_right);
	
	type bus_operand is ('0','1',neg_one,pc,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,ac);
	
	constant data_word_size : natural := 16;
	
	subtype data_word is unsigned(data_word_size - 1 downto 0);
	
end package;
