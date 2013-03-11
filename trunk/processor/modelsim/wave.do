onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/reg(2)
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/reg(1)
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/reg(0)
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/cia
add wave -noupdate /tb_if/proc/dp_inst/ra_we
add wave -noupdate -radix hexadecimal /tb_if/clock
add wave -noupdate -radix hexadecimal /tb_if/reset
add wave -noupdate -radix hexadecimal /tb_if/rw
add wave -noupdate -radix hexadecimal /tb_if/data
add wave -noupdate -radix hexadecimal /tb_if/address
add wave -noupdate -radix hexadecimal /tb_if/rom_addr
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/mux_b
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/mux_c
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/alu_out
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/mem_write
add wave -noupdate -radix hexadecimal /tb_if/proc/dp_inst/mem_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59991679 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
configure wave -valuecolwidth 38
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1446371 ps}
