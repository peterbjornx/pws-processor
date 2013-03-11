library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity ifetch_state is
port(
  clock_p1, reset : in std_logic;
  cia_we, nia_we, lr_we, ir_we : out std_logic;
  addr_source,bus_rw,ra_we : out std_logic;
  store_lr,bus_rw_in,ra_we_in : in std_logic
);
end ifetch_state;


architecture ifetch_state_arch of ifetch_state is
	type ifetch_states is (load_cia_fetch, execute, load_nia, load_lr);
	signal state, next_state : ifetch_states;	
begin
	process (state, store_lr) begin
		case state is
			when load_cia_fetch =>	next_state <= execute;
			when execute  => 	next_state <= load_nia;
			when load_nia =>	if store_lr='1'	then next_state <= load_lr;
												else next_state <= load_cia_fetch; end if;
			when load_lr =>	next_state <= load_cia_fetch;
			when others =>	next_state <= next_state;
		end case;
 	end process;
 	
 	with state select
 		cia_we <=		'1' 			when load_cia_fetch,	
							'0' 			when others;
 	with state select
 		ir_we 		<=	'1' 			when load_cia_fetch,	--IR   <= bus_rd(addr)
 						   '0'			when others;
 	with state select
 		addr_source <=	'1'			when load_cia_fetch,	--addr <= nia
							'0'			when others;			--addr <= alu_result
 	with state select
 		bus_rw		<=	bus_rw_in	when execute,			--let instruction decide bus direction
							'1'			when others;			--bus has to be in read mode for IF;
 	with state select
 		ra_we		<=	ra_we_in	when execute,			--let instruction decide bus direction
							'0'			when others;			--bus has to be in read mode for IF;
 	with state select
 		nia_we		<=	'1'			when load_nia,
							'0'			when others;
 	with state select
 		lr_we 		<=	'1'			when load_lr,
							'0'			when others;
 					
 	process (clock_p1, reset) begin
 		if reset='1' then
 			state <= load_cia_fetch;
 		elsif rising_edge(clock_p1) then
 			state <= next_state;
 		end if;
 	end process;
 					
 	
end ifetch_state_arch;
