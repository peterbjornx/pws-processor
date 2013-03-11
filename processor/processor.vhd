library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;



entity processor is
port (data : inout std_logic_vector (31 downto 0);
		address : out std_logic_vector (31 downto 0);
		clock, reset  : in std_logic;
		rw : out std_logic);
end processor;

architecture parch of processor is

	component idec is
				port(
				  clock_p1, reset : in std_logic ;
				  ra_we,
				  r_jump,
				  imm_enable,
				  lr_jump,
				  mux_b_enable,
				  imm_signed,
          			  carry_enable,
				  lr_rw,
				  cr_we,
				  bus_rw,
				  mem_read : out std_logic;
				  store_lr : out std_logic;
				  ir ,
				  cr : in std_logic_vector(31 downto 0);
				  aluop : out std_logic_vector(2 downto 0)
				);
	end component;

	component dp is
	  generic (WIDTH          : integer := 32;
				  WIDTH_REG_ADDR : integer := 5;
				  WIDTH_MEM_ADDR : integer := 8;
				  WIDTH_OPC      : integer := 5);
	  port (clk: in std_logic;
			  reset: in std_logic;
       			  execute,
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
			  lr_rw,
			  mem_write,
			  mem_read : in std_logic;
			  data_bus : inout std_logic_vector(WIDTH-1 downto 0);
			--  data_bus_out : out std_logic_vector(WIDTH-1 downto 0);
			  addr_bus : out std_logic_vector(WIDTH-1 downto 0);
			  ir_o,
			  cr_o : out std_logic_vector(WIDTH-1 downto 0);
			  aluop : in std_logic_vector (2 downto 0)
			  );
	end component;

	component ifetch_state is
				port(
				  clock_p1, reset : in std_logic ;
				  cia_we, nia_we, lr_we, ir_we : out std_logic;
				  addr_source, execute_sig: out std_logic;
				  store_lr: in std_logic
				);
	end component;
	
	--signal clock, reset : std_logic;
	--ifetch signals
	signal 	cia_we, 
				nia_we, 
				lr_we, 
				ir_we, 
				addr_source : std_logic;
	signal store_lr : std_logic;
	--idec signals
	signal cr : std_logic_vector(31 downto 0);
	signal ir : std_logic_vector(31 downto 0);
  signal execute : std_logic;	
	--dp signals
	signal 		ra_we,
				cr_we,
				r_jump,
				lr_jump,
				lr_wr,
				imm_enable,
				mux_b_enable,
				imm_signed,
        carry_enable,
				mem_write,
				mem_read : std_logic;
	 signal aluop : std_logic_vector(2 downto 0);
	 --bus signals
	 
	 signal bus_rw : std_logic;
    signal data_bus,	
			  addr_bus : std_logic_vector(31 downto 0);
			  

begin
	dp_inst : dp port map(
									clock,
									reset,
									execute,
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
									lr_wr,
									mem_write,
									mem_read,
									data,
									addr_bus,
									ir,
									cr,
									aluop);
	if_inst : ifetch_state port map(
									clock, 
									reset,
									cia_we, 
									nia_we, 
									lr_we, 
									ir_we,
									addr_source,
									execute,
									store_lr);
	id_inst : idec port map(clock,
									reset,
									ra_we,
									r_jump,
									imm_enable,
									lr_jump,
									mux_b_enable,
									imm_signed,
									carry_enable,
									lr_wr,
									cr_we,
									bus_rw,
									mem_read,
									store_lr,
									ir,
									cr,
									aluop);
	mem_write <= execute and not bus_rw;
	address <= addr_bus;
	rw <= bus_rw or not execute;
end parch;
