
library ieee;
use ieee.numeric_bit.to_integer,ieee.numeric_bit.unsigned;
use work.isa.all;

entity decoder is
	port(instruction_word : in bit_vector(31 downto 0);
		  mbr_mux : out bit;
		  condition : out cond_op;
		  alu_operation : out alu_op;
		  shifter_operation : out shifter_op;
		  mbr_enable,mar_enable,rd_wr,memory_select,sbus_enable : out bit;
		  sbus,bbus,abus : out bus_operand;
		  address : out bit_vector(7 downto 0));
end entity;


architecture combinational of decoder is

	function to_bus_operand(bit_pattern : bit_vector(3 downto 0)) return bus_operand is
	
	begin
		return bus_operand'VAL(to_integer(unsigned(bit_pattern)));
	end function;
	
begin

	mbr_mux <= instruction_word(31);
	
	condition <= cond_op'VAL(to_integer(unsigned(instruction_word(30 downto 29))));
					 
	alu_operation <= alu_op'VAL(to_integer(unsigned(instruction_word(28 downto 27))));
						  
	assert instruction_word(26 downto 25) /= B"11" report "Invalid bit pattern 11 for shifter operation";
						  
	shifter_operation <= shifter_op'VAL(to_integer(unsigned(instruction_word(26 downto 25))));
								
	(mbr_enable, mar_enable, rd_wr,memory_select,sbus_enable) <= instruction_word(24 downto 20);
	
	sbus <= to_bus_operand(instruction_word(19 downto 16));
	bbus <= to_bus_operand(instruction_word(15 downto 12));
	abus <= to_bus_operand(instruction_word(11 downto 8));
	address <= instruction_word(7 downto 0);
							
end architecture;