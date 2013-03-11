library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use std.textio.all;

entity palu is
generic (WIDTH : integer := 32);
port (mux_a: IN std_logic_vector(2 downto 0);
      a,
      b : IN std_logic_vector(WIDTH-1 downto 0);
      c : OUT std_logic_vector(WIDTH-1 downto 0);
      cmp_eq, cmp_lt, cmp_gt : OUT std_logic
      carry_in IN std_logic;
      carry_out OUT std_logic;
);
end palu;


architecture rtl of palu is

signal arith_a,
       arith_b,
       arith_c : std_logic_vector(WIDTH downto 0);

signal res_add,
       res_sub : signed(WIDTH downto 0);
       
signal res_mul : signed((WIDTH * 2) - 1 downto 0);

signal  res_or,
        res_and,
        res_xor,
        res_nand,
        res_add_v,
        res_sub_v,
        res_zero : std_logic_vector(WIDTH-1 downto 0);
        
signal  res_mul_v : std_logic_vector((WIDTH * 2) - 1 downto 0);

signal cmp_eq_i,
       cmp_lt_i,
       cmp_gt_i: std_logic;

begin

arith_a <= '0' & a;
arith_b <= '0' & b;
arith_c <= x"0000000" & '000' & a;

res_add <= signed(arith_a) + signed(arith_b) + signed(arith_c);

res_add_v <= std_logic_vector(res_add);

res_sub <= signed(arith_a) - (signed(arith_b) + signed(arith_c));

res_sub_v <= std_logic_vector(res_sub);

res_mul <= signed(a) * signed(b);

res_mul_v <= std_logic_vector(res_mul);

res_or <= a or b;

res_and <= a and b;

res_xor <= a xor b;

res_nand <= a nand b;

res_zero <= (others => '0');

with mux_a select
  c <=  res_or                      when "000",
        res_and                     when "001",
        res_xor                     when "010",
        res_nand                    when "011",
        res_add(31 downto 0)   	    when "100",
        res_sub(31 downto 0)   	    when "101",
        res_mul_v(31 downto 0)      when "110",--was mul
        res_zero                    when "111",
        (others => '-')             when others;
        
with mux_a select
  carry_out <=  '-'		    when "000",
        '-'                         when "001",
        '-'                         when "010",
        '-'                         when "011",
        res_add(32)     	    when "100",
        res_sub(32)     	    when "101",
        '-'		            when "110",--was mul
        '-'                         when "111",
        (others => '-')             when others;
        
cmp_eq_i <= '1' when res_sub = x"00000000" else '0';
cmp_lt_i <= res_sub(WIDTH - 1);
cmp_gt_i <= (not cmp_lt_i) and (not cmp_eq_i);


cmp_eq <= cmp_eq_i;
cmp_lt <= cmp_lt_i;
cmp_gt <= cmp_gt_i;

end rtl;