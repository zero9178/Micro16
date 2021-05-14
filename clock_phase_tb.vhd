
entity clock_phase_tb is
end entity;

architecture test of clock_phase_tb is

    constant T : time := 10 ns;

    signal clk : bit;
    signal phases : bit_vector(3 downto 0);
    
begin

    dut : entity work.clock_phase
                port map(clk => clk,
                         phases => phases);
                        
    process is
    begin   
        clk <= not clk;
        wait for T / 2;
    end process;
    
    process is
    begin
        wait for T;
        assert phases(0) = '1';
        assert phases(1) = '0';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '1';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '0';
        assert phases(2) = '1';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '0';
        assert phases(2) = '0';
        assert phases(3) = '1';
        wait for T;
        assert phases(0) = '1';
        assert phases(1) = '0';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '1';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '0';
        assert phases(2) = '1';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '0';
        assert phases(2) = '0';
        assert phases(3) = '1';
        wait for T;
        assert phases(0) = '1';
        assert phases(1) = '0';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait for T;
        assert phases(0) = '0';
        assert phases(1) = '1';
        assert phases(2) = '0';
        assert phases(3) = '0';
        wait;
    end process;
    
end architecture;