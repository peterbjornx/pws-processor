vsim work.tb_proc

add wave  -radix hex \
sim:/tb_proc/duv/dp_inst/clk \
sim:/tb_proc/duv/cnt \
sim:/tb_proc/CLOCK_24 \
sim:/tb_proc/KEY \
sim:/tb_proc/HEX0 \
sim:/tb_proc/HEX1 \
sim:/tb_proc/HEX2 \
sim:/tb_proc/HEX3 \
sim:/tb_proc/LEDR


add wave -divider div
add wave -radix hex\
sim:/tb_proc/duv/dp_inst/mem_in \
sim:/tb_proc/duv/dp_inst/mem_out \
sim:/tb_proc/duv/dp_inst/mem_rdaddress \
sim:/tb_proc/duv/dp_inst/mem_wraddress \
sim:/tb_proc/duv/dp_inst/mem_wren
add wave -divider div

add wave -radix hex \
sim:/tb_proc/duv/dp_inst/reg

add wave -radix hex  \
sim:/tb_proc/duv/dp_inst/ra \
sim:/tb_proc/duv/dp_inst/rb \
sim:/tb_proc/duv/dp_inst/rc \
sim:/tb_proc/duv/dp_inst/ra_out \
sim:/tb_proc/duv/dp_inst/rb_out \
sim:/tb_proc/duv/dp_inst/rc_out \
sim:/tb_proc/duv/dp_inst/ra_in

add wave -divider div

add wave -radix hex\
sim:/tb_proc/duv/dp_inst/cir \
sim:/tb_proc/duv/dp_inst/nir \
sim:/tb_proc/duv/dp_inst/lr \
sim:/tb_proc/duv/dp_inst/ir

add wave -divider div

add wave \
sim:/tb_proc/duv/dp_inst/cir_we \
sim:/tb_proc/duv/dp_inst/nir_we \
sim:/tb_proc/duv/dp_inst/lr_we \
sim:/tb_proc/duv/dp_inst/ir_we \
sim:/tb_proc/duv/dp_inst/ra_we \
sim:/tb_proc/duv/dp_inst/mux_cilr_sel \
sim:/tb_proc/duv/dp_inst/mux_ir_add_sel \
sim:/tb_proc/duv/dp_inst/mux_c_sel \
sim:/tb_proc/duv/dp_inst/mux_mem_sel


add wave -divider div
add wave  \
sim:/tb_proc/duv/dp_inst/alu_lt
add wave -radix hex  \
sim:/tb_proc/duv/dp_inst/mux_b \
sim:/tb_proc/duv/dp_inst/mux_c


add wave \
sim:/tb_proc/duv/curr_state

run 10us