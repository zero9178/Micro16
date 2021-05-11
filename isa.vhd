
package isa is

	type alu_op is (alu_abus,alu_add,alu_and,alu_neg);
	
	type cond_op is (cond_no_jump,cond_neg,cond_zero,cond_none);
	
	type shifter_op is (shifter_noop,shifter_left,shifter_right);
	
	
end package;
