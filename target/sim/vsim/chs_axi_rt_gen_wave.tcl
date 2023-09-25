# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Thomas Benz <tbenz@iis.ee.ethz.ch>

onerror {resume}
quietly WaveActivateNextPane {} 0
set RT_LOC "/tb_cheshire_soc/fix/dut/gen_axi_rt/i_axi_rt_unit_top"

for {set i 0} {$i < 6} {incr i} {
    add wave -noupdate -group RT_$i       "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/*"
    add wave -noupdate -divider RT_Int_$i
    add wave -noupdate -group Splitter_$i "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/*"
    add wave -noupdate -group AR_chan_$i  "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_ar_chan/*"
    add wave -noupdate -group AW_chan_$i  "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_aw_chan/*"
    add wave -noupdate -group AR_cnt_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_ar_chan/i_axi_gran_burst_splitter_counters/*"
    add wave -noupdate -group AW_cnt_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_aw_chan/i_axi_gran_burst_splitter_counters/*"
    add wave -noupdate -group AR_idq_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_ar_chan/i_axi_gran_burst_splitter_counters/i_idq/*"
    add wave -noupdate -group AW_idq_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_aw_chan/i_axi_gran_burst_splitter_counters/i_idq/*"
    add wave -noupdate -group AR_lzc_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_ar_chan/i_axi_gran_burst_splitter_counters/i_lzc/*"
    add wave -noupdate -group AW_lzc_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_gran_burst_splitter/i_axi_gran_burst_splitter_aw_chan/i_axi_gran_burst_splitter_counters/i_lzc/*"
    add wave -noupdate -group Isolate_$i  "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_isolate/*"
    add wave -noupdate -group Buffer_$i   "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_axi_write_buffer/*"
    add wave -noupdate -group R_Decode_$i "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_addr_decode_ar/*"
    add wave -noupdate -group W_Decode_$i "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/i_addr_decode_aw/*"
    for {set r 0} {$r < 2} {incr r} {
        add wave -noupdate -group Counter_${i}_${r} "${RT_LOC}/gen_rt_units[$i]/i_axi_rt_unit/gen_regions[$r]/i_ax_rt_unit_counter_read/*"
    }
    add wave -noupdate -divider ""
    add wave -noupdate -divider ""
}

add wave -noupdate -divider System
add wave -noupdate -group Guard "${RT_LOC}/i_axi_rt_regbus_guard/*"
add wave -noupdate -group Regs  "${RT_LOC}/i_axi_rt_reg_top/*"

TreeUpdate [SetDefaultTree]
