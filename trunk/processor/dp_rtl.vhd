-- library and package declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity dp is
  generic (WIDTH          : integer := 32;
           WIDTH_REG_ADDR : integer := 5;
           WIDTH_MEM_ADDR : integer := 8;
           WIDTH_OPC      : integer := 5);
  port (clk: in std_logic;
        reset: in std_logic;
        cia_we,
        nia_we,
        lr_we,
        ir_we,
        ra_we,
		  cr_we,
        addr_source,
        r_jump,
		  lr_jump,
        imm_enable,
        mux_b_enable,
        imm_signed,
        carry_enable,
		  mem_write,
        mem_read : in std_logic;
        data_bus : inout std_logic_vector(WIDTH-1 downto 0);
      --  data_bus : out std_logic_vector(WIDTH-1 downto 0);
        addr_bus : out std_logic_vector(WIDTH-1 downto 0);
        ir_o,
        cr_o : out std_logic_vector(WIDTH-1 downto 0);
		  aluop : in std_logic_vector (2 downto 0)
        );
end dp;


architecture rtl of dp is

  component palu is
    generic (WIDTH          : integer := WIDTH);
    port (mux_a: IN std_logic_vector(2 downto 0);
      a,
      b : IN std_logic_vector(WIDTH-1 downto 0);
      c : OUT std_logic_vector(WIDTH-1 downto 0);
      cmp_eq, cmp_lt, cmp_gt : OUT std_logic
      carry_in IN std_logic;
      carry_out OUT std_logic);
  end component;


  -- stuff for registers

  type reg_type is array (31 downto 0) of std_logic_vector(WIDTH-1 downto 0);

  signal reg : reg_type;

  signal cia, cia_next,
          nia, nia_next,
          lr, lr_next : unsigned(WIDTH-1 downto 0);
         
  signal ir, cr, ir_next, cr_next_2, cr_next, cr_ca : std_logic_vector(WIDTH-1 downto 0);
  
  -- stuff for other signals, muxes
  
  signal nia_base,
          nia_offset,
          imm_extended,
          imm_expanded : unsigned(WIDTH-1 downto 0);
  
  signal cmp_eq, cmp_lt, cmp_gt, carry_in, carry_out, cr_we_2 : std_logic;
  
  signal ra_out,
         rb_out,
         rc_out,
         ra_in,
			cr_in,
			ra_next,
         mux_b,
         mux_c,
         imm_val,
         alu_out,
: std_logic_vector(WIDTH-1 downto 0);
  
  signal ra,
         rb,
         rc : unsigned(WIDTH_REG_ADDR-1 downto 0);
  
  signal imm : std_logic_vector(15 downto 0);
  
begin
  
  alu_inst : palu port map(mux_a => aluop, a => mux_b, b => mux_c, c => alu_out, cmp_eq => cmp_eq, cmp_lt => cmp_lt, cmp_gt => cmp_gt, carry_in => carry_in, carry_out => carry_out);
  
  nia_next <= (nia_base+nia_offset) when nia_we = '1' else nia; 
  cia_next <= nia 						when cia_we = '1' else cia;   
  lr_next  <= cia 						when lr_we = '1'	else lr;
  ir_next  <= data_bus	 				when ir_we = '1'	else ir;  
  ra_next  <= ra_in						when ra_we = '1'	else ra_out;
  cr_next_2 <= cr_in						when cr_we = '1'	else cr_ca;
  cr_next  <= cr_next_2  					when cr_we_2 = '1'	else cr;
  nia_base <= lr when lr_jump = '1' else cia;  
  nia_offset <= to_unsigned(1, WIDTH) when r_jump = '0' else unsigned(mux_c);
  
  carry_in <= cr(3) and carry_enable;
  
  cr_we_2 <= carry_enable or cr_we;

  cr_in <= x"0000000" & '0' & cmp_gt & cmp_eq & cmp_lt;
  cr_ca <= x"0000000" & carry_out & cr(2 downto 0); 
  ir_o <= ir;
  cr_o <= cr;
  
  ra  <= unsigned(ir(9 downto 5));  
  rb  <= unsigned(ir(14 downto 10));
  rc  <= unsigned(ir(19 downto 15));
  
  imm <= ir(31 downto 16);
  
  imm_extended <= x"0000" & unsigned(imm);
  imm_expanded <= x"0000" & unsigned(imm) when imm(15) = '0' else
                  x"FFFF" & unsigned(imm);
              
  imm_val <= std_logic_vector(imm_expanded) when imm_signed = '1' else std_logic_vector(imm_extended);
  
  ra_out <= reg(to_integer(ra));
  rb_out <= reg(to_integer(rb));
  rc_out <= reg(to_integer(rc));
  
  mux_b <= (others => '0') when ((rb = x"00000000") and mux_b_enable = '1') else rb_out;
  mux_c <= rc_out when imm_enable = '0' else std_logic_vector(imm_val);
  
  ra_in <= data_bus when mem_read='1' else alu_out;
  
  addr_bus <= std_logic_vector(nia) when addr_source='1' else alu_out;
  
  data_bus <= ra_out when mem_write = '1' else (others => 'Z');
  
  process(clk, reset)
  begin
    
    if (reset = '1')
    then
      cia <= (others => '0');
      nia <= (others => '0');
      lr  <= (others => '0');
      ir  <= (others => '0');
      cr  <= (others => '0');
      
      reg <= (others => (others => '0'));
        
    elsif (rising_edge(clk))
    then
      
      reg <= reg;
      
      cia <= cia_next;
      nia <= nia_next;
		lr  <= lr_next;
		ir  <= ir_next;
		cr  <= cr_next;
      reg(to_integer(ra)) <= ra_next; 
    
    end if;
    
    
  end process;
  
end rtl;
