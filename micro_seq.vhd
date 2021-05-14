
use work.isa.all;

entity micro_seq is
    port(condition : in cond_op;
          negative_flag, zero_flag : in bit;
          do_jump : out bit);
end entity;

architecture behavioural of micro_seq is

begin

    with condition select
        do_jump <= '0' when cond_no_jump,
                   negative_flag when cond_neg,
                   zero_flag when cond_zero,
                   '1' when cond_none;

end architecture;