#pragma once
#include <stdint.h>
#include <stdbool.h>

#include <stm32l432xx.h>

void spi_begin(void);
void spi_end(void);
uint8_t spi_send_recv(uint8_t data);