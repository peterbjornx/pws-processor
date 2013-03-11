library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity idec is
port(
  clock_p1, reset : in std_logic ;
  ra_we,
  r_jump,
  imm_enable,
  lr_jump,
  mux_b_enable,
  imm_signed,
  carry_enable,
  cr_we,
  bus_rw,
  mem_read : out std_logic;
  store_lr : out std_logic;
  ir ,
  cr : in std_logic_vector(31 downto 0);
  aluop : out std_logic_vector(2 downto 0)
);
end idec;


architecture idec_cl of idec is
   signal 
	loadstore_op,
	logic_op,
	arith_op,
	branch_op,
	ir_imm,
	ir_shiftop,
	ir_rw,
	ir_carry_enable,
	ir_lr_jump,
	ir_lr_store,
	jump_i,
	load_op,
	compare_op,
	cond_val : std_logic;
	signal ir_aluop : std_logic_vector(1 downto 0);
	signal ir_cond  : std_logic_vector(1 downto 0);
	signal ir_width : std_logic_vector(1 downto 0);
begin
   ir_imm			<= ir(2);
	
	loadstore_op 	<= ir(0) nor ir(1);						--Type 0 (A NOR B == (NOT A) AND (NOT B))
	logic_op 	   <= ir(0) and not ir(1);					--Type 1
	arith_op 	   <= ir(1) and not ir(0);					--Type 2 
	branch_op 	   <= ir(0) and ir(1);						--Type 3
	
	imm_enable		<= ir_imm;
	imm_signed		<= branch_op or arith_op;				--Could be optimized to ir(1)
	
	ir_aluop			<= ir(5 downto 4);
	
	ra_we				<= logic_op or load_op or (arith_op and not compare_op);
	
	aluop(1 downto 0) <= ir_aluop;
	aluop(2)				<= arith_op;
	
	--Start of load/store instruction decoding
	
	ir_rw				<= ir(3);									--~Read/Write
	ir_width			<= ir(5 downto 4);
	
	mux_b_enable	<= loadstore_op and ir_imm;
	mem_read			<= loadstore_op;							--It is not a problem if mem_read
																		--is high during a write, it only
																		--selects the writeback source.
																		
	bus_rw			<= loadstore_op nand ir_rw;			--bus_rw is Read/~Write		
	load_op			<= loadstore_op and not ir_rw;		--Read Ra when storing 		
	
	--TODO: Halfword and byte long load/stores OR CR/LR load stores
	
	--Start of logic instruction decoding
	
	ir_shiftop		<= ir(3);	
	
	--Start of arithmethic instruction decoding	
	
	ir_carry_enable <= ir(3);
	
	compare_op		<= ir_aluop(0) and ir_aluop(1);		--Compare doesnt store result	
	cr_we				<= arith_op and compare_op;
	carry_enable <= ir_carry_enable;
	--TODO: Carry handling
	
	--Start of branch instruction decoding
	
	ir_lr_jump		<= ir(3);
	ir_cond			<= ir(5 downto 4);
	ir_lr_store 	<= ir(6);
	
	store_lr			<= branch_op and ir_lr_store;			--Store CIA in LR
	
	with ir_cond select
		cond_val <= cr(0) when "00",							--Branch on LT
						cr(1) when "01",							--Branch on BEQ
						cr(2) when "10",							--Branch on BGT
						'1'   when "11",							--Branch Always 
						'-'	when others;
	
	jump_i		<= branch_op	and		cond_val;
	r_jump		<= jump_i		and not	ir_lr_jump;		--Relative Jump
   lr_jump		<= jump_i		and		ir_lr_jump;		--Jump to LR
end idec_cl;