-- library and package declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity psystem is
  generic (WIDTH          : integer := 32;
           WIDTH_REG_ADDR : integer := 5;
           WIDTH_MEM_ADDR : integer := 8;
           WIDTH_OPC      : integer := 5;
           COUNTER_WIDTH  : integer := 1); -- 25
  port (CLOCK_24: in std_logic;
        KEY: in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
		    HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
		    HEX3 : out std_logic_vector(6 downto 0);
		    LEDR : out std_logic_vector(9 downto 0)
        );
end psystem;

architecture rtl of psystem is

	component dp is
	  generic (WIDTH          : integer := WIDTH;
				  WIDTH_REG_ADDR : integer := WIDTH_REG_ADDR;
				  WIDTH_MEM_ADDR : integer := WIDTH_MEM_ADDR;
				  WIDTH_OPC      : integer := WIDTH_OPC);
	  port (clk: in std_logic;
			  nreset: in std_logic;
			  cir_we,
			  nir_we,
			  lr_we,
			  ir_we,
			  ra_we,
			  mux_cilr_sel,
			  mux_ir_add_sel,
			  mux_mem_sel,
			  mux_wb_sel : in std_logic;
			  mux_c_sel : in std_logic_vector(1 downto 0);
			  hex_out : out std_logic_vector(15 downto 0);
			  alu_lt : out std_logic
			  );
	end component;

	component clock is
	port
	(
		inclk		: IN STD_LOGIC ;
		outclk		: OUT STD_LOGIC 
	);
	end component;
	
	
	function bin_to_7seg(i : std_logic_vector) return std_logic_vector is
	begin
	  
	  case i(3 downto 0) is
	    when "0000" => return "1000000"; --0
	    when "0001" => return "1111001";
	    when "0010" => return "0100100";
	    when "0011" => return "0110000"; -- 3
	    when "0100" => return "0011001";
	    when "0101" => return "0010010"; -- 5
	    when "0110" => return "0000010";
	    when "0111" => return "1111000";
	    when "1000" => return "0000000";
	    when "1001" => return "0010000";
	    when "1010" => return "0001000"; -- A
	    when "1011" => return "0000011";
	    when "1100" => return "1000110";
	    when "1101" => return "0100001";
	    when "1110" => return "0000110";
	    when "1111" => return "0001110";
	    when others => return "-------";
	  end case;
	  
	  
	end bin_to_7seg;
	
	
	signal clk, nreset : std_logic;
	
	signal cir_we, nir_we, lr_we, ir_we, ra_we, mux_cilr_sel, mux_ir_add_sel, mux_mem_sel, mux_wb_sel : std_logic;

  signal mux_c_sel : std_logic_vector(1 downto 0);

	
	type fsm is (start, s0, s1, s2, s3, s4, s5);
		
	signal curr_state, next_state : fsm;
	
	type fsm_button is (idle, cycle, hi, lo);
	
	signal fsm_button_curr, fsm_button_next : fsm_button;
	
	
	
	
	signal hex_out : std_logic_vector(15 downto 0);
	
	signal hhex0, hhex1, hhex2, hhex3 : std_logic_vector(3 downto 0);
	
	signal alu_lt : std_logic;
	
	signal sclock : std_logic;
	
	signal cnt : unsigned(COUNTER_WIDTH-1 downto 0);
	
	
begin
	
	dp_inst : dp        port map (sclock, nreset, cir_we, nir_we, lr_we, ir_we, ra_we, mux_cilr_sel, mux_ir_add_sel, mux_mem_sel, mux_wb_sel, mux_c_sel, hex_out, alu_lt);
	
	
	
	
	
	clock_inst : clock PORT MAP (
		inclk	 => cnt(COUNTER_WIDTH-1),
		outclk	 => sclock
	);

	
	
	
	clk <= CLOCK_24;
	nreset <= KEY(3);
	
	--HEX0 <= "1010101";
	--HEX1 <= "0000001" when KEY(0) = '1' else "0000010";
	--HEX2 <= "0000000";
	--HEX2 <= "0000000" when curr_state = s1 else "1111111";
	
	hhex0 <= hex_out(3 downto 0);
	hhex1 <= hex_out(7 downto 4);
	hhex2 <= hex_out(11 downto 8);
	hhex3 <= hex_out(15 downto 12);
	
	
	HEX0 <= bin_to_7seg(hhex0);
	HEX1 <= bin_to_7seg(hhex1);
	HEX2 <= bin_to_7seg(hhex2);
	HEX3 <= bin_to_7seg(hhex3);
	
	
	process(curr_state, alu_lt)
	begin
	
		next_state  <= s2;
	  mux_mem_sel <= '0';
	
	 
	  nir_we <= '0';
	  ir_we  <= '0';
	  lr_we  <= '0';
	  cir_we <= '0';
	  ra_we  <= '0';
	
	
	   ledr <= (others => '0');
	
	   mux_c_sel <= "00";
	
		case curr_state is
			when start =>	
			            ledr        <= (others => '1');
			            next_state <= s0;
			
			when s0 =>		ledr        <= (0 => '1', others => '0');
			            mux_mem_sel <= '0'; -- select 0 from NIR to RDADDRESS
			            next_state  <= s1;
			            
			when s1 =>		ledr        <= (1 => '1', others => '0');
			            ir_we       <= '1';
			            mux_wb_sel  <= '1';			
			            next_state  <= s2;
			
			when s2 =>  ledr        <= (2 => '1', others => '0');
			            ra_we       <= '1';
			            next_state  <= s3;
			            
			when s3 =>  ledr        <= (3 => '1', others => '0');
			            mux_c_sel   <= "00"; -- "10";
			
			            if (alu_lt = '0')
			            then			
			              next_state  <= s4;
			            else
			              next_state  <= s5;
			            end if;
			
			
			when s4 =>  ledr        <= (4 => '1', others => '0');
			            next_state  <= s4;
			  
			when s5 =>  ledr        <= (5 => '1', others => '0');
			            next_state  <= s5;
			  
			when others => next_state <= start;
	
		end case;
	end process;
	
	
	process(sclock, nreset)
	begin
    
    if (nreset = '0')
    then
      curr_state <= start;
        
    elsif (rising_edge(sclock))
    then
      
      curr_state <= next_state;
    
    end if;
    
    
  end process;
	
	process(clk, nreset)
	begin
    
    if (nreset = '0')
    then
      cnt <= (others => '0');
        
    elsif (rising_edge(clk))
    then
      
      cnt <= cnt + 1;
    
    end if;
    
    
  end process;
	
	
end rtl;
	
	