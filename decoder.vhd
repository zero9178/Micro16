
library work;
use work.isa.all;

entity decoder is
	port(instruction_word : in bit_vector(31 downto 0);
		  mbr_mux : out bit;
		  condition : out cond_op;
		  alu_operation : out alu_op;
		  shifter_operation : out shifter_op;
		  mbr_enable,mar_enable,rd_wr,memory_select,sbus_enable : out bit;
		  sbus,bbus,abus : out bit_vector(3 downto 0);
		  address : out bit_vector(7 to 0));
end entity;


architecture combinational of decoder is

begin

	mbr_mux <= instruction_word(31);
	
	condition <= cond_no_jump when instruction_word(30 downto 29) = B"00" else
					 cond_neg when instruction_word(30 downto 29) = B"01" else
					 cond_zero when instruction_word(30 downto 29) = B"10" else
					 cond_none;
					 
	alu_operation <= alu_abus when instruction_word(28 downto 27) = B"00" else
						  alu_add when instruction_word(28 downto 27) = B"01" else
						  alu_and when instruction_word(28 downto 27) = B"10" else
					     alu_neg;
						  
	assert instruction_word(26 downto 25) /= B"11" report "Invalid bit pattern 11 for shifter operation";
						  
	shifter_operation <= shifter_noop when instruction_word(26 downto 25) = B"00" else
								shifter_left when instruction_word(26 downto 25) = B"01" else
								shifter_right;
								
	(mbr_enable, mar_enable, rd_wr,memory_select,sbus_enable) <= instruction_word(24 downto 20);
	
	sbus <= instruction_word(19 downto 16);
	bbus <= instruction_word(15 downto 12);
	abus <= instruction_word(11 downto 8);
	address <= instruction_word(7 downto 0);
							
end architecture;