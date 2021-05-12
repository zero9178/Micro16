
entity Micro16_tb is 
end;

architecture arch of Micro16_tb is
	constant T : time := 20 ns;
	
	signal clk : bit;
	signal output : natural;
begin
	
	micro16 : entity work.Micro16
		port map(clk => clk,counter => output);
		
	process
	begin
		clk <= '0';
		wait for T/2;
		assert output = 0;
		clk <= '1';
		wait for T/2;
		assert output = 1;
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
		assert output = 2;
		wait;
	end process;
end;
