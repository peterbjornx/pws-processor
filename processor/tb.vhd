library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tvc_psystem is
  -- note that the signals are the same as in the entity siso8 
  -- where inputs have become outputs and vice versa 
  port (CLOCK_24: out std_logic;
        KEY: out std_logic_vector(3 downto 0);
        HEX0 : in std_logic_vector(6 downto 0);
		  HEX1 : in std_logic_vector(6 downto 0);
        HEX2 : in std_logic_vector(6 downto 0);
		  HEX3 : in std_logic_vector(6 downto 0);
		  LEDR : in std_logic_vector(9 downto 0)
	);
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
  CLOCK_24 <= clk_i;
  KEY <= (3 => rst_i, others => '0');
  
  
  
  -- generate clock
  clock: process
    
  begin
    clk_i <= '1';
    wait for half_clock_period;
    clk_i <= '0';
    wait for half_clock_period;
  end process clock;


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
	       rst_i <= '0';
         time_out_counter := 0;
      else
	       rst_i <= '1';
      end if; -- first
    
    end if; -- falling_edge(clk_i)
  end process stimuli;


test: process
begin
    
    
	 
    wait for 2.5 * clock_period;
  
    
    wait for clock_period;
    
    
  
end process test;

end behavior;



-- library and package declarations
library ieee;
use ieee.std_logic_1164.all;

entity tb_proc is 
end tb_proc;

architecture structure of tb_proc is
  -- declare components to be instantiated
  
  component tvc_psystem is
  -- note that the signals are the same as in the entity siso8 
  -- where inputs have become outputs and vice versa 
  port (CLOCK_24: out std_logic;
        KEY: out std_logic_vector(3 downto 0);
        HEX0 : in std_logic_vector(6 downto 0);
		  HEX1 : in std_logic_vector(6 downto 0);
        HEX2 : in std_logic_vector(6 downto 0);
		  HEX3 : in std_logic_vector(6 downto 0);
		  LEDR : in std_logic_vector(9 downto 0)
	);
	end component;
  
  component psystem is
  generic (WIDTH          : integer := 32;
           WIDTH_REG_ADDR : integer := 5;
           WIDTH_MEM_ADDR : integer := 8;
           WIDTH_OPC      : integer := 5);
  port (CLOCK_24: in std_logic;
        KEY: in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(6 downto 0);
		  HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
		  HEX3 : out std_logic_vector(6 downto 0);
		  LEDR : out std_logic_vector(9 downto 0)
        );
	end component;

  -- declare local signals
  
  signal CLOCK_24 : std_logic;
  
  signal KEY : std_logic_vector(3 downto 0);
  
  signal HEX0, HEX1, HEX2, HEX3 : std_logic_vector(6 downto 0);
   signal LEDR : std_logic_vector(9 downto 0);
  
  
  
  
begin
  -- instantiate and interconnect components
  duv: psystem      port map (CLOCK_24, KEY, HEX0, HEX1, HEX2, HEX3, LEDR);
  tvc: tvc_psystem  port map (CLOCK_24, KEY, HEX0, HEX1, HEX2, HEX3, LEDR);
  
end structure;
