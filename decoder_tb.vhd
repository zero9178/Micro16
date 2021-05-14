
library work;
use work.isa.all;

entity decoder_tb is
end entity;

architecture arch of decoder_tb is

    constant T : time := 20 ns;
    signal input_instruction : bit_vector(31 downto 0);
    signal mbr_mux : bit;
    signal condition : cond_op;
    signal alu_operation : alu_op;
    signal shifter_operation : shifter_op;
    signal mbr_enable, mar_enable, rd_wr, memory_select, sbus_enable : bit;
    signal sbus, bbus, abus : bus_operand;
    signal address : bit_vector(7 downto 0);

begin

    decoder : entity work.decoder
                 port map(instruction_word => input_instruction,
                          mbr_mux => mbr_mux,
                          condition => condition,
                          alu_operation => alu_operation,
                          shifter_operation => shifter_operation,
                          mbr_enable => mbr_enable,
                          mar_enable => mar_enable,
                          rd_wr => rd_wr,
                          memory_select => memory_select,
                          sbus_enable => sbus_enable,
                          sbus => sbus,
                          bbus => bbus,
                          abus => abus,
                          address => address);

    process
    begin
        -- R0 <- lsh(1)
        input_instruction <= X"02140100";
        wait for T;
        assert mbr_mux = '0';
        assert condition = cond_no_jump;
        assert alu_operation = alu_abus;
        assert shifter_operation = shifter_left;
        assert mbr_enable = '0';
        assert mar_enable = '0';
        assert rd_wr = '0';
        assert memory_select = '0';
        assert sbus_enable = '1';
        assert sbus = R0;
        assert bbus = '0';
        assert abus = '1';
        assert address = X"00";
        
        -- Ro <- R0 + (-1); goto ...
        input_instruction <= X"68142469";
        wait for T;
        assert mbr_mux = '0';
        assert condition = cond_none;
        assert alu_operation = alu_add;
        assert shifter_operation = shifter_noop;
        assert mbr_enable = '0';
        assert mar_enable = '0';
        assert rd_wr = '0';
        assert memory_select = '0';
        assert sbus_enable = '1';
        assert sbus = r0;
        assert bbus = neg_one;
        assert abus = r0;
        assert address = X"69";
        
        -- R2 <- ~R0; MAR <- R0; rd
        input_instruction <= X"18F64400";
        wait for T;
        assert mbr_mux = '0';
        assert condition = cond_no_jump;
        assert alu_operation = alu_neg;
        assert shifter_operation = shifter_noop;
        assert mbr_enable = '0';
        assert mar_enable = '1';
        assert rd_wr = '1';
        assert memory_select = '1';
        assert sbus_enable = '1';
        assert sbus = r2;
        assert bbus = r0;
        assert abus = r0;
        assert address = X"00";
        
        wait;
    end process;

end architecture;