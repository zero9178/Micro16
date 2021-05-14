
entity reg_tb is
end entity;

architecture test of reg_tb is

	constant T : time := 20 ns;
	signal input,output : bit_vector(15 downto 0);
	signal clk,rst : bit;

begin

	dut : entity work.reg
			port map(input => input,
						clk => clk,
						rst => rst,
						output => output);
						
						
	process is
	begin
	
		-- Initial states
		rst <= '1';
		clk <= '0';
		wait for T;
		
		-- Start with a reset
		rst <= '0';
		wait for T;
		rst <= '1';
		assert output = X"0000";
		wait for T;
		
		-- Holds input
		input <= X"5757";
		clk <= '1';
		wait for T;
		input <= X"0000";
		clk <= '0';
		wait for T;
		assert output = X"5757";
		
		-- Change once again
		input <= X"7575";
		clk <= '1';
		wait for T;
		input <= X"0000";
		clk <= '0';
		wait for T;
		assert output = X"7575";
		
		-- Reset
		rst <= '0';
		wait for T;
		rst <= '1';
		assert output = X"0000";
		
		wait;
	end process;
	
end architecture;