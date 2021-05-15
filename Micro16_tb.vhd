
library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;
use work.isa.all;

entity Micro16_tb is 
end;

architecture arch of Micro16_tb is
    constant T : time := 5 ns;
    
    signal clk : bit := '0';
    signal enable : bit := '1';
    
    signal data_bus : std_logic_vector(data_word'RANGE);
    
    type instructions_t is array (natural range <>) of bit_vector(31 downto 0);
    
    constant instructions : instructions_t := 
        (X"02140100", -- R0 <- lsh(1)
         X"0A141400", -- R0 <- lsh(R0 + 1)
         X"0A141400", -- R0 <- lsh(R0 + 1)
         X"08141400", -- R0 <- R0 + 1
         X"02150100", -- R1 <- lsh(1)
         X"0A151500", -- R1 <- lsh(R1 + 1)
         X"02150500", -- R1 <- lsh(R1)
         -- :euclid
         X"4000050F", -- (R1); if Z goto .end
         X"00170400", -- R3 <- R0
         -- :mod
         X"18180500", -- R4 <- ~R1
         X"08181800", -- R4 <- R4 + 1
         X"2800870D", -- (R3 + R4); if N goto .endMod
         X"68178709", -- R3 <- R3 + R4; goto.mod
         -- :endMod
         X"00140500", -- R0 <- R1
         X"60150707", -- R1 <- R3; goto .euclid
         -- :end
         X"01000400"); -- MBR <- R0
         
    signal rom_address : bit_vector(7 downto 0);
    signal instruction_in : bit_vector(31 downto 0);
    signal rst : bit := '1';
    
begin

    clk <= not clk after T/2 when enable = '1' else '0';
        
    read_instr : process(rom_address) is
        variable tmp : natural;
    begin
        tmp := to_integer(unsigned(rom_address));
        if tmp > instructions'HIGH then
            instruction_in <= (others => '0');
            enable <= '0';
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
                         data_bus => data_bus,
                         rst => rst);
    
    test : process is
    begin
        wait until enable = '0';
        assert unsigned(to_bitvector(data_bus)) = 1;
    end process;
    
end;
