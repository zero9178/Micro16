
library ieee;
use ieee.numeric_bit.all;

entity Micro16_tb is 
end;

architecture arch of Micro16_tb is
	constant T : time := 5 ns;
	
	signal clk : bit;
	
	type instructions_t is array (natural range <>) of bit_vector(31 downto 0);
	
	constant instructions : instructions_t := 
		(X"02140100",
		 X"0A141400",
		 X"0A141400",
		 X"08141400",
		 X"02150100",
		 X"0A151500",
		 X"02150500",
		 X"4000050F",
		 X"00170400",
		 X"18180500",
		 X"08181800",
		 X"2800870D",
		 X"68178709",
		 X"00140500",
		 X"60150707",
		 X"00160500");
		 
	signal rom_address : bit_vector(7 downto 0);
	signal instruction_in : bit_vector(31 downto 0);
	signal rst : bit := '1';
	
begin

	clock_gen : process is
	begin
		clk <= not clk;
		wait for T / 2;
	end process;
		
	read_instr : process(rom_address) is
		variable tmp : natural;
	begin
		tmp := to_integer(unsigned(rom_address));
		if tmp > instructions'HIGH then
			instruction_in <= (others => '0');
		else
			instruction_in <= instructions(tmp);
		end if;
	end process;
		
	dut : entity work.Micro16
				port map(clk => clk,
							rom_address => rom_address,
							instruction => instruction_in,
							address_bus => open,
							rd_wr => open,
							memory_select => open,
							data_bus => open,
							rst => rst);
	
end;
