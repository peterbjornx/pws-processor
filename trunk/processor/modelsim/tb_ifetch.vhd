
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;




entity tvc_psystem is
  port (clock, reset : out std_logic);
end tvc_psystem;


architecture behavior of tvc_psystem is
  -- internal clock and reset signals (these signals are necessary
  -- because VHDL does not allow that output signals are read in the
  -- entity that generates them)
  signal clk_i, rst_i: std_logic;

  constant half_clock_period: time := 100 ns;
  
  constant clock_period: time := 2 * half_clock_period;

begin
  --  connect internal clock and reset to ports
  
  -- generate clock
  clck: process
    
  begin
    clk_i <= '1';
    wait for half_clock_period;
    clk_i <= '0';
    wait for half_clock_period;
  end process clck;


  stimuli: process (clk_i)
    variable first: boolean := true;

    variable inline, outline: line;
    variable good: boolean;

    variable input, output: integer;

    variable time_out_counter: integer;

  begin
    if falling_edge(clk_i)
    then
      -- handle reset; reset signal is high during first clock cycle only
      if first 
      then
	       first := false;
	       rst_i <= '1';
         time_out_counter := 0;
      else
	       rst_i <= '0';
      end if; -- first
    
    end if; -- falling_edge(clk_i)
  end process stimuli;

  clock <= clk_i;
  reset <= rst_i;


test: process
begin
    
    
	 
    wait for 2.5 * clock_period;
  
    
    wait for clock_period;
    
    
  
end process test;

end behavior;



-- library and package declarations
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_if is 
end tb_if;

architecture structure of tb_if is
  -- declare components to be instantiated
  component single_port_rom is

		generic 
		(
			DATA_WIDTH : natural := 32;
			ADDR_WIDTH : natural := 8
		);

		port 
		(
			clk		: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);

	end component;
	
	component lcd_control is
	  port (
	    lcddat : in std_logic_vector(3 downto 0);
	    lcdrs, lcdrw, lcde : in std_logic;
	    char_out : out std_logic_vector(7 downto 0);
	    row_out : out std_logic;
	    column_out : out std_logic_vector(3 downto 0);
	    char_valid : out std_logic
	    );
	end component;
	
  component tvc_psystem is
  -- note that the signals are the same as in the entity siso8 
  -- where inputs have become outputs and vice versa 
  port (clock, reset : out std_logic
	);
	end component;
	
	component processor is
	port (data : inout std_logic_vector (31 downto 0);
			address : out std_logic_vector (31 downto 0);
			clock, reset  : in std_logic;
			rw : out std_logic);
	end component;

  -- declare local signals
  
  signal clock, reset, rw : std_logic;
  signal data : std_logic_vector (31 downto 0);
  signal address : std_logic_vector (31 downto 0);
  signal rom_addr : natural range 0 to 255;
  
  signal lcddat : std_logic_vector(3 downto 0);
	signal lcdrs, lcdrw, lcde : std_logic;
	signal char_out : std_logic_vector(7 downto 0);
	signal row_out : std_logic;
	signal column_out : std_logic_vector(3 downto 0);
	signal char_valid : std_logic;

begin
  -- instantiate and interconnect components
	proc : processor port map (data, address, clock, reset, rw);
	cgen : tvc_psystem port map (clock, reset);
	--lcdc : lcd_control port map( lcddat, lcdrs, lcdrw, lcde, char_out,
--	 row_out, column_out, char_valid);
	--trom : single_port_rom port map (clock, rom_addr, data);
	with address select
data <= 	x"000b0064" when x"00000000",
	x"00000c04" when x"00000001",
	x"00001024" when x"00000002",
	x"00000c2c" when x"00000003",
	x"00000c0c" when x"00000004",
	x"00000001" when x"00000005",
	x"00000000" when x"00000006",
	x"0000000c" when x"00000007",
	x"00000000" when x"00000008",
	x"00000008" when x"00000009",
	x"00000003" when x"0000000a",
	x"80000000" when x"0000000b",
	x"80000001" when x"0000000c",
	x"00000000" when others;


lcdrs <= address(0);
lcdrw <= rw;
lcde <= not (clock and address(31) and not rw);
lcddat <= data(3 downto 0);


end structure;

