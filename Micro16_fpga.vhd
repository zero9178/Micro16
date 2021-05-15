
library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;
use work.isa.all;

entity Micro16_fpga is 
    port(clk,rst : in bit;
         leds : out bit_vector(7 downto 0));
end;

architecture arch of Micro16_fpga is
    
    signal data_bus : std_logic_vector(data_word'RANGE);
    signal address_bus : bit_vector(data_word'RANGE);
    signal rd_wr,memory_select : bit;
         
    signal rom_address : bit_vector(7 downto 0);
    signal instruction_in : bit_vector(31 downto 0);
    
    signal eigth_clock, write_enable,cpu_clock : bit;
    signal cpu_enable : bit := '0';
    signal read_data,write_data : bit_vector(data_word'RANGE);
    
    signal instruction_write : bit_vector(31 downto 0);
    signal instruction_write_enable : bit;
    
begin

    cpu_clock <= clk and cpu_enable;
    
    init : process(clk,instruction_write_enable,rst)
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
             X"01000500", -- MBR <- R1
             X"00A04000", -- MAR <- R0; wr
             X"00200000", -- wr
             X"01600000", -- MBR <- 0; rd
             X"00600000", -- rd
             X"80100000"  -- R0 <- MBR
             );
             
         variable iter : natural := 0;
         variable instruction_size : natural := 14;
    begin
        if rising_edge(clk) then
            if cpu_enable = '0' then
                instruction_write_enable <= '1';
                instruction_write <= instructions(iter);
                iter := iter + 1;
                if iter > instructions'HIGH then
                    instruction_write_enable <= '0';
                end if;
            end if;
        end if;
        cpu_enable <= not instruction_write_enable and rst;
    end process;
    
    clock_divider : process(cpu_clock) is
        variable tmp : natural range 0 to 7 := 3;
    begin
        if rising_edge(cpu_clock) then
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
    
    led_assign : process(eigth_clock) is
    begin
        if rising_edge(eigth_clock) then
            if write_enable = '1' then
                leds <= write_data(7 downto 0);
            end if;
        end if;
    end process;
    
    instr_memory : entity work.ram
                    generic map(size => 2**8)
                    port map(clk => clk,
                             address => data_word(rom_address),
                             read_data => instruction_in,
                             write_enable => instruction_write_enable,
                             write_data => instruction_write);
    
    ram : entity work.ram
                generic map(size => 2**16)
                port map(clk => eigth_clock,
                         address => data_word(address_bus),
                         write_enable => write_enable,
                         read_data => read_data,
                         write_data => write_data);
        
    cpu : entity work.Micro16
                port map(clk => cpu_clock,
                         rom_address => rom_address,
                         instruction => instruction_in,
                         address_bus => address_bus,
                         rd_wr => rd_wr,
                         memory_select => memory_select,
                         data_bus => data_bus,
                         rst => rst);
    
end;
