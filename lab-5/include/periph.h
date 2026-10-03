#pragma once
#include <stdint.h>
#include <stdbool.h>

#include "STM32L432KC.h"
#include "util.h"

void enable_MSI_freq_compensation(void);
void configure_MSI_clock(void);
void configure_GPIO(void);
void configure_interrupts();