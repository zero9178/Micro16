
library ieee;
use ieee.numeric_bit.all;
use work.isa.all;

entity register_bank_tb is
end entity;

architecture test of register_bank_tb is

	constant T : time := 20 ns;
	
	signal s_result,a_out,b_out : data_word;
	signal s_select,b_select,a_select : bus_operand;
	signal clk,write_enable,rst : bit;

begin

	dut : entity work.register_bank
				port map(s_result => s_result,
							s_select => s_select,
							b_select => b_select,
							a_select => a_select,
							clk => clk,
							write_enable => write_enable,
							rst => rst,
							a_out => a_out,
							b_out => b_out);

	process is
	begin
	
		-- Reset
		rst <= '0';
		wait for T;
		rst <= '1';
		
		-- Reading constants
		
		-- -1
		a_select <= neg_one;
		b_select <= neg_one;
		wait for T;
		assert a_out = X"FFFF";
		assert b_out = X"FFFF";
		
		-- 0
		a_select <= '0';
		b_select <= '0';
		wait for T;
		assert a_out = X"0000";
		assert b_out = X"0000";
		
		-- 1
		a_select <= '1';
		b_select <= '1';
		wait for T;
		assert a_out = X"0001";
		assert b_out = X"0001";
		
		-- Writing
		for i in r0 to ac loop
			s_result <= to_unsigned(bus_operand'POS(i),data_word_size);
			clk <= '1';
			write_enable <= '1';
			s_select <= i;
			wait for T;
			clk <= '0';
			s_result <= (others => '0');
			write_enable <= '0';
			s_select <= '0';
			wait for T;
		end loop;
		
		-- Reading
		b_select <= '0';
		for i in r0 to ac loop
			a_select <= i;
			wait for T;
			assert a_out = to_unsigned(bus_operand'POS(i),data_word_size);
			assert b_out = X"0000";
		end loop;
		
		a_select <= '0';
		for i in r0 to ac loop
			b_select <= i;
			wait for T;
			assert b_out = to_unsigned(bus_operand'POS(i),data_word_size);
			assert a_out = X"0000";
		end loop;
	
		-- Reset
		rst <= '0';
		wait for T;
		rst <= '1';
		for i in r0 to ac loop
			a_select <= i;
			b_select <= i;
			wait for T;
			assert a_out = X"0000";
			assert b_out = X"0000";
		end loop;
	
		wait;
	end process;

end architecture;