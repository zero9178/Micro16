
entity Micro16 is
	port(clk : in bit;counter : out natural);
end entity;

architecture test of Micro16 is
begin

	process is
		variable counterValue : natural := 0;
	begin
		counter <= counterValue;
		counterValue := (counterValue + 1) mod 16;
		wait until clk = '1';
	end process;

end architecture;
