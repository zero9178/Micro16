
use work.isa.all;

entity micro_seq_tb is
end entity;

architecture test of micro_seq_tb is

    constant T : time := 20 ns;
    
    signal condition : cond_op;
    signal negative_flag, zero_flag, do_jump : bit;

begin

    dtu : entity work.micro_seq
                port map(condition => condition,
                         negative_flag => negative_flag,
                         zero_flag => zero_flag,
                         do_jump => do_jump);

    process is
    begin
    
        -- cond_no_jump
        condition <= cond_no_jump;
        wait for T;
        assert do_jump = '0';
        
        negative_flag <= '1';
        zero_flag <= '1';
        wait for T;
        assert do_jump = '0';
        
        -- cond_neg
        condition <= cond_neg;
        negative_flag <= '0';
        zero_flag <= '0';
        wait for T;
        assert do_jump = '0';
        
        zero_flag <= '1';
        wait for T;
        assert do_jump = '0';
        
        negative_flag <= '1';
        wait for T;
        assert do_jump = '1';
        
        zero_flag <= '0';
        wait for T;
        assert do_jump = '1';
        
        -- cond_zero
        condition <= cond_zero;
        negative_flag <= '0';
        zero_flag <= '0';
        wait for T;
        assert do_jump = '0';
        
        zero_flag <= '1';
        wait for T;
        assert do_jump = '1';
        
        negative_flag <= '1';
        wait for T;
        assert do_jump = '1';
        
        zero_flag <= '0';
        wait for T;
        assert do_jump = '0';
    
        -- cond_none
        condition <= cond_none;
        negative_flag <= '0';
        zero_flag <= '0';
        wait for T;
        assert do_jump = '1';
        
        zero_flag <= '1';
        wait for T;
        assert do_jump = '1';
        
        negative_flag <= '1';
        wait for T;
        assert do_jump = '1';
        
        zero_flag <= '0';
        wait for T;
        assert do_jump = '1';
    
        wait;
    end process;

end architecture;