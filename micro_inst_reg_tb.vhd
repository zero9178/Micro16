
entity micro_inst_reg_tb is
end entity;

architecture test of micro_inst_reg_tb is

	constant T : time := 20 ns;
	
	signal jump_address,output : bit_vector(7 downto 0);
	signal clk,do_jump,rst : bit;
	
begin

	dut : entity work.micro_inst_reg
					port map(jump_address => jump_address,
								clk => clk,
								do_jump => do_jump,
								rst => rst,
								output => output);

	process is
	begin
		
		clk <= '0';
		jump_address <= X"00";
		do_jump <= '0';
		rst <= '0';
		wait for T;
		assert output = X"00";
		
		rst <= '1';
		wait for T;
		assert output = X"00";
		
		clk <= '1';
		wait for T;
		clk <= '0';
		assert output = X"01";
		wait for T;
		
		clk <= '1';
		wait for T;
		clk <= '0';
		assert output = X"02";
	
		jump_address <= X"55";
		do_jump <= '1';
		wait for T;
		assert output = X"02";
		clk <= '1';
		wait for T;
		assert output = X"55";
		clk <= '0';
		do_jump <= '0';
		wait for T;
		clk <= '1';
		wait for T;
		assert output = X"56";
	
		wait;
	end process;

end architecture;