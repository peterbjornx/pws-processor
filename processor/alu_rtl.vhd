-- library and package declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity alu is
  generic (WIDTH          : integer := 32);
  port (mux_a: IN std_logic;
        a,
        b : IN std_logic_vector(WIDTH-1 downto 0);
        c : OUT std_logic_vector(WIDTH-1 downto 0);
        lt : OUT std_logic
        );
end alu;


architecture rtl of alu is

  signal res_add,
         res_mul : signed(WIDTH-1 downto 0);

  signal res_sub : signed(WIDTH downto 0);

  signal res_mul_tmp : signed(WIDTH*2-1 downto 0);
			
begin
  res_add <= signed(a) + signed(b);
  res_sub <= signed(a(WIDTH-1) & a) - signed(b(WIDTH-1) & b);  
  res_mul_tmp <= (signed(a) * signed(b));
  res_mul <= res_mul_tmp(WIDTH-1 downto 0);
  
  
  lt <= res_sub(WIDTH);
  
  c <= std_logic_vector(res_add) when mux_a = '0' else
       std_logic_vector(res_mul);
  
end rtl;