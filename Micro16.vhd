
library ieee;
use ieee.std_logic_1164.all;
use work.isa.all;

entity Micro16 is
	port(clk: in bit;
		  rom_address : out bit_vector(7 downto 0);
		  instruction : in bit_vector(31 downto 0);
		  address_bus : out bit_vector(data_word'RANGE);
		  rd_wr,memory_select : out bit;
		  data_bus : inout std_logic_vector(data_word'RANGE);
		  rst : in bit := '1');
end entity;

architecture behavioural of Micro16 is

	signal clock1,clock2,clock3,clock4 : bit;
	
	signal internal_instruction : bit_vector(31 downto 0);
	signal internal_rd_wr,mbr_mux,mbr_enable,mar_enable,sbus_enable : bit;
	signal condition : cond_op;
	signal alu_operation : alu_op;
	signal shifter_operation : shifter_op;
	signal sbus_select,bbus_select,abus_select : bus_operand;
	signal address : bit_vector(7 downto 0);
	
	signal do_jump,negative_flag,zero_flag : bit;
	
	signal abus,bbus,sbus,a_reg_out,mbr_out : data_word;
	
	signal alu_a_in,alu_b_in : bit_vector(data_word'RANGE);
	signal alu_out : data_word;
	
	signal mar_clock : bit;
	
begin

	phaser : entity work.clock_phase
					port map(clk => clk,
								phases(3) => clock1,
								phases(2) => clock2,
								phases(1) => clock3,
								phases(0) => clock4);
								
	instruction_reg : entity work.reg
								port map(input => instruction,
											clk => clock1,
											rst => rst,
											output => internal_instruction);
								
	decoder : entity work.decoder
					port map(instruction_word => internal_instruction,
								mbr_mux => mbr_mux,
								condition => condition,
								alu_operation => alu_operation,
								shifter_operation => shifter_operation,
								mbr_enable => mbr_enable,
								mar_enable => mar_enable,
								rd_wr => internal_rd_wr,
								memory_select => memory_select,
								sbus_enable => sbus_enable,
								sbus => sbus_select,
								bbus => bbus_select,
								abus => abus_select,
								address => address);
								
	rd_wr <= internal_rd_wr;
								
	mic : entity work.micro_inst_reg
				port map(jump_address => address,
							clk => clock4,
							do_jump => do_jump,
							rst => rst,
							output => rom_address);
							
	reg_bank : entity work.register_bank
						port map(s_result => sbus,
									s_select => sbus_select,
									b_select => bbus_select,
									a_select => abus_select,
									clk => clock4,
									write_enable => sbus_enable,
									rst => rst,
									a_out => a_reg_out,
									b_out => bbus);
									
	mbr : entity work.memory_buffer
				port map(clk => clock3,
							rst => rst,
							rd_wr => internal_rd_wr,
							enable => mbr_enable,
							input => sbus,
							bus_com => data_bus,
							output => mbr_out);
							
	abus <= a_reg_out when mbr_mux = '0' else mbr_out;
		

	a_reg : entity work.reg
				port map(input => bit_vector(abus),
							rst => rst,
							clk => clock2,
							output => alu_a_in);
							
	b_reg : entity work.reg
				port map(input => bit_vector(bbus),
							rst => rst,
							clk => clock2,
							output => alu_b_in);
		
	alu : entity work.alu
				port map(operation => alu_operation,
							a_operand => data_word(alu_a_in),
							b_operand => data_word(alu_b_in),
							s_result => alu_out,
							negative_flag => negative_flag,
							zero_flag => zero_flag);
							
	micro_seq : entity work.micro_seq
						port map(condition => condition,
									negative_flag => negative_flag,
									zero_flag => zero_flag,
									do_jump => do_jump);
									
	shifter : entity work.shifter
					port map(operand => alu_out,
								shifter_operation => shifter_operation,
								result => sbus);
								
	mar_clock <= clock3 and mar_enable;
								
	mar : entity work.reg
				port map(input => bit_vector(bbus),
							clk => mar_clock,
							output => address_bus);

end architecture;
