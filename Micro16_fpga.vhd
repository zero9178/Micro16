
library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;
use work.isa.all;

entity Micro16_fpga is 
    port(clk,rst : in bit);
end;

architecture arch of Micro16_fpga is
    
    signal data_bus : std_logic_vector(data_word'RANGE);
    signal address_bus : bit_vector(data_word'RANGE);
    signal rd_wr,memory_select : bit;
    
    type instructions_t is array (natural range <>) of bit_vector(31 downto 0);
    
    constant instructions : instructions_t := 
        (X"02140100", -- R0 <- lsh(1)
         X"0A141400", -- R0 <- lsh(R0 + 1)
         X"08141400", -- R0 <- R0 + 1
         X"02150100", -- R1 <- lsh(1)
         X"02150500", -- R1 <- lsh(R1)
         X"02150500", -- R1 <- lsh(R1)
         X"02150500", -- R1 <- lsh(R1)
         X"08151500", -- R1 <- R1 + 1
         -- :loop
         X"20000418", -- (R0); if N goto .end
         X"18F64400", -- R2 <- ~R0; MAR <- R0; rd
         X"08761600", -- R2 <- R2 + 1; rd
         X"80170000", -- R3 <- MBR
         X"08166500", -- R2 <- R1 + R2
         X"00E06000", -- MAR <- R2; rd
         X"00600000", -- rd
         X"80160000", -- R2 <- MBR
         X"00E06000", -- MAR <- R2; rd
         X"00600000", -- rd
         X"00A04000", -- MAR <- R0; wr
         X"00200000", -- wr
         X"01A06700", -- MBR <- R3; MAR <- R2; wr
         X"00200000", -- wr
         X"08142400", -- R0 <- R0 + (-1)
         X"60000008");-- goto .loop
         -- :end
         
    signal rom_address : bit_vector(7 downto 0);
    signal instruction_in : bit_vector(31 downto 0);
    
    signal eigth_clock, write_enable,internal_clock : bit;
    signal clock_enable : bit := '1';
    signal read_data,write_data : bit_vector(data_word'RANGE);
    
begin

    internal_clock <= clk and clock_enable;
 
    read_instr : process(rom_address) is
        variable tmp : natural;
    begin
        tmp := to_integer(unsigned(rom_address));
        if tmp > instructions'HIGH then
            instruction_in <= (others => '0');
            clock_enable <= '0';
        else
            instruction_in <= instructions(tmp);
        end if;
    end process;
    
    clock_divider : process(internal_clock) is
        variable tmp : natural range 0 to 7 := 0;
    begin
        if rising_edge(internal_clock) then
            if tmp = 7 then
                eigth_clock <= '1';
                tmp := 0;
            else
                eigth_clock <= '0';
                tmp := tmp + 1;
            end if;
        end if;
    end process;
    
    write_enable <= memory_select and not rd_wr;
    
    data_bus <= to_stdlogicvector(read_data) when memory_select = '1' and rd_wr = '1' else (others => 'Z');
    write_data <= to_bitvector(data_bus);
    
    ram : entity work.ram
                port map(clk => eigth_clock,
                         address => data_word(address_bus),
                         write_enable => write_enable,
                         read_data => read_data,
                         write_data => write_data);
        
    cpu : entity work.Micro16
                port map(clk => internal_clock,
                         rom_address => rom_address,
                         instruction => instruction_in,
                         address_bus => address_bus,
                         rd_wr => rd_wr,
                         memory_select => memory_select,
                         data_bus => data_bus,
                         rst => rst);
    
end;
