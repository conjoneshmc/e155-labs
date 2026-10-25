onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aes_core_tb/clk
add wave -noupdate /aes_core_tb/load
add wave -noupdate /aes_core_tb/done
add wave -noupdate /aes_core_tb/key
add wave -noupdate /aes_core_tb/plaintext
add wave -noupdate /aes_core_tb/cyphertext
add wave -noupdate /aes_core_tb/expected
add wave -noupdate /aes_core_tb/dut/controller/state_update
add wave -noupdate /aes_core_tb/dut/controller/state_select
add wave -noupdate /aes_core_tb/dut/controller/only_add_round_key
add wave -noupdate /aes_core_tb/dut/controller/skip_mix_columns
add wave -noupdate /aes_core_tb/dut/controller/round_const
add wave -noupdate /aes_core_tb/dut/controller/round_num
add wave -noupdate /aes_core_tb/dut/datapath/cipher_state
add wave -noupdate /aes_core_tb/dut/datapath/next_cipher_state
add wave -noupdate /aes_core_tb/dut/datapath/key_state
add wave -noupdate /aes_core_tb/dut/datapath/next_key_state
add wave -noupdate /aes_core_tb/dut/datapath/after_sub_bytes
add wave -noupdate /aes_core_tb/dut/datapath/after_shift_rows
add wave -noupdate /aes_core_tb/dut/datapath/after_mix_columns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 307
configure wave -valuecolwidth 248
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {766 ns}
