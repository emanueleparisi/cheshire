// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Emanuele Parisi <emanuele.parisi@unibo.it>

// Test cases for Zicfilp extension in M-mode.

#include <stdint.h>
#include "util.h"
#include "params.h"
#include "regs/cheshire.h"
#include "dif/clint.h"
#include "dif/uart.h"
#include "printf.h"


int main(void) {
    // Get system parameters and initialize UART
    uint32_t rtc_freq = *reg32(&__base_regs, CHESHIRE_RTC_FREQ_REG_OFFSET);
    uint64_t core_freq = clint_get_core_freq(rtc_freq, 2500);
    uart_init(&__base_uart, core_freq, __BOOT_BAUDRATE);

    // Start Zicfi test
    printf("==================\r\n");
    printf(" Landing Pad tests\r\n");
    printf("==================\r\n");

    return 0;
}

void trap_vector() {
    uint64_t mcause, mepc, mip, mie, mstatus, mtval;
    asm volatile("csrr %0, mcause; csrr %1, mepc; csrr %2, mip;"
                 "csrr %3, mie; csrr %4, mstatus; csrr %5, mtval"
                 : "=r"(mcause), "=r"(mepc), "=r"(mip), "=r"(mie), "=r"(mstatus), "=r"(mtval));
    printf("\r\n==== [ZSL] trap encountered ====\r\n"
           " mcause:     0x%016x\r\n mepc:       0x%016x\r\n mip:        0x%016x\r\n"
           " mie:        0x%016x\r\n mstatus:    0x%016x\r\n mtval:      0x%016x\r\n"
           "================================\r\n",
           mcause, mepc, mip, mie, mstatus, mtval);
    while (1) wfi();
}
