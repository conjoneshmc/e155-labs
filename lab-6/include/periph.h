#pragma once
#include <stdint.h>
#include <stdbool.h>

#include <stm32l432xx.h>

void enable_MSI_freq_compensation(void);
void configure_system_clock(void);
void configure_timers(void);
void configure_USART(void);
void configure_GPIO(void);