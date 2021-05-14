
library ieee;
use ieee.numeric_bit.all;
use work.isa.all;

entity alu is
    port(operation : in alu_op;
         a_operand, b_operand : in data_word;
         s_result : out data_word;
         negative_flag, zero_flag : out bit);
end entity;

architecture behaviour of alu is
    signal result : data_word;
begin

    with operation select
        result <= a_operand when alu_abus,
                  a_operand + b_operand when alu_add,
                  a_operand and b_operand when alu_and,
                  not a_operand when alu_neg;
    
    s_result <= result;
    negative_flag <= result(data_word'HIGH);
    zero_flag <= '1' when result = 0 else '0';
end architecture;
