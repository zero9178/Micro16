
library work;
use work.isa.all;

entity decoder is
	port(instruction_word : in bit_vector(31 downto 0);
		  mbr_mux : out bit;
		  condition : out cond_op;
		  alu_operation : out alu_op;
		  shifter_operation : out shifter_op;
		  mbr_enable,mar_enable,rd_wr,memory_select,sbus_enable : out bit);
end entity;




architecture combinational of decoder is

begin


end architecture;